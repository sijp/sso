class User < SafeCredentialsRecord
  has_many :access_codes, lambda { where created_at: 10.seconds.ago.. }

  def payload
    {
      name: self.name,
      email: self.email,
      iat: DateTime.now.getutc.to_i,
      iss: "http://localhost:3000",
      sub: self.email,
      aud: "all",
      exp: 15.minutes.from_now.to_i,
    }
  end

  def create_session_token
    TokenHelper::create_token self.payload
  end

  def self.find_by_session_token(token)
    begin
      claims = TokenHelper::decode_token(token)
    rescue Exception
      return nil
    end
    User.find_by_email(claims["email"])
  end
end
