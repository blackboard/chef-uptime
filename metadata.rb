name              "uptime"
maintainer        "Blackboard"
maintainer_email  "dashman@blackboard.com"
license           "Apache 2.0"
description       "Installs and configures Uptime."
version           "0.1.9"
recipe            "uptime", "Installs and configures Uptime"

%w{ apache2 git logrotate mongodb nodejs }.each do |d|
  depends d
end

%w{ ubuntu }.each do |os|
    supports os
end
