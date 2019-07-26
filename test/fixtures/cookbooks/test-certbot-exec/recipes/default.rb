certbot_exec 'foo.example.com' do
  case node[:platform]
  when 'redhat', 'centos'
    packages 'python2-certbot-dns-cloudflare'
  when 'ubuntu', 'debian'
    packages 'python3-certbot-dns-cloudflare'
  end
  extra_args ' --help'
end

certbot_exec 'bar.example.com'
