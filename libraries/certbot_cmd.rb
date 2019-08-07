#
# Chef Documentation
# https://docs.chef.io/libraries.html
#

require_relative './helpers'

module CertbotExec
  module CertbotCmd
    include CertbotExec::Helpers

    def certbot
      run
    end
  
    def run
      # Chef::Log.debug "certbot command: #{cmd}"
      puts "\n    certbot cli: #{cmd}" unless cbe_print_cmd
      shell_out!(
        cmd,
        live_stream: STDOUT
      )
    end
  
    def cmd
      cmd = 'certbot certonly -q'
      cmd += ' --expand'
      cmd += ' --dry-run' if cbe_dry_run?
      cmd += ' --agree-tos' if cbe_agree_to_tos?
      cmd += " --server #{cbe_server}"
      cmd += " --email #{cbe_email}" if cbe_email
      cmd += " --domains #{new_resource.domains.join ','}"
      new_resource.post_hook.each do |hook|
        cmd += " --post-hook '#{hook}'"
      end
      # end unless new_resource.post_hook.empty?
      cmd += ' ' + new_resource.extra_args.join(' ') if new_resource.extra_args
      cmd
    end
  end
end