provides :certbot_pkg
resource_name :certbot_pkg

default_action :install

property :packages, [String, Array], default: [], coerce: proc { |x| [x].flatten }

action :install do
  package 'install-certbot' do
    extend CertbotExec::Helpers
    package_name cbe_packages + new_resource.packages
    action :install
  end
end
