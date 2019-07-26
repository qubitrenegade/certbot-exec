provides :certbot_cmd
resource_name :certbot_cmd

property :domains, [String, Array], name_property: true, coerce: proc {|x| [x].flatten }
property :post_hook, [String, Array], default: [], coerce: proc {|x| [x].flatten }
property :extra_args, [String, Array], coerce: proc {|x| [x].flatten }

default_action :exec

action :exec do
  converge_by 'executing certbot cli command' do
    certbot
  end
end

action_class do
  include Chef::Mixin::ShellOut
  include CertbotExec::Helpers

  def certbot
    run
  end

  def run
    # Chef::Log.debug "certbot command: #{cmd}"
    puts "\n    certbot cli: #{cmd}" unless cbe_verbose
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
