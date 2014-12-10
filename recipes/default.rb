include_recipe "build-essential"
include_recipe "git"
include_recipe "nodejs"
include_recipe "apache2"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"
include_recipe "apache2::mod_proxy_balancer"
include_recipe "apache2::mod_lbmethod_byrequests"

gem_package "bson_ext"
node.set['mongodb']['config']['auth'] = true
node.set["mongodb"]["users"] = [{
        "username" => node["uptime_app"]["mongodb"]["user"],
        "password" => node["uptime_app"]["mongodb"]["password"],
        "roles" => ['dbAdmin'],
        "database" => node["uptime_app"]["mongodb"]["database"]
}]

include_recipe "mongodb::mongodb_org_repo"
include_recipe "mongodb"
include_recipe "logrotate"

user node["uptime_app"]["user"] do
  system true
  shell "/bin/false"
end

git node["uptime_app"]["dir"] do
  repository node["uptime_app"]["repository"]
  action :sync
  notifies :restart, "service[uptime-app]"
  notifies :restart, "service[uptime-status]"
  notifies :restart, "service[uptime-monitor]"
end

execute "npm-install" do
  cwd node["uptime_app"]["dir"]
  command "npm install"
end

node.set["apache"]["mpm"]  = "event"
apache_module "proxy"
apache_module "proxy_http"
apache_module "proxy_balancer"
apache_module "lbmethod_byrequests"

template "#{node["uptime_app"]["dir"]}/config/default.yaml" do
  mode "0644"
  source "production.yml.erb"
  variables(
    :port                           => node["uptime_app"]["port"],
    :mongodb_host                   => node["uptime_app"]["mongodb"]["host"],
    :mongodb_database               => node["uptime_app"]["mongodb"]["database"],
    :mongodb_user                   => node["uptime_app"]["mongodb"]["user"],
    :mongodb_password               => node["uptime_app"]["mongodb"]["password"],
    :monitor_name                   => node["uptime_app"]["monitor"]["name"],
    :api_endpoint                   => node["uptime_app"]["monitor"]["api_endpoint"],
    :monitor_polling_interval       => node["uptime_app"]["monitor"]["polling_interval"],
    :monitor_timeout                => node["uptime_app"]["monitor"]["timeout"],
    :analyzer_update_interval       => node["uptime_app"]["analyzer"]["update_interval"],
    :analyzer_aggregation_interval  => node["uptime_app"]["analyzer"]["aggregation_interval"],
    :analyzer_ping_history          => node["uptime_app"]["analyzer"]["ping_history"]
  )
  notifies :restart, "service[uptime-app]"
  notifies :restart, "service[uptime-monitor]"
end

template "#{node["uptime_app"]["dir"]}/config/status.yml" do
  mode "0644"
  source "production.yml.erb"
  variables(
    :port                           => node["uptime_app"]["status"]["port"],
    :mongodb_host                   => node["uptime_app"]["mongodb"]["host"],
    :mongodb_database               => node["uptime_app"]["mongodb"]["database"],
    :mongodb_user                   => node["uptime_app"]["mongodb"]["user"],
    :mongodb_password               => node["uptime_app"]["mongodb"]["password"],
    :monitor_name                   => node["uptime_app"]["monitor"]["name"],
    :api_endpoint                   => node["uptime_app"]["monitor"]["api_endpoint"],
    :monitor_polling_interval       => node["uptime_app"]["monitor"]["polling_interval"],
    :monitor_timeout                => node["uptime_app"]["monitor"]["timeout"],
    :analyzer_update_interval       => node["uptime_app"]["analyzer"]["update_interval"],
    :analyzer_aggregation_interval  => node["uptime_app"]["analyzer"]["aggregation_interval"],
    :analyzer_ping_history          => node["uptime_app"]["analyzer"]["ping_history"]
  )
  notifies :restart, "service[uptime-status]"
  notifies :restart, "service[uptime-monitor]"
end

file "#{node["uptime_app"]["dir"]}/config/runtime.json" do
  owner node["uptime_app"]["user"]
  mode "0755"
  action :create
end



apache_site "000-default" do
  enable false
end

web_app "uptime" do
  template "uptime.conf.erb"
  docroot "#{node["uptime_app"]["dir"]}/app/dashboard/public"
  server_name node["uptime_app"]["server_name"]
end

directory node["uptime_app"]["log_dir"] do
  mode "0755"
  owner node["uptime_app"]["user"]
  group node["uptime_app"]["user"]
end

logrotate_app "uptime" do
  cookbook "logrotate"
  path "#{node["uptime_app"]["log_dir"]}/*.log"
  frequency "daily"
  rotate 7
  create "644 root root"
end

include_recipe "mongodb::user_management"

[ "uptime-app", "uptime-monitor", "uptime-status" ].each do |component|
  template "/etc/init/#{component}.conf" do
    mode "0644"
    source "#{component}.conf.erb"
    variables(
      :dir     => node["uptime_app"]["dir"],
      :user    => node["uptime_app"]["user"],
      :log_dir => node["uptime_app"]["log_dir"]
      )
    notifies :restart, "service[#{component}]"
  end

  service component do
    provider Chef::Provider::Service::Upstart
    action [ :enable, :start ]
  end
end
