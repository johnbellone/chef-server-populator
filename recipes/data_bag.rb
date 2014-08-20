#
# Cookbook Name:: chef-server-populator
# Recipe:: data_bag
#
# Copyright (C) 2013 Heavy Water Software Inc.
# Copyright (C) 2014 Bloomberg Finance L.P.
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
return if Chef::Config[:solo]

clients = {}.merge(node['chef_server_populator']['clients'])
bag_name = node['chef_server_populator']['bag_name']
bag_search = node['chef_server_populator']['bag_search']

# This assumes structure of the data bag item from the README file.
search(bag_name, bag_search).each do |name|
  item = data_bag_item(bag_name, name)
  next unless item[:chef_server]
  next unless item[:chef_server][:enabled]
  clients[name] = item[:chef_server]
end

node.set['chef_server_populator']['clients'] = clients

include_recipe 'chef-server-populator::default'