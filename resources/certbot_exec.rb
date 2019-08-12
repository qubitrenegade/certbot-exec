provides :certbot_exec
resource_name :certbot_exec

property :domains, [String, Array], name_property: true, coerce: proc { |x| [x].flatten }
property :post_hook, [String, Array], default: [], coerce: proc { |x| [x].flatten }
property :extra_args, [String, Array], default: [], coerce: proc { |x| [x].flatten }
property :packages, [String, Array], default: [], coerce: proc { |x| [x].flatten }
property :force, [TrueClass, FalseClass], default: false

default_action :install

action :install do
  initial_setup
  certbot_packages_install
  certbot_exec_setup
end

def after_created
  run_action(:install)
  action :nothing # don't run twice
end

action_class do
  include CertbotExec::CertbotExecResource
end