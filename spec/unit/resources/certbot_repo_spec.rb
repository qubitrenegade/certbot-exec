#
# Cookbook:: certbot-exec
# Spec:: resources/certbot_repo
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

describe 'certbot_repo' do
  step_into :certbot_repo

  before do
    stubs_for_provider do |res|
      allow(res).to receive(:include_recipe).and_return true
    end
  end

  context 'certbot_repo_resouce' do
    platform 'ubuntu'
    recipe do
      certbot_repo 'foo'
    end

    it { is_expected.to create_certbot_repo 'foo' }

    context 'on Centos' do
      platform 'centos'

      # it { is_expected.to include_recipe 'yum-epel' }
      it 'is expected to include_recipe "yum-epel"'
      it 'is having trouble figuring out how to stub include_recipe in a resource unit test'
    end

    context 'on Ubuntu' do
      platform 'ubuntu'

      it { is_expected.to add_apt_repository 'certbot' }
    end
  end
end
