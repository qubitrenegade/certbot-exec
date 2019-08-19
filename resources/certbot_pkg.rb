provides :certbot_pkg
resource_name :certbot_pkg

property :packages, [String, Array], name_property: true, coerce: proc { |x| [x].flatten }

action :install do
  package_resource
end

action_class do
  include CertbotExec::PkgResource
end
