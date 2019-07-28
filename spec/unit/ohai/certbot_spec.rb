require 'spec_helper'
require 'chefspec/ohai'

describe_ohai_plugin :Certbot do
  let(:plugin_file) { 'files/default/certbot.rb' }

  it { expect(plugin).to provides_attribute 'certbot' }
  it { expect(plugin).to provides_attribute 'certbot/certs' }
  it { expect(plugin).to provides_attribute 'certbot/days_remain' }
  it { expect(plugin).to provides_attribute 'certbot/cert_valid' }
  it { expect(plugin).to provides_attribute 'certbot/san_list' }

  context 'before certbot has run' do
    it 'certbot should be a Mash' do
      expect(plugin_attribute 'certbot')
        .to be_a Mash
    end

    it 'certbot/certs should be {}' do
      expect(plugin_attribute('certbot/certs'))
         .to be_a Mash
    end

    it 'certbot/days_remain should be 0' do
      expect(plugin_attribute('certbot/days_remain'))
        .to eq 0
    end
  end

  context 'after certbot has run' do
    let(:ssl_cert) do
      File.read(File.join(base_dir, 'test/fixtures', 'test_cert.pem'))
    end

    before do
      # allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?)
        .with('/etc/letsencrypt/live').and_return(true)

      allow(Dir).to receive(:glob)
        .with('/etc/letsencrypt/live/*')
        .and_return([
          '/etc/letsencrypt/live/foo.example.com',
          '/etc/letsencrypt/live/README.md',
        ])

      allow(File).to receive(:directory?)
        .with('/etc/letsencrypt/live/foo.example.com')
        .and_return true
      allow(File).to receive(:directory?)
        .with('/etc/letsencrypt/live/README.md')
        .and_return false

      allow(File).to receive(:read).and_return(ssl_cert)
      allow(Time).to receive(:now)
        .and_return(Time.parse('2020-04-27 20:31:56 -0600'))
    end

    it 'sets certbot/days_remain' do
      expect(plugin_attribute 'certbot/days_remain')
        .to eq 500
    end
  end
end
