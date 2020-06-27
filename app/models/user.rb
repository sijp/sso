class User < SafeCredentialsRecord
  has_many :access_codes, lambda { where created_at: 10.seconds.ago.. }

  def payload
    {
      name: self.name,
      email: self.email,
      iat: DateTime.now.getutc.to_i,
      iss: "MyAwesomeSSO",
    }
  end

  def create_session_token
    TokenHelper::create_token self.payload
  end

  def self.find_by_session_token(token)
    claims = TokenHelper::decode_token(token)
    User.find_by_email(claims[:email])
  end
end
