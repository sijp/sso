module TokenHelper
  class BadToken < Exception
  end

  def self.create_token(payload)
    private_key = OpenSSL::PKey::RSA.new Rails.application.credentials[:private_key]

    JWT.encode payload, private_key, "RS256"
  end

  def self.decode_token(token)
    public_key = (OpenSSL::PKey::RSA.new Rails.application.credentials[:private_key]).public_key

    begin
      decoded_token = JWT.decode(token, public_key, true, { algorithm: "RS256" })
      decoded_token[0]
    rescue Exception => e
      puts e
      raise TokenHelper::BadToken.new("verification failed")
    end
  end
end
