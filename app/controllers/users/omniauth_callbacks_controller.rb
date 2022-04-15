module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def github
      user = User.from_omniauth!(request.env["omniauth.auth"])
      authorizator = Authorizator.new

      if authorizator.allowed_to_log_in?(user)
        sign_in_and_redirect user
      else
        redirect_to root_path, notice: 'You are not allowed to log in'
      end
    end

    def failure
      redirect_to root_path
    end
  end
end
