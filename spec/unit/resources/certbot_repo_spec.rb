require 'spec_helper'

describe 'certbot_repo' do
  step_into :certbot_repo
  
  before do
    stubs_for_provider do |res|
      allow(res).to receive(:include_recipe).and_return true
    end
  end

  context 'certbot_repo_resouce' do

    recipe do
      certbot_repo 'foo'
    end

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
