default["uptime_app"]["dir"]                              = "/opt/uptime"
default["uptime_app"]["user"]                             = "uptime"
default["uptime_app"]["log_dir"]                          = "#{node["uptime_app"]["dir"]}/log"
default["uptime_app"]["repository"]                       = "https://github.com/blackboard/uptime.git"
default["uptime_app"]["port"]                             = 8082
default["uptime_app"]["server_name"]                      = "uptime.example.com"

default["uptime_app"]["analyzer"]["update_interval"]      = 60000
default["uptime_app"]["analyzer"]["aggregation_interval"] = 600000
default["uptime_app"]["analyzer"]["ping_history"]         = 8035200000

default["uptime_app"]["mongodb"]["host"]                  = "127.0.0.1"
default["uptime_app"]["mongodb"]["database"]              = "uptime"
default["uptime_app"]["mongodb"]["user"]                  = "root"
default["uptime_app"]["mongodb"]["password"]              = ""

default["uptime_app"]["monitor"]["name"]                  = "origin"
default["uptime_app"]["monitor"]["api_endpoint"]          = "http://localhost:#{node["uptime_app"]["port"]}/api"
default["uptime_app"]["monitor"]["polling_interval"]      = 10000
default["uptime_app"]["monitor"]["timeout"]               = 5000
