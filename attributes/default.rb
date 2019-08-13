default['certbot-exec'] = {
  # This is default to false,
  # you must set it to true to denote your acceptance of _their_ TOS
  # https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf
  agree_to_tos: false,

  # Set to your email you use with Lets Encrypt
  email: 'youneedtosetme@least.com',

  # If this should be a dry run, typically this should be false.
  dry_run: false,

  # Which ACME server to use
  server: 'prod',

  # list of packages, we expect this list to be concatnated
  # https://coderanger.net/arrays-and-chef/
  packages: ['certbot'],

  # echo debug info...  Chef::Log would be better...
  print_cmd: false,

  # acme server addresses, these should not need to be adjusted
  acme: {
    prod: 'https://acme-v02.api.letsencrypt.org/directory',
    stage: 'https://acme-staging-v02.api.letsencrypt.org/directory',
  },
}
