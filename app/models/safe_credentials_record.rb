class SafeCredentialsRecord < ActiveRecord::Base
  self.abstract_class = true
  def password=(pswd)
    self[:salt] = SecureRandom.base64(10)
    self[:password_hash] = hash_with_salt(pswd)
  end
  
  def password_hash=(_)
    raise "Don't use"
  end

  def salt=(_)
    raise "Don't use"
  end
  
  def check_password(pswd)
    hash_with_salt(pswd) == self.password_hash
  end

  def hash_with_salt(pswd)
    Digest::SHA256.base64digest("#{pswd}:#{self.salt}")
  end
end