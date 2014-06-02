directory node[:chef_server_populator][:backup][:dir] do
  recursive true
end

#Upload to Remote Storage
# Include fog
case node[:platform_family]
when 'debian'
  packages =  %w(gcc libxml2 libxml2-dev libxslt-dev)
when 'rhel'
  packages = %w(gcc libxml2 libxml2-devel libxslt libxslt-devel)
end
  packages.each do |fog_dep|

  package fog_dep do
    only_if{ node[:chef_server_populator][:backup][:remote][:connection] }
  end
end

%w( nokogiri fog ).each do |gem_name|
  gem_package gem_name do
    version node[:chef_server_populator][:gem_versions][gem_name]
    only_if{ node[:chef_server_populator][:backup][:remote][:connection] }
  end
end

template '/usr/local/bin/chef-server-backup' do
  mode '0700'
end

cron 'Chef Server Backups' do
  command '/usr/local/bin/chef-server-backup'
  node[:chef_server_populator][:backup][:schedule].each do |k,v|
    send(k,v)
  end
end
