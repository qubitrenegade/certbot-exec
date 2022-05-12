unified_mode true

provides :certbot_repo
resource_name :certbot_repo

action :create do
  case node['platform']
  when 'centos', 'redhat', 'scientific', 'oracle'
    Chef::Log.warn "Untested on #{platform}" if platform?('redhat', 'scientific', 'oracle')
    include_recipe 'yum-epel'
  when 'ubuntu', 'debian'
    snap_package 'certbot'
  end
end
