module CertbotExec
  module Helpers
    def certbot_exec
      node['certbot-exec']
    end
    alias cbe certbot_exec

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

    def cbe_print_cmd
      cbe['print_cmd']
    end

    def cbe_server
      cbe['acme'][cbe['server']]
    end

    def certbot
      node['certbot']
    end
    alias cb certbot

    def cb_valid?
      cb['valid'] || false
    end

    def cb_remain_30?
      cb['remain_30'] || false
    end

    def cb_domain_includes?(domain_list)
      cb[san_list] == domain_list
    end
  end
end
