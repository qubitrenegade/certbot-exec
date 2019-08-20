name              'certbot-exec'
maintainer        'Qubit Renegade'
maintainer_email  'qubitrenegade@protonmail.com'
license           'MIT'
description       'Installs/Configures certbot-exec'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '0.1.2'
chef_version      '>= 13.0'

depends 'ohai'
depends 'yum-epel'

issues_url 'https://github.com/qubitrenegade/certbot-exec/issues'
source_url 'https://github.com/qubitrenegade/certbot-exec'

%w(centos ubuntu).each do |platform|
  supports platform
end
