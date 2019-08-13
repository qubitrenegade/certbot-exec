#
# Cookbook:: certbot-exec
# Spec:: resources/certbot_pkg
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

describe 'certbot_pkg' do
  platform 'ubuntu'
  step_into :certbot_pkg

  stubs_for_resource do |res|
    allow(res).to receive(:cbe_packages)
      .and_return ['certbot']
  end

  context 'certbot_pkg resource with no input' do
    recipe do
      certbot_pkg 'certbot'
    end

    it { is_expected.to install_certbot_pkg 'certbot' }
    it 'should install certbot package' do
      is_expected.to install_package('install-certbot')
        .with(package_name: ['certbot'])
    end
  end
  context 'certbot_pkg with string input' do
    recipe do
      certbot_pkg 'install-foo' do
        packages 'foo'
      end
    end

    it { is_expected.to install_certbot_pkg 'install-foo' }
    it 'should install certbot and foo' do
      is_expected.to install_package('install-certbot')
        .with(package_name: %w(certbot foo))
    end
  end
  context 'certbot_pkg with array input' do
    recipe do
      certbot_pkg 'foo' do
        packages %w(foo bar)
      end
    end

    it 'should install certbot, with foo and bar' do
      is_expected.to install_package('install-certbot')
        .with(package_name: %w(certbot foo bar))
    end
  end
end
