class ReviewsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_review, only: [:edit, :update, :destroy]
    before_action :authorize_user!, only: [:edit, :update]

  def new
    @review = Review.new(shop_place_id: params[:place_id])
  end

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      redirect_to shop_path(@review.shop_place_id), notice: "レビューを投稿しました"
    else
      render :new
    end
  end

  def edit
    # @review は before_action で取得済み
  end

  def update
    if @review.update(review_params)
      redirect_to shop_path(@review.shop_place_id), notice: "レビューを更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    shop_place_id = @review.shop_place_id
    @review.destroy
    redirect_to shop_path(shop_place_id), notice: "レビューを削除しました"
  end

  private

  def review_params
    params.require(:review).permit(
      :shop_place_id, :rating_overall, :rating_skill, :rating_service, :rating_price, :comment
    )
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def authorize_user!
    redirect_to root_path, alert: "権限がありません" unless @review.user == current_user
  end
end
