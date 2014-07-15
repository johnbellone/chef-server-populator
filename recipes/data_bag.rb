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

clients = {}.merge(node['chef_server_populator']['clients'])
begin
  data_bag node['chef_server_populator']['databag'].each do |name|
    item = data_bag_item(node['chef_server_populator']['databag'], name)
    next unless item[:chef_server]
    clients[name] = item[:chef_server]
  end
rescue Net::HTTPServerException => e
  Chef::Log.warn "Chef Server failed to locate data bag #{node['chef_server_populator']['databag']}"
end

node.set['chef_server_populator']['clients'] = clients
