class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def after_sign_up_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def configure_permitted_parameters
    # サインアップ時とアカウント更新時に `name` を許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
