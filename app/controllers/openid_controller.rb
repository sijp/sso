class OpenidController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :basic_authenticate, only: :token

  def authorize
    permitted_param_keys = [:response_type, :client_id, :redirect_uri, :scope, :state]
    permitted_param = params.permit(*permitted_param_keys)
    login_info = cookies[:login_info]
    auth_params = login_info ? JSON.parse(login_info).merge(permitted_param).symbolize_keys : permitted_param.to_h

    response_type, client_id, redirect_uri, scope, state = auth_params.values_at(*permitted_param_keys)
    session_token = cookies[:session_token]
    if response_type == "code" && !session_token.blank?
      user = User.find_by_session_token(session_token)
      client = Client.find_by_client_id(client_id)
      unless user.blank? || client.blank?
        access_code = AccessCode.create({ user: user, client: client })
        redirect_to "#{redirect_uri}?code=#{access_code.code}&state=#{state}"
        return
      end
    end

    cookies[:login_info] = JSON.generate permitted_param.to_h

    redirect_to "/login"
  end

  def token
    grant_type, code, redirect_uri = params.values_at(:grant_type, :code, :redirect_uri)
    user = AccessCode.find_by_code(code).user
    render json: @client.create_openid_tokens(user)
  end

  private

  def get_client(client_id, client_secret)
    @client = Client.find_by_client_id(client_id)
    @client.check_password(client_secret)
  end

  def basic_authenticate
    client_id, client_secret = params.values_at(:client_id, :client_secret)

    authenticated = client_id && client_secret ?
      get_client(client_id, client_secret) :
      authenticate_with_http_basic { |client_id, client_secret| get_client(client_id, client_secret) }

    unless authenticated
      render json: { response: "Bad Credentials" }, status: 401
    end
  end
end
