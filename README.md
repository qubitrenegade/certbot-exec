# certbot-exec

This library cookbook aims to provide a unified interface for interacting with the `certbot` cli utility for generating and renewing [Let's Encrypt](https://letsencrypt.org/) ssl certificates.

As it is a library cookbook, it does not provide cookbooks to be included in your run-list (in fact, `certbot-exec::default` will warn you as such if it doesn't already).

You probably don't want to use this cookbook directly either, instead opting to wrap it in your own custom provider.  However, as `certbot_exec` API IS designed to be wrapped by other resources, you _can_ provide enough parameters in your cookbook to use this resource directly.

If you are looking to get started quickly, skip to the [Usage](https://github.com/qubitrenegade/certbot-exec#usage) however, you might find the [Design](https://github.com/qubitrenegade/certbot-exec#usage) information enlightening as this is not a cookbook designed to be consumed directly...

## Design

This cookbook is the result of a (perhaps misguided) [attempt](https://github.com/qubitrenegade/certbot-exec/tree/c82a257dde8c7edca706b499f205485295a49be4) to 'solve the  "Chicken and egg" problem of setting up a web server with a self signed cert to obtain a Let's Encrypt signed SSL certificate' by leveraging Chef's "[Accumulator Pattern](https://blog.dnsimple.com/2017/10/chef-accumulators/)".  While I think this was a great learning experience and great exposure to the "Accumulator Pattern", I think it exposed some faults in the design of my API, my knowledge, and if I may be so bold, the Chef docs.  Frankly, I am really fuzzy on `converge_by` and `with_run_context`.

The prevailing idea being that, we're running multiple services on this host or we have one host we expose to the public internet that we use to register multiple domain names for, and we really only want to execute `certbot` once for all domain names.

So if I'm writing an `xmpp` cookbook, it might run on one server with my `nginx` cookbook today.  But tomorrow, it's likely to run on separate servers.  So I should be able to call `my_custom_resource` from each cookbook without worrying about what the other cookbook is doing, but `my_custom_resource` would "do the right thing" and only "Execute" once.

The original thought was this cookbook would provide `certbot_exec` which would ensure we could `certbot --blah` and provide an easy interface to provide, for instance `certbot_cf`.  In the end the user would be able to execute `certbot_cf` which would just leverage the `certbot_exec` resource by injecting the requisite parameters.

There is a shortcoming here, in that, what if I want to combine two certbot plugins.  Say we want to use the `nginx` installer and the `cloudflare-dns` authenticator?

Do I call both resources?

```ruby
   certbot_nginx 'foo.bar.com'
   certbot_cf 'foo.bar.com'
```

After thinking about it, what I think I really want to happen is for a user to add to their `metadata.rb`

```ruby
depends 'certbot'
depends 'certbot-plugin-cloudflare-dns'
```

And then is able to:

```ruby
certbot_exec 'foo.bar.com'
certbot_exec 'bar.bar.com'
```

and `certbot_exec` is either smart enough, or, doesn't need to know about `certbot-plugin-cloudflare-dns` and whatever is necessary to make that plugin happy happens.

Validation is a real interesting one...

I imagine, you couldn't run `certbot-plugin-nginx` with `certbot-plugin-apache`...  (for sure you can't do `certbot ... --nginx -a cloudflare-dns ...` you have to do `certbot ... -i nginx -a cloudflare-dns ...`)

## Discussion

The idea was that we might have multiple services running on one host where we want to generate our SSL certificates.  But we probably don't want to call `certbot` cli utility multiple times as it has trouble when rereregenerating certificates.  Basically, I want to run `cookbook_a` and `cookbook_b` on the same host today, but they'll likely need to run on separate hosts tomorrow.  So I want to write them like they know nothing about each other, but they need to play nicely with each other.  This should be easy to achieve with a common `certbot` API that can "roll" all invocations into one command.

We probably want Chef to manage `nginx` restarts for instance.  However, at this point we're not really sure when we're renewing the cert from chef... so we're _trying_ to defer to `certbot` to do the actual restarting..

Also, design is not set in stone...  Like, is there a way to load the helpers from the ohai plugin?

I can't figure out how to stub `include_recipe` for a custom resource...

## Usage

### Include in Metadata

Include in your `metadata.rb`

#### metadata.rb

```ruby
depends 'certbot-exec'
```

#### Use Resource

Use the resource, it can be called multiple times, but will only result in one execution of `certbot`.

Note: The `certbot` utility will be executed at the _first_ instance of `certbot_exec` in the run list (order matters!)

#### `certbot_exec`

```ruby
certbot_exec 'bar.com'

certbot_exec 'foo.example.com' do
  extra_args '--cloudflare-dns-whatever'
  case node[:platform]
  when 'redhat', 'centos'
    packages 'python2-certbot-dns-cloudflare'
  when 'ubuntu', 'debian'
    packages 'python3-certbot-dns-cloudflare'
  end
  post_hook 'systemctl restart theinternet'
  force true
  extra_args ' --help'
end

certbot_exec 'bar.example.com'

certbot_exec 'baz.example.com' do
  post_hook 'systemctl restart httpd'
end
```

#### Example

So for example, this whole thing would result in an `apt install certbot python3-certbot-dns-cloudflare`. for the `package` resource. (instead of `apt install certbot` then `apt install python3-certbot-dns-cloudflare` which is normally what happens when you call `package` twice...)

also a `certbot` cli:

```sh
certbot ... -d bar.com,foo.example.com,baz.example.com ... --post-hook 'systemctl restart theinternet' --post-hook 'systemctl restart httpd' ... --help
```

## TODO

* handle duplicate domain names... no idea what happens if `certbot_exec 'foo.com'; certbot_exec 'bar.com'; certbot_exec 'foo.com'`... should be `-d foo.com,bar.com`... but dunno.  and dunno if that errors?
