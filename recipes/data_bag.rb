#
# Cookbook Name:: chef-server-populator
# Recipe:: data_bag
#
# Copyright (C) 2013 Heavy Water Software Inc.
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
return if Chef::Config[:solo]

%w(clients users admins sysadmins).each do |bag_name|
  items = {}.merge(node['chef_server_populator'][bag_name])

  search(bag_name, node['chef_server_populator']['bag_search']) do |item|
    next unless item[:chef_server]
    next unless item[:chef_server][:enabled]
    items.store(item[:id], item[:chef_server])
  end

  node.set['chef_server_populator'][bag_name] = items
end
