provides :certbot_repo
resource_name :certbot_repo

default_action :create

action :create do
  case node[:platform]
  when 'redhat', 'centos'
    include_recipe 'yum-epel'
  when 'ubuntu', 'debian'
    apt_repository 'certbot' do
      uri 'ppa:certbot/certbot'
    end
  end
end
