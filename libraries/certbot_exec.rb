require_relative './certbot_pkg'

module CertbotExec
  module CertbotExecResource
    include PkgResource

    def initial_setup
      with_run_context :root do
        ohai_plugin 'certbot' do
          cookbook 'certbot-exec'
          action :create
        end

        ohai 'certbot' do
          plugin 'certbot'
          action :nothing
        end

        find_resource :certbot_repo, 'repo' do
          action :create
        end
      end
    end

    def certbot_packages_install
      find_r = with_run_context :root do
        find_resource :certbot_pkg, 'certbot' do |_new_resource|
          action :install
          packages []
          notifies :create, 'certbot_repo[repo]', :before
        end
      end
      find_r.packages += (new_resource.packages + package_list)
    end

    def certbot_exec_setup
      certbot_r = with_run_context :root do
        find_resource :certbot_cmd, 'execute-certbot' do |_new_resource|
          domains []
          post_hook []
          extra_args []
          notifies :install, 'certbot_pkg[certbot]', :before
          notifies :create, 'ohai_plugin[certbot]', :immediately
          notifies :reload, 'ohai[certbot]', :immediately
          action :exec
        end
      end
      certbot_r.force ||= new_resource.force
      certbot_r.domains += new_resource.domains
      certbot_r.post_hook += new_resource.post_hook
      certbot_r.extra_args += new_resource.extra_args
      certbot_r.action = if new_resource.force || certbot_r.action == :force_exec
                           :force_exec
                         else
                           :exec
                         end
    end
  end
end
