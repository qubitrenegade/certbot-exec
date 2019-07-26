provides :certbot_exec
resource_name :certbot_exec

property :domains, [String, Array], name_property: true, coerce: proc {|x| [x].flatten }
property :post_hook, [String, Array], default: [], coerce: proc {|x| [x].flatten }
property :extra_args, [String, Array], default: [], coerce: proc {|x| [x].flatten }
property :packages, [String, Array], default: [], coerce: proc {|x| [x].flatten }

default_action :install

action :install do
  certbot_repo 'repo' do
    action :create
  end

  certbot_pkg 'certbot' do
    action :install
    packages new_resource.packages
    notifies :create, 'certbot_repo[repo]', :before
  end

  certbot_cmd 'execute-certbot' do
    domains new_resource.domains
    post_hook new_resource.post_hook
    extra_args new_resource.extra_args
    notifies :install, 'certbot_pkg[certbot]', :before
    action :exec
  end
end
