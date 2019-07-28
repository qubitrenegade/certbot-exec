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
      certbot_pkg 'foo'
    end

    it 'installs certbot' do
      is_expected.to install_package('install-certbot')
        .with(package_name: ['certbot'])
    end
  end
  context 'certbot_pkg with string input' do
    recipe do
      certbot_pkg 'foo' do
        packages 'foo'
      end
    end

    it 'installs certbot and foo' do
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

    it 'installs certbot, with foo and bar' do
      is_expected.to install_package('install-certbot')
        .with(package_name: %w(certbot foo bar))
    end
  end
end
