# certbot-exec

This library cookbook aims to provide a unified interface for interacting with the `certbot` cli utility for generating and renewing [Let's Encrypt](https://letsencrypt.org/) ssl certificates.

As it is a library cookbook, it does not provide cookbooks to be included in your run-list (in fact, `certbot-exec::default` will warn you as such if it doesn't already).

If you are looking to get started quickly, skip to the [Getting Started](https://github.com/qubitrenegade/certbot-exec#usage) however, you might find the [Design](doc/DESIGN.md) documentation enlightening as this is not a cookbook designed to be consumed directly.

## Plugins

`certbot_exec` is designed to work with plugins.  Refer to [Extending](doc/DESIGN.md#extending) on information on how to write your own plugin.

* CloudFlare: [certbot-exec-cloudflare](https://github.com/qubitrenegade/certbot-exec-cloudflare) - adds [`certbot-dns-cloudflare`](https://certbot-dns-cloudflare.readthedocs.io/en/stable/) authenticator.

## Getting Started

### Include in `certbot-exec` in your Metadata

Include in your `metadata.rb`

#### metadata.rb

```ruby
depends 'certbot-exec'
```

### Set required attributes

* `default['certbot-exec']['agree_to_tos']` - you must set this `true` to denote your acceptance of LetsEncrypt TOS, documented [here](https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf) (PDF link warning).
* `default['certbot-exec']['email']` - Email to use with LetsEncrypt.

### Use `certbot_exec` Resource

`certbot_exec` can be called multiple times.  This will only result in one execution of `certbot`.

Note: The `certbot` utility will be executed at the _first_ instance of `certbot_exec` in the run list (order matters!)

```ruby
certbot_exec 'bar.com'

certbot_exec 'foo.example.com' do
  extra_args '--help'
  case node[:platform]
  when 'redhat', 'centos'
    packages 'python2-certbot-dns-cloudflare'
  when 'ubuntu', 'debian'
    packages 'python3-certbot-dns-cloudflare'
  end
  post_hook 'systemctl restart theinternet'
end

certbot_exec 'baz.example.com' do
  post_hook 'systemctl restart httpd'
end
```

This would result in an `apt install certbot python3-certbot-dns-cloudflare`. for the `package` resource. (instead of two invocations of `apt`)

also a `certbot` cli:

```sh
certbot ... -d bar.com,foo.example.com,baz.example.com ... --post-hook 'systemctl restart theinternet' --post-hook 'systemctl restart httpd' ... --help
```

## Resources

This cookbook provides three custom resources that are then wrapped in the `certbot_exec` resource.

### `certbot_exec`

#### Properties

* `domains` - `[String,Array]` - list of domains to generate SSL certificate.
* `post_hook` - `[String,Array]` - list of commands for `certbot` to execute after successfully generating a new certificate.
* `extra_args` - [String,Array] - list of additional arguments to pass to `certbot`.
* `packages` - `[String,Array]` - list of packages to install.
* `force` - `[True,False]` - defaults to false, if set to true will not validate cert and execute `certbot`.

#### Actions

* `:run` - setup certbot repo, install package, execute certbot.

#### Usage Example

```ruby
certbot_exec 'foo.com'
certbot_exec 'foo.com', 'bar.com'

certbot_exec 'execute-certbot' do
  domains 'foo.com'
  post_hook 'service nginx restart'
  extra_args '--help'
  action :install
end

certbot_exec 'execute-certbot-with-multiple-domains' do
  domains %w(foo.com bar.com example.foo.com example2.foo.com)
  post_hook ['service nginx restart', 'service redis restart']
  extra_args ['--someflag true', '--help']
  case node['platform']
  when 'redhat', 'centos'
    packages 'python2-certbot-dns-cloudflare'
  when 'ubuntu', 'debian'
    packages 'python3-certbot-dns-cloudflare'
  end
  action :install
end
```

### `certbot_repo`

This resource adds the `certbot` ppa on Ubuntu or includes `yum-epel` on CentOS/RHEL.  It takes no parameters.  The default action is `:create`.

#### Actions

* `:create` - create certbot repo

#### Usage Example

```ruby
certbot_repo 'certbot-repo'

certbot_repo 'certbot-repo-with-action' do
  action :create
end
```

### `certbot_pkg`

This resource installs packages.  It takes a list of packages to install.  The default and only action is `:install`.  The intent was to provide an interface to install additional packages, but it doesn't quite seem to work as expected...

#### Properties

* `packages` - `[String,Array]` - list of packages to install.

#### Actions

* `:install` - install packages.

#### Usage Example

```ruby
certbot_pkg 'certbot'

certbot_pkg ['certbot', 'openssl']

certbot_pkg 'certbot-packages' do
  packages ['certbot', 'openssl']
  action :install
end
```

### `certbot_cmd`

This resurce executes the `certbot` CLI command.  By default it attempts to validate the certificates in `/etc/letsencrypt/live` and executes if a valid cert isn't found.

#### Actions

* `:exec` - Validate cert and execute.
* `:force_exec` - Execute regardless if valid cert is found.

#### Properties

* `domains` - `[String,Array]` - list of domains to generate SSL certificate.
* `post_hook` - `[String,Array]` - list of commands for `certbot` to execute after successfully generating a new certificate.
* `extra_args` - [String,Array] - list of additional arguments to pass to `certbot`.
* `force` - [True,False]` - defaults to false, if set to true will not validate cert and execute `certbot`.

#### Usage Example

```ruby
certbot_cmd 'foo.com'
certbot_cmd 'foo.com', 'bar.com'

certbot_cmd 'execute-certbot' do
  domains 'foo.com'
  post_hook 'service nginx restart'
  extra_args '--help'
  action :force_exec
end

certbot_cmd 'execute-certbot-with-multiple-domains' do
  domains %w(foo.com bar.com example.foo.com example2.foo.com)
  post_hook ['service nginx restart', 'service redis restart']
  extra_args ['--someflag true', '--help']
  action :exec
end
```
