Ohai.plugin :Certbot do
  provides 'certbot', 'certbot/certs', 'certbot/days_remain'
  provides 'certbot/cert_valid', 'certbot/san_list'

  # 24 hrs/day * 60 minutes / hr * 60 seconds / minute
  sec_per_day = 86400
  cert_path = '/etc/letsencrypt/live'.freeze

  collect_data :default do
    certbot(Mash.new)
    certbot[:certs] = []

    if File.exist? cert_path
      dir_list(cert_path).each do |dir|
        cert = CertbotCert.new File.join dir, 'fullchain.pem'
        certbot[:certs] << cert
      end

      certbot.certs..select { |name,cert| cert.valid? }
        .sort_by{ 
        certbot[:days_remain] = 500
      
    else
      certbot[:days_remain] = 0
      certbot[:cert_valid] = false
      certbot[:san_list] = []
    end
  end

  def dir_list(dir)
    Dir.glob("#{dir}/*").select {|f| File.directory? f}
  end
    
  class CertbotCert
    attr_reader :cert, :ssl_file

    def initialize(ssl_file)
      @ssl_file = ssl_file
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

    def days_remain
      (exp_date - Time.now).to_i / sec_per_day
    end

    def remain_30?
      days_remain < 30
    end

    def san_list
      cert.extensions
        .select { |e| e.oid == 'subjectAltName' }
        .map{ |e| e.value.gsub('DNS:', '') }
    end
  end
end
