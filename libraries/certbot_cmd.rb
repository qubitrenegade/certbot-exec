#
# Cookbook:: certbot-exec
# Library:: certbot_cmd
#
# The MIT License (MIT)
#
# Copyright:: 2019, Qubit Renegade
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require_relative './helpers'

module CertbotExec
  module CertbotCmd
    include CertbotExec::Helpers

    attr_writer :post_hook, :extra_args

    def initialize(*args)
      @post_hook = []
      @extra_args = []
      super *args
    end

    def certbot
      run
    end

    def run
      # Chef::Log.debug "certbot command: #{cmd}"
      puts "\n    certbot cli: '#{cmd}'" if cbe_print_cmd
      shell_out!(
        cmd,
        live_stream: STDOUT
      )
    end

    def post_hooks
      @post_hook + new_resource.post_hook
    end

    def extra_args
      @extra_args + new_resource.extra_args
    end

    def cmd
      cmd = 'certbot certonly -q'
      cmd += ' --expand'
      cmd += ' --dry-run' if cbe_dry_run?
      cmd += ' --agree-tos' if cbe_agree_to_tos?
      cmd += " --server #{cbe_server}"
      cmd += " --email #{cbe_email}" if cbe_email
      cmd += " --domains #{new_resource.domains.join ','}"
      post_hooks.each do |hook|
        cmd += " --post-hook '#{hook}'"
      end
      cmd += ' ' + extra_args.join(' ') unless extra_args.empty?
      cmd
    end
  end
end
