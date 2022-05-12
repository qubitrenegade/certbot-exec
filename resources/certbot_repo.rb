unified_mode true

provides :certbot_repo
resource_name :certbot_repo

action :create do
  case node['platform']
  when 'centos', 'redhat', 'scientific', 'oracle'
    Chef::Log.warn "Untested on #{platform}" if platform?('redhat', 'scientific', 'oracle')
    include_recipe 'yum-epel'
  when 'ubuntu', 'debian'
    # Multiple people report problems with this resource, even on the slack chanel. https://chefcommunity.slack.com/archives/C0M1NGZE3/p1652383770807739
    # snap_package 'certbot' do
    #   package_name ['certbot']
    # end

    execute 'install_certbot' do
      command 'snap install --classic certbot'
      action :run
      not_if 'snap list certbot'
    end
  end
end
