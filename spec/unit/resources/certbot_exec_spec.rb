#
# Cookbook:: certbot-exec
# Spec:: resources/certbot_exec
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
# THE SOFTWARE

require 'spec_helper'

describe 'certbot_exec' do
  platform 'ubuntu'
  step_into :certbot_exec

  context 'certbot_exec resource with no input' do
    recipe do
      certbot_exec 'foo.example.com'
    end
    
    it { is_expected.to install_certbot_exec 'foo.example.com' }

    # all fail with 'undefined method `node' for nil:NilClass'...
    it { is_expected.to create_ohai_plugin 'certbot' }
    it { is_expected.to create_certbot_repo 'repo' }
    it { is_expected.to install_certbot_pkg 'certbot' }
    it { is_expected.to exec_certbot_cmd 'execute-certbot' }
  end
end
