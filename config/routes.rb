Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post "/login", to: "login#login"
  get "/login", to: "login#login"

  post "/token", to: "openid#token"
  get "/authorize", to: "openid#authorize"
end
