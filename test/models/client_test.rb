require "test_helper"

class ClientTest < ActiveSupport::TestCase
  test "Setting password will generate correct hash and salt" do
    c = Client.new({ name: "C1", client_id: "a1b2" })
    c.client_secret = "1234"

    assert_not_nil c.client_secret_hash
    assert_not_nil c.salt
  end

  test "Check Password should work when correct password is given" do
    c = Client.new({ name: "C1", client_id: "a1b2" })
    c.client_secret = "1234"

    assert c.check_password "1234"
  end

  test "Check Password should fail when incorrect password is given" do
    c = Client.new({ name: "C1", client_id: "a1b2" })
    c.client_secret = "1234"

    assert_not c.check_password "5678"
  end

  test "Client password_hash and salt are not saveable" do
    c = Client.new({ name: "C1", client_id: "a1b2" })
    c.client_secret = "1234"
    old_hash = c.client_secret_hash
    old_salt = c.salt

    assert_equal old_hash, c.client_secret_hash
    assert_equal old_salt, c.salt
  end

  test "check if has whitelisted url" do
    client = Client.new name: "C1", client_id: "a1b2"
    client.url_whitelists = 5.times.map do |i|
      UrlWhitelist.new url: "https://example#{i}.com"
    end

    5.times do |i|
      assert client.whitelisted? "https://example#{i}.com"
    end

    assert_not client.whitelisted? "https://someotherurl.com"
  end

  test "openid tokens keys" do
    user = users(:one)
    client = clients(:one)

    tokens = client.create_openid_tokens(user)

    assert_empty tokens.keys - [
                   :access_token,
                   :token_type,
                   :expires_in,
                   :refresh_token,
                   :id_token,
                 ]
  end
end
