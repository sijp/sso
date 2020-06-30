class LoginController < ApplicationController
  def login
    email, password = params.values_at(:email, :password)

    if !email.blank? || !password.blank?
      cookies.delete :session_token
    end

    unless cookies[:session_token].blank?
      begin
        payload = TokenHelper.decode_token(cookies[:session_token])

        flash.alert = "Hello #{payload["name"]}"
        render :login
        return
      rescue Exception
      end
    end

    user = User.find_by_email(email)

    if user&.check_password(password)
      cookies[:session_token] = user.create_session_token
      if cookies[:login_info]
        redirect_to "/authorize"
      else
        redirect_to "/login"
      end
    else
      p email, password
      flash.alert = "Bad Credentials" unless email.blank? && password.blank?
      render :login
    end
  end
end
