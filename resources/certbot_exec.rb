provides :certbot_exec
resource_name :certbot_exec

property :domains, [String, Array], name_property: true, coerce: proc { |x| [x].flatten }
property :post_hook, [String, Array], default: [], coerce: proc { |x| [x].flatten }
property :extra_args, [String, Array], default: [], coerce: proc { |x| [x].flatten }
property :packages, [String, Array], default: [], coerce: proc { |x| [x].flatten }

default_action :install

action :install do
  r = with_run_context :parent do
    find_resource :certbot_repo, 'repo' do
      action :create
    end
  end

  find_r = with_run_context :parent do
    find_resource :certbot_pkg, 'certbot' do |_new_resource|
      action :install
      packages []
      notifies :create, 'certbot_repo[repo]', :before
    end
  end
  find_r.packages += new_resource.packages

  certbot_r = with_run_context :parent do
    find_resource :certbot_cmd, 'execute-certbot' do |_new_resource|
      domains []
      post_hook []
      extra_args []
      notifies :install, 'certbot_pkg[certbot]', :before
      action :exec
    end
  end
  certbot_r.domains += new_resource.domains
  certbot_r.post_hook += new_resource.post_hook
  certbot_r.extra_args += new_resource.extra_args
end

def after_created
  run_action(:install)
  action :nothing # don't run twice
end
