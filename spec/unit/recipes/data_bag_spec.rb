require 'spec_helper'

describe 'chef-server-populator::data_bag' do
  let(:chef_run) do
    ChefSpec::Runner.new do
      node.set['chef_server_populator']['clients'] = {
        chef_server_populator: {
          clients: {
            jbellone: { client_key: 'foo', admin: true, },
          }
        }
      }
    end.coverge(described_recipe)
  end

  it { expect(chef_run).to include_recipe('chef-server-populator::default') }
end
