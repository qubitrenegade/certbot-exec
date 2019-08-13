## Design

This cookbook is the result of a (perhaps misguided) [attempt](https://github.com/qubitrenegade/certbot-exec/tree/c82a257dde8c7edca706b499f205485295a49be4) to 'solve' the "Chicken and egg" problem of setting up a web server with a self signed cert to obtain a Let's Encrypt signed SSL certificate', which then requires editing the nginx config, and restarting nginx.  The idea was a "pluggable" cookbook that could provide an easy to use interface to the `certbot` cli tool, and be easily extendible such that adding a different authentication plugin would be about the specifics rather than the implementation.

While working on that problem it was discovered that executing the `certbot` command multiple times in a row was often met with errors, causing subsequent services to have an invalid cert.  The prevailing idea being that, we're running multiple services on this host or we have one host we expose to the public internet that we use to register multiple domain names for, and we really only want to execute `certbot` once for all domain names.  The second problem was solved by leveraging Chef's "[Accumulator Pattern](https://blog.dnsimple.com/2017/10/chef-accumulators/)".  (Frankly, I am really fuzzy on `converge_by` and `with_run_context`.)

So if I'm writing an `xmpp` cookbook, it might run on one server with my `nginx` cookbook today.  But tomorrow, it's likely to run on separate servers.  I should be able to call `my_custom_resource` from each cookbook without worrying about what the other cookbook is doing, but `my_custom_resource` would "do the right thing" and only "Execute" once.

The original thought was this cookbook would provide `certbot_exec` which would ensure we could `certbot --blah` and provide an easy interface to provide, for instance `certbot_cf`.  In the end the user would be able to execute `certbot_cf` which would just leverage the `certbot_exec` resource by injecting the requisite parameters.

There is a shortcoming here, in that, what if I want to combine two certbot plugins.  Say we want to use the `nginx` installer and the `cloudflare-dns` authenticator?

Do I call both resources?

```ruby
   certbot_nginx 'foo.bar.com'
   certbot_cf 'foo.bar.com'
```

After thinking about it, what I think is really the best user interface is for the user to execute `certbot_exec` and allow additional plugins to modify the `certbot_exec` resource.

In the user `metadata.rb`

```ruby
depends 'certbot-exec'
depends 'certbot-exec-cloudflare'
```

And then is able to:

```ruby
certbot_exec 'foo.bar.com'
...
certbot_exec 'bar.bar.com'
```

and `certbot_exec` is either smart enough, or, doesn't need to know about `certbot-plugin-cloudflare-dns` and whatever is necessary to make that plugin happy happens.

Validation is a real interesting one...

I imagine, you couldn't run `certbot-plugin-nginx` with `certbot-plugin-apache`...  (for sure you can't do `certbot ... --nginx -a cloudflare-dns ...` you have to do `certbot ... -i nginx -a cloudflare-dns ...`)


## Discussion/Comments

We probably want Chef to manage `nginx` restarts for instance.  However, at this point we're not really sure when we're renewing the cert from chef... so we're _trying_ to defer to `certbot` to do the actual restarting..

Also, design is not set in stone...  e.g.:, is there a way to load the helpers from the ohai plugin?

I can't figure out how to stub `include_recipe` for a custom resource...

## Extending

By taking advantage of the [prepend](https://ruby-doc.org/core-2.6.3/Module.html#method-i-prepended) method, we can modify the response from methods.

To add extra args, we can define our own module `CertbotExec::Cloudflare`, then "`prepend`" `CertbotExec::Cloudflare` to `CertbotExec::CertbotCmd`.  

```ruby
module CertbotExec
  module Cloudflare
    include CloudflareHelpers
    def extra_args
      [
        '-a dns-cloudflare',
        '--dns-cloudflare-credentials /some/path',
        '--dns-cloudflare-propagation-seconds 20',
      ] + super
    end
  end
  module CertbotCmd
    prepend Cloudflare
  end
end
```
