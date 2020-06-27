class LoginController < ApplicationController
  skip_before_action :verify_authenticity_token

  def login
    email, password = params.values_at(:email, :password)
    user = User.find_by_email(email)

    response = user&.check_password(password) ?
      { response: user.create_session_token } :
      { response: "Bad Credentials", status: 401 }

    respond_to do |format|
      format.json { render json: response }
    end
  end
end
