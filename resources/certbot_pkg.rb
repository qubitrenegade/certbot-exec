provides :certbot_pkg
resource_name :certbot_pkg

property :packages, [String, Array], name_property: true, coerce: proc { |x| [x].flatten }

action :install do
  package 'install-certbot' do
    extend CertbotExec::Helpers
    package_name (cbe_packages + new_resource.packages).uniq
    action :install
  end
end
