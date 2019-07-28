Ohai.plugin :Certbot do
  provides 'certbot', 'certbot/certs', 'certbot/valid', 'certbot/days_remain', 'certbot/remain_30'
  provides 'certbot/san_list', 'certbot/ssl_cert_path', 'certbot/ssl_key_path'

  # 24 hrs/day * 60 minutes / hr * 60 seconds / minute
  sec_per_day = 86400
  cert_path = '/etc/letsencrypt/live'.freeze

  collect_data :default do
    certbot(Mash.new)
    certbot[:certs] = []

    if File.exist? cert_path
      dir_list(cert_path).each do |dir|
        cert = CertbotCert.new dir
        certbot[:certs] << cert
      end

      # Get the cert with the longest 
      cert = certbot[:certs].select { |cert| cert.valid? }
        .sort{ |a,b| b.time_remain <=> a.time_remain }.first
      
      certbot[:valid] = cert.valid?
      certbot[:days_remain] = cert.days_remain.to_i
      certbot[:remain_30] = cert.remain_30?
      certbot[:san_list] = cert.san_list
      certbot[:ssl_cert_path] = cert.ssl_cert_path
      certbot[:ssl_key_path] = cert.ssl_key_path
    else
      certbot[:days_remain] = 0
      certbot[:valid] = false
      certbot[:san_list] = []
    end
  end

  def dir_list(dir)
    Dir.glob("#{dir}/*").select {|f| File.directory? f}
  end
    
  class CertbotCert
    attr_reader :cert, :ssl_cert_path, :ssl_key_path

    def initialize(ssl_dir)
      @ssl_dir = ssl_dir
      @ssl_cert_path = File.join ssl_dir, 'fullchain.pem'
      @ssl_key_path = File.join ssl_dir, 'privkey.pem'
      @cert = OpenSSL::X509::Certificate.new(File.read(@ssl_file))
    end

    def cert_name
      cert.subject.to_utf8.gsub('CN=','')
    end

    def sec_per_day
      # 24 hrs/day * 60 minutes / hr * 60 seconds / minute
      86400
    end

    def exp_date
      cert.not_after
    end

    def valid?
      exp_date > Time.now
    end

    def time_remain
      exp_date - Time.now
    end

    def days_remain
      time_remain / sec_per_day
    end

    def remain_30?
      days_remain > 30
    end

    def san_list
      cert.extensions
        .select { |e| e.oid == 'subjectAltName' }
        .map{ |e| e.value.gsub('DNS:', '') }
    end
  end
end
