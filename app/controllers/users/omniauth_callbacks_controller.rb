# frozen_string_literal: true

module Users
  #  Google OAuth2 ログイン機能
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
      else
        session['devise.google_data'] = request.env['omniauth.auth'].except(:extra)
        redirect_to new_user_registration_url, alert: t('users.google_auth_fail')
      end
    end

    def failure
      redirect_to root_path, alert: t('users.login_fail')
    end
  end
end
