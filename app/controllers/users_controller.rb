class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    @reviews = @user.reviews.order(created_at: :desc)
  end

#   def edit
#   end

#   def update
#     if @user.update(user_params)
#       redirect_to user_path(@user), notice: "プロフィールを更新しました"
#     else
#       render :edit, status: :unprocessable_entity
#     end
#   end

private

  def set_user
    @user = current_user
  end

  # def user_params
  #   params.require(:user).permit(:name, :email)
  # end
end
