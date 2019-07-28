require 'spec_helper'
require "#{base_dir}/libraries/helpers"

describe CertbotExec::Helpers do
  let(:cbeh) { Object.new.extend(CertbotExec::Helpers) }
  before do
    default = {}
    eval(
      File.read(
        File.join(base_dir, 'attributes', 'default.rb')
      )
    )

    allow(cbeh)
      .to receive(:node)
      .and_return(Hashie::Mash.new default)
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
      expect(cbeh.cbe_dry_run?).to eql true
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
