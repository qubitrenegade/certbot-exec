provides :certbot_repo
resource_name :certbot_repo

default_action :create

action :create do
  case node['platform']
  when 'centos', 'redhat', 'scientific', 'oracle'
    Chef::Log.warn "Untested on #{platform}" unless (node['platform'] & %w(redhat scientific oracle)).empty?
    include_recipe 'yum-epel'
  when 'ubuntu', 'debian'
    apt_repository 'certbot' do
      uri 'ppa:certbot/certbot'
    end
  end
end
