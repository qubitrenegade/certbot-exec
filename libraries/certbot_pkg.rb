require_relative './helpers'
module CertbotExec
  module PkgResource
    include Helpers

    def package_list
      cbe_packages + new_resource.packages
    end

    def package_list_unique
      package_list.uniq
    end

    def package_resource
      package 'install-certbot' do
        package_name package_list
        action :install
      end
    end
  end
end
