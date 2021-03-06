#
# Cookbook Name:: chef-server-populator
# Attribute:: default
#
# Copyright (C) 2013 Heavy Water Operations, LLC.
# Copyright (C) 2014 Bloomberg L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
default['chef_server_populator']['clients'] = {}
default['chef_server_populator']['users'] = {}
default['chef_server_populator']['admins'] = {}
default['chef_server_populator']['sysadmins'] = {}
default['chef_server_populator']['user'] = 'admin'
default['chef_server_populator']['pem'] = '/etc/chef-server/admin.pem'
default['chef_server_populator']['bag_search'] = '*:*'
