class ReviewsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_review, only: [:edit, :update, :destroy]
    before_action :authorize_user!, only: [:edit, :update]

  def new
    @review = Review.new(shop_place_id: params[:place_id])
  end

  def create
    @review = current_user.reviews.build(review_params)
    @review.shop_name = fetch_place_name(@review.shop_place_id)
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
      redirect_to user_path(current_user), notice: 'レビューを更新しました！'
      #  redirect_to shop_path(@review.shop_place_id), notice: "レビューを更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    shop_place_id = @review.shop_place_id
    @review.destroy
    redirect_to request.referer.presence || user_path(current_user), notice: 'レビューを削除しました。'
    # redirect_to shop_path(shop_place_id), notice: "レビューを削除しました"
  end

  private

  def fetch_place_name(place_id)
    api_key = ENV["GOOGLE_MAPS_API_KEY"]
    url = URI("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place_id}&key=#{api_key}&fields=name&language=ja")
  
    res = Net::HTTP.get_response(url)
    json = JSON.parse(res.body)
  
    # Rails.logger.info("[Google Places API] response: #{json.inspect}")
  
    if json["status"] == "OK"
      return json.dig("result", "name") || "名前なし"
    else
      # Rails.logger.warn("[Google Places API] エラー: #{json['status']} - #{json['error_message']}")
      return "店舗名取得失敗"
    end
  rescue => e
    # Rails.logger.error("[Google Places API] 例外発生: #{e.message}")
    "店舗名取得失敗"
  end

  def review_params
    params.require(:review).permit(
      :shop_place_id, :rating_overall, :rating_skill, :rating_service, :rating_price, :comment,
      tag_ids: []
    )
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def authorize_user!
    redirect_to root_path, alert: "権限がありません" unless @review.user == current_user
  end
end
