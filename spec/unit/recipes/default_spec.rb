require 'spec_helper'

describe 'chef-server-populator::default' do
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

  let(:knife_opts) { %q{-k /etc/chef-server/admin.pem -u admin -s https://127.0.0.1:443} }

  context 'creates client and sets key from attributes' do
    before do
      opts = knife_opts.concat(' --admin')
      stub_command(%Q{knife client list #{opts}|tr -d ' '|grep '^jbellone$'}).and_return(false)
    end
    it do
      resource = chef_run.bash('set key: jbellone')
      expect(resource).to subscribe_to('bash[create client: jbellone]').on(:run)
    end
    it { expect(chef_run).not_to run_bash('delete client: jbellone') }
    it { expect(chef_run).to run_bash('create client: jbellone') }
    it { expect(chef_run).to run_bash('set key: jbellone') }
  end
end
