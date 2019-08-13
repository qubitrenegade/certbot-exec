#
# Cookbook:: certbot-exec
# Spec:: libraries/helpers_spec
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
require "#{base_dir}/libraries/helpers"

describe CertbotExec::Helpers do
  let(:cbeh) { Object.new.extend(CertbotExec::Helpers) }
  before do
    allow(cbeh)
      .to receive(:node)
      .and_return(Hashie::Mash.new(default_attrs_from_file))
  end

  describe '#certbot_exec' do
    it 'returns certbot-exec hash' do
      expect(cbeh.certbot_exec).to be_kind_of Hashie::Mash
    end

    it 'responds to cbe as an alias' do
      expect(cbeh.cbe).to be_kind_of Hashie::Mash
    end
  end

  describe '#cbe_dry_run?' do
    it 'checks for dry run' do
      expect(cbeh.cbe_dry_run?).to eql false
    end
  end

  describe '#cbe_agree_to_tos?' do
    it 'is false by default' do
      expect(cbeh.cbe_agree_to_tos?).to be false
    end
  end

  describe '#cbe_server' do
    it 'returns the correct server' do
      expect(cbeh.cbe_server).to eql 'https://acme-v02.api.letsencrypt.org/directory'
    end
  end
end
