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

#resultに戻す
# class ApplicationController < ActionController::Base
#   before_action :store_user_location!, if: :storable_location?
#   before_action :configure_permitted_parameters, if: :devise_controller?

#   protected

#   # 新規登録後
#   def after_sign_up_path_for(resource)
#     session.delete(:user_return_to) || root_path
#   end

#   # ログイン後
#   def after_sign_in_path_for(resource)
#     session.delete(:user_return_to) || root_path
#   end

#   # サインアップ・ログイン時に `name` を許可
#   def configure_permitted_parameters
#     devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
#     devise_parameter_sanitizer.permit(:account_update, keys: [:name])
#   end

#   private

#   # 保存対象かどうか
#   def storable_location?
#       request.get? &&
#       is_navigational_format? &&
#       !devise_controller? &&
#       !request.xhr? &&
#         request.path == result_shops_path    # 検索結果ページ
#   end

#   # 現在のパスを保存
#   def store_user_location!
#     session[:user_return_to] = request.fullpath
#   end
# end

class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_in_path_for(resource)
    if params[:redirect_to].present?
      decoded = CGI.unescape(params[:redirect_to].to_s)
      # /users/sign_in が混ざっていたら無視
      return decoded unless decoded.start_with?(new_user_session_path)
    end
    
    safe_redirect_path || root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def safe_redirect_path
    stored_location = stored_location_for(:user)
    return stored_location if stored_location.present?

    referer = request.referer
    if referer.present? && !referer.include?(new_user_session_path)
      referer
    end
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
end


