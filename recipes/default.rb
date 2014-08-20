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

node['chef_server_populator']['clients'].each_pair do |name, item|
  opts = "-k #{node['chef_server_populator']['pem']}"
  opts << " -u #{node['chef_server_populator']['user']}"
  opts << ' -s https://127.0.0.1:443'
  opts << ' --admin' if item[:admin]
  opts << ' --validator' if item[:validator]

  bash "delete client: #{name}" do
    command "knife client delete #{name} -d #{opts}"
    only_if "knife client list #{opts}|tr -d ' '|grep '^#{name}$'"
  end

  bash "create client: #{name}" do
    command "knife client create #{name} -d #{opts}"
    not_if "knife client list #{opts}|tr -d ' '|grep '^#{name}$'"
  end

  bash "set key: #{name}" do
    command (<<-SCRIPT)
/opt/chef-server/embedded/bin/psql -d opscode_chef \
  -c \"UPDATE clients SET public_key=E'#{item[:client_key]}' WHERE name='#{name}'\"
SCRIPT
    user 'opscode-pgsql'
    subscribes :run, "bash[create client: #{name}]", :immediately
  end
end
