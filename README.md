# uptime [![Build Status](https://secure.travis-ci.org/hectcastro/chef-uptime.png?branch=master)](http://travis-ci.org/hectcastro/chef-uptime)

## Description

Installs and configures [Uptime](http://fzaninotto.github.com/uptime/).

## Requirements

### Platforms

* Ubuntu 12.04 (Precise)

### Cookbooks

* apache2
* git
* logrotate
* mongodb
* nodejs

## Attributes

* `node["uptime_app"]["dir"]` - Directory to install into.
* `node["uptime_app"]["user"]` -  User for Uptime.
* `node["uptime_app"]["log_dir"]` - Log directory.
* `node["uptime_app"]["repository"]` - Reference to an Uptime repository.
* `node["uptime_app"]["port"]` - Port for Uptime web interface.
* `node["uptime_app"]["server_name"]` – Web server server name.
* `node["uptime_app"]["analyzer"]["update_interval"]` – Update interval for 
  Uptime's analyzer in milliseconds.
* `node["uptime_app"]["analyzer"]["aggregation_interval"]` – Aggregation
  interval for Uptime's analyzer in milliseconds.
*  `node["uptime_app"]["analyzer"]["ping_history"]` – Ping history to keep in
  milliseconds.
* `node["uptime_app"]["mongodb"]["host"]` – MongoDB host.
* `node["uptime_app"]["mongodb"]["database"]` – MongoDB database name.
* `node["uptime_app"]["mongodb"]["user"]` – MongoDB username.
* `node["uptime_app"]["mongodb"]["password"]` – MongoDB password.
* `node["uptime_app"]["monitor"]["name"]` – Name for Uptime's monitor.
* `node["uptime_app"]["monitor"]["api_endpoint"]` – Uptime API endpoint URL.
* `node["uptime_app"]["monitor"]["polling_interval"]` – Polling interval for
  Uptime's monitor in milliseconds.
* `node["uptime_app"]["monitor"]["timeout"]` – Timeout for Uptime's monitor in
  milliseconds.

## Recipes

* `recipe[uptime]` will install Uptime.

## Usage

Currently only supports a single MongoDB instance running on the same node.

## Vagrant

	> vagrant plugin install vagrant-berkshelf
	> vagrant plugin install vagrant-omnibus
	> vagrant up

Requires Vagrant 1.5+