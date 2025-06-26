class ReviewsController < ApplicationController
    before_action :authenticate_user!

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

  private

  def review_params
    params.require(:review).permit(
      :shop_place_id, :rating_overall, :rating_skill, :rating_service, :rating_price, :comment
    )
  end
end
