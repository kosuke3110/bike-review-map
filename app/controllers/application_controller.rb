# frozen_string_literal: true

# # application_controller
# class ApplicationController < ActionController::Base
#   before_action :configure_permitted_parameters, if: :devise_controller?

#   protected

#   def after_sign_up_path_for(resource)
#     stored_location_for(resource) || root_path
#   end

#   def after_sign_in_path_for(resource)
#     stored_location_for(resource) || root_path
#   end

#   def configure_permitted_parameters
#     # サインアップ時とアカウント更新時に `name` を許可
#     devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
#     devise_parameter_sanitizer.permit(:account_update, keys: [:name])
#   end
# end

class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # 新規登録後
  def after_sign_up_path_for(resource)
    session.delete(:user_return_to) || root_path
  end

  # ログイン後
  def after_sign_in_path_for(resource)
    session.delete(:user_return_to) || root_path
  end

  # サインアップ・ログイン時に `name` を許可
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  # 保存対象かどうか
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  # 現在のパスを保存
  def store_user_location!
    session[:user_return_to] = request.fullpath
  end
end
