class AccessCode < ApplicationRecord
  belongs_to :user
  belongs_to :client

  def initialize(opts)
    super(code: SecureRandom.base64(10), user: opts[:user], client: opts[:client])
  end
end
