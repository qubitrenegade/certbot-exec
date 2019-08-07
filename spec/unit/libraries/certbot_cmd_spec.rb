#
# Cookbook:: certbot-exec
# Spec:: libraries/certbot_cmd
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

require 'spec_helper'
require "#{base_dir}/libraries/certbot_cmd"

new_resource = Struct.new(:domains, :post_hook, :extra_args)
                .new(
                  ['domain-foo1', 'domain-bar2'],
                  ['post-hook foo 1', 'post-hook foo 2'],
                  ['--extra-args1', '--extra-args2']
                )

describe CertbotExec::CertbotCmd do
  let(:cb_cmd) { Object.new.extend(CertbotExec::CertbotCmd) }
  before do

    allow(cb_cmd)
      .to receive(:node)
      .and_return(Hashie::Mash.new(default_attrs_from_file))
    allow(cb_cmd)
      .to receive(:new_resource)
      .and_return(new_resource)
  end

  describe '#cmd' do
    it 'executes certbot with expected parameters' do
      full_cmd = 'certbot certonly -q --expand --dry-run '
      full_cmd += '--server https://acme-v02.api.letsencrypt.org/directory '
      full_cmd += '--email youneedtosetme@least.com --domains domain-foo1,domain-bar2 '
      full_cmd += "--post-hook 'post-hook foo 1' --post-hook 'post-hook foo 2' "
      full_cmd += '--extra-args1 --extra-args2'
      expect(cb_cmd.cmd).to eql full_cmd
    end
  end

  describe '#run' do
    it '"executes" "run"' do
      # This seems silly...  Is it really appropriate to test `shell_out!`?
      allow(cb_cmd).to receive(:shell_out!).and_return true
      expect(cb_cmd.run).to eql true
    end
  end
end