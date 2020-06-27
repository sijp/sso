class OpenidController < ApplicationController
  #skip_before_action :verify_authenticity_token
  before_action :basic_authenticate, only: :token

  def authorize
    auth_params = cookies[:login_info]&.merge(params) || params

    response_type, client_id, redirect_uri, scope, state = auth_params.values_at(:response_type, :client_id, :redirect_uri, :scope, :state)
    session_token = cookies[:session_token]
    if response_type == "code" && !session_token.blank?
      user = User.find_by_session_token(session_token)
      client = Client.find_by_client_id(client_id)
      unless user.blank? && client.blank?
        access_code = AccessCode.create({ user: user, client: client })
        redirect_to "#{redirect_uri}?code=#{access_code.code}&state=#{state}"
        return
      end
    end

    cookies[:login_info] = JSON.generate params
    redirect_to "/login"
  end

  def token
    grant_type, code, redirect_uri = params.values_at(:grant_type, :code, :redirect_uri)
    user = AccessCode.find_by_code(code).user
    render json: @client.create_openid_tokens(user)
  end

  private

  def basic_authenticate
    authenticated = authenticate_with_http_basic do |client_id, client_secret|
      @client = Client.find_by_client_id(client_id)
      @client.check_password(client_secret)
    end

    unless authenticated
      render json: { response: "Bad Credentials" }, status: 401
    end
  end
end
