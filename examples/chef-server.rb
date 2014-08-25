require 'openssl'

root_path = File.join(File.dirname(__FILE__), '.chef')

# Use data bags to populate the Chef Zero server. These data bags will
# then be used by the chef-server-populator recipe during provisioning.
chef_data_bag 'admins'
%w(jbellone pyanni ske vrosero).each do |name| 
  key = OpenSSL::PKey::RSA.new(2048)

  # Save the private key locally on disk so that it can be used for
  # any API calls or general administration of the Chef Server.
  IO.write(File.join(root_path, "#{name}.pem"), key.to_pem)

  # Create an item inside of the 'admins' data bag which will contain
  # the user information to be populated in the new Chef Server. The
  # client key is included as part of this.
  chef_data_bag_item name do
    data_bag 'admins'
    raw_data({
      chef_server: {
        enabled: true,
        admin: true,
        client_key: key.public_key.to_pem,
      }
    })
  end
end

machine 'chef-server' do
  run_list ['chef-server-populator::data_bag']
  tag 'blp.chef-server'
end
