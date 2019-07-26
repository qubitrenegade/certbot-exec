
module CertbotExec
  module Helpers
    def certbot_exec
      node['certbot-exec']
    end
    alias_method :cbe, :certbot_exec

    def cbe_dry_run?
      cbe['dry_run']
    end

    def cbe_agree_to_tos?
      cbe['agree_to_tos']
    end

    def cbe_email
      cbe['email']
    end

    def cbe_packages
      cbe['packages']
    end

    def cbe_verbose
      cbe['print_cmd']
    end

    def cbe_server
      cbe['acme'][cbe['server']]
    end
  end
end
