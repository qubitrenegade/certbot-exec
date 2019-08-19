provides :certbot_cmd
resource_name :certbot_cmd

property :domains, [String, Array], name_property: true, coerce: proc { |x| [x].flatten }
property :post_hook, [String, Array], default: [], coerce: proc { |x| [x].flatten }
property :extra_args, [String, Array], coerce: proc { |x| [x].flatten }
property :force, [TrueClass, FalseClass], default: false

action :exec do
  if new_resource.force
    converge_by 'force execute certbot command' do
      certbot
    end
  elsif !cb_valid? || !cb_remain_30?
    converge_by 'execute certbot command' do
      certbot
    end
  end
end

action :force_exec do
  converge_by 'execute force_exec certbot command' do
    certbot
  end
end

action_class do
  include CertbotExec::CertbotCmd
end
