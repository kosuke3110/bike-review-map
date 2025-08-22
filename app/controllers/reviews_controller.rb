# frozen_string_literal: true

# レビュー機能
class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: %i[edit update destroy]
  before_action :authorize_user!, only: %i[edit update]

  def new
    @review = Review.new(shop_place_id: params[:place_id])
  end

  def edit
    # @review は before_action で取得済み
  end

  def create
    @review = current_user.reviews.build(review_params)
    @review.shop_name = fetch_place_name(@review.shop_place_id)
    if @review.save
      redirect_to shop_path(@review.shop_place_id), notice: t('reviews.create_success')
    else
      render :new
    end
  end

  def update
    if @review.update(review_params)
      redirect_to params[:redirect_to].presence || user_path(current_user), notice: t('reviews.update_success')
      # redirect_to user_path(current_user), notice: 'レビューを更新しました！'
      #  redirect_to shop_path(@review.shop_place_id), notice: "レビューを更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.shop_place_id
    @review.destroy
    redirect_to request.referer.presence || user_path(current_user), notice: t('reviews.delete_success')
    # redirect_to shop_path(shop_place_id), notice: "レビューを削除しました"
  end

  private

  def fetch_place_name(place_id)
    api_key = ENV.fetch('GOOGLE_MAPS_API_KEY', nil)
    url = URI("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place_id}&key=#{api_key}&fields=name&language=ja")

    res = Net::HTTP.get_response(url)
    json = JSON.parse(res.body)

    # Rails.logger.info("[Google Places API] response: #{json.inspect}")

    return json.dig('result', 'name') || '名前なし' if json['status'] == 'OK'

    # Rails.logger.warn("[Google Places API] エラー: #{json['status']} - #{json['error_message']}")
    '店舗名取得失敗'
  rescue StandardError
    # Rails.logger.error("[Google Places API] 例外発生: #{e.message}")
    '店舗名取得失敗'
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
    redirect_to root_path, alert: t('reviews.no_permission') unless @review.user == current_user
  end
end
