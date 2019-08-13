provides :certbot_repo
resource_name :certbot_repo

action :create do
  case node['platform']
  when 'centos', 'redhat', 'scientific', 'oracle'
    Chef::Log.warn "Untested on #{platform}" if %w(redhat scientific oracle).include? node['platform']
    include_recipe 'yum-epel'
  when 'ubuntu', 'debian'
    apt_repository 'certbot' do
      uri 'ppa:certbot/certbot'
    end
  end
end
