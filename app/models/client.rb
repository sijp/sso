class Client < SafeCredentialsRecord
  has_many :url_whitelists
  has_many :access_codes, lambda { where created_at: 10.seconds.ago.. }
  alias_attribute :password_hash, :client_secret_hash
  alias_attribute :client_secret, :password

  def whitelisted?(uri)
    self.url_whitelists.map(&:url).include?(uri)
  end

  def payload
    { aud: self.client_id }
  end

  def create_openid_tokens(user)
    id_token = TokenHelper::create_token user.payload.merge(self.payload)

    {
      access_token: "-",
      token_type: "Bearer",
      expires_in: 3600,
      refresh_token: "-",
      id_token: id_token,
    }
  end
end
