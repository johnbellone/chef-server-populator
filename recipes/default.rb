#
# Cookbook Name:: chef-server-populator
# Recipe:: default
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
include_recipe 'chef-server::default'

include_recipe 'chef-sugar::default'
require_chef_gem 'cheffish'

local_server = {
  chef_server_url: 'https://127.0.0.1',
  options: {
    client_name: node['chef_server_populator']['user'],
    signing_key_filename: node['chef_server_populator']['pem']
  }
}

node['chef_server_populator']['clients'].each do |item|
  chef_client item[:id] do
    chef_server local_server
    source_key item[:client_key]
    validator item[:validator]
    admin item[:admin]
  end
end

node['chef_server_populator']['users'].each do |item|
  # In order to perform automatic administration of a Chef Server we are going
  # to need to rely on the fact that /etc/chef-server/admin.pem will always be
  # the correct key.
  next if item[:id] == node['chef_server_populator']['user']

  chef_user item[:id] do
    chef_server local_server
    source_key item[:client_key]
    admin item[:admin]
    email item[:email]
  end
end
