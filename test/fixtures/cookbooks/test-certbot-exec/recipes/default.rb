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

certbot_exec 'baz.example.com' do
  extra_args '--cloudflare-dns-whatever'
  post_hook 'systemctl restart httpd'
end

certbot_exec 'boz.example.com' do
  post_hook 'systemctl restart theworld'
  force true
end
