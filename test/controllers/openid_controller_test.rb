require "test_helper"

class OpenidControllerTest < ActionDispatch::IntegrationTest
  test "/authorize with no params should redirect to login" do
    get "/authorize"

    assert_redirected_to "/login"
  end

  test "/authorize will set cookies with params" do
    get "/authorize?p1=1&p2=2"

    login_info = JSON.parse cookies[:login_info]

    assert login_info["p1"], "1"
    assert login_info["p2"], "2"
  end

  test "/authorize will redirect to redirect_uri if cookies have good token" do
    user = users(:one)
    client = clients(:one)
    UrlWhitelist.create(url: "https://shlomi.com", client: client)
    redirect_uri = client.url_whitelists.first.url
    token = user.create_session_token
    cookies[:session_token] = token

    params = {
      response_type: "code",
      client_id: client.client_id,
      redirect_uri: redirect_uri,
      scope: "openid",
      state: "aaaa",
    }

    get "/authorize", params: params

    assert_redirected_to %r(\A#{redirect_uri})
  end

  test "/token will create a token for valid access code" do
    user = users(:one)
    client = clients(:one)
    client.client_secret = "1234"
    client.save!
    access_code = AccessCode.create({ user: user, client: client })
    basic_auth = ActionController::HttpAuthentication::Basic.encode_credentials(
      client.client_id,
      "1234"
    )

    post "/token",
         params: {
           grant_type: "",
           code: access_code.code,
           redirect_uri: client.url_whitelists.first,
         },
         headers: {
           Authorization: basic_auth,
         }
    assert_response :success
    body = JSON.parse @response.body

    assert_equal body.length, 5
    assert_empty body.keys - [
      "access_token",
      "token_type",
      "expires_in",
      "refresh_token",
      "id_token",
    ], "Token keys mismatch"
  end
end
