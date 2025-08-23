# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'erb'

# Google API を利用して自転車店を取得するコントローラ
class ShopsController < ApplicationController
  # 検索結果画面表示
  def result
    @shops = []
    location = determine_location
    return if location.nil?

    all_shops = search_bike_shops(location)

    # Kaminariでページング（1ページ10件）
    @shops = Kaminari.paginate_array(all_shops).page(params[:page]).per(5)
  end

  # 店舗詳細画面表示
  def show
    place_id = params[:id]
    @shop = fetch_place_details(place_id)
    @reviews = Review.where(shop_place_id: place_id).includes(:user)
    store_back_to_search_session(_place_id = place_id)
  end

  private

  # パラメータから検索位置を決定
  def determine_location
    return determine_location_from_address if params[:address].present?
    return determine_location_from_coords if params[:lat].present? && params[:lng].present?

    flash.now[:alert] = t('shops.missing_address')
    nil
  end

  # 住所から緯度経度を取得
  def determine_location_from_address
    loc = geocode_address(params[:address])
    flash.now[:alert] = t('shops.geocode_fail') if loc.nil?
    loc
  end

  # 緯度経度から位置を決定
  def determine_location_from_coords
    "#{params[:lat]},#{params[:lng]}"
  end

  # 住所 → 緯度経度に変換
  def geocode_address(address)
    api_key = ENV.fetch('GOOGLE_MAPS_API_KEY', nil)
    encoded_address = ERB::Util.url_encode(address)
    url = URI("https://maps.googleapis.com/maps/api/geocode/json?address=#{encoded_address}&key=#{api_key}")

    result = JSON.parse(Net::HTTP.get(url))
    return unless result['status'] == 'OK'

    lat = result['results'][0]['geometry']['location']['lat']
    lng = result['results'][0]['geometry']['location']['lng']
    "#{lat},#{lng}"
  end

  # 緯度経度 → 自転車店検索
  def search_bike_shops(location)
    api_key = ENV.fetch('GOOGLE_MAPS_API_KEY', nil)
    keyword = ERB::Util.url_encode('自転車')

    url = URI("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{location}&radius=4000&type=bicycle_store&keyword=#{keyword}&language=ja&key=#{api_key}")
    result = JSON.parse(Net::HTTP.get(url))
    return [] unless result['status'] == 'OK'

    result['results'].map do |place|
      {
        name: place['name'],
        address: place['vicinity'],
        rating: place['rating'],
        place_id: place['place_id'],
        lat: place['geometry']['location']['lat'],
        lng: place['geometry']['location']['lng']
      }
    end
  end

  # Google Places API から店舗詳細取得
  def fetch_place_details(place_id)
    api_key = ENV.fetch('GOOGLE_MAPS_API_KEY', nil)
    url = URI("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place_id}&language=ja&key=#{api_key}")

    data = JSON.parse(Net::HTTP.get_response(url).body)
    data['status'] == 'OK' ? data['result'] : {}
  end

  # 検索結果画面から来た場合にセッション保存
  def store_back_to_search_session(_place_id)
    return unless request.referer&.include?('/shops/result')

    session[:back_to_search] = request.referer
  end
end

# # frozen_string_literal: true

# # Google APIによるshop取得
# require 'net/http'
# require 'uri'
# require 'json'
# require 'erb'

# class ShopsController < ApplicationController
#   # 住所 → 緯度経度に変換
#   def geocode_address(address)
#     api_key = ENV.fetch('GOOGLE_MAPS_API_KEY', nil)
#     encoded_address = ERB::Util.url_encode(address)
#     url = URI("https://maps.googleapis.com/maps/api/geocode/json?address=#{encoded_address}&key=#{api_key}")

#     response = Net::HTTP.get(url)
#     # Rails.logger.info "Geocode API response: #{response}"  # 追加

#     result = JSON.parse(response)

#     if result['status'] == 'OK'
#       lat = result['results'][0]['geometry']['location']['lat']
#       lng = result['results'][0]['geometry']['location']['lng']
#       "#{lat},#{lng}"
#     # else
#       # Rails.logger.error "Geocode API error status: #{result['status']}, message: #{result['error_message']}"  # 追加
#       # nil
#     end
#   end

#   # 緯度経度 → 自転車店検索
#   def search_bike_shops(location)
#     api_key = ENV.fetch('GOOGLE_MAPS_API_KEY', nil)
#     keyword = ERB::Util.url_encode('自転車')

#     url = URI("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{location}&radius=4000&type=bicycle_store&keyword=#{keyword}&language=ja&key=#{api_key}")

#     # Rails.logger.info "Places API URL: #{url}"

#     response = Net::HTTP.get(url)
#     result = JSON.parse(response)

#     #  Rails.logger.info "Places API status: #{result['status']}, results count: #{result['results']&.count}"

#     if result['status'] == 'OK'
#       result['results'].map do |place|
#         {
#           name: place['name'],
#           address: place['vicinity'],
#           rating: place['rating'],
#           place_id: place['place_id'],
#           lat: place['geometry']['location']['lat'],
#           lng: place['geometry']['location']['lng']
#         }
#       end
#     else
#       []
#     end
#   end

#   def result
#     @address = params[:address]
#     @lat = params[:lat].presence
#     @lng = params[:lng].presence

#     #  Rails.logger.info "受け取った住所: #{@address.inspect}"
#     # Rails.logger.info "受け取った緯度: #{@lat.inspect}, 経度: #{@lng.inspect}"

#     if @address.present?
#       location = geocode_address(@address)
#       if location.nil?
#         @shops = []
#         flash.now[:alert] = t('shops.geocode_fail')
#         return
#       end
#       Rails.logger.info "ジオコーディングで得た場所: #{location.inspect}"
#     elsif @lat && @lng
#       location = "#{@lat},#{@lng}"
#     else
#       @shops = []
#       flash.now[:alert] = t('shops.missing_address')
#       return
#     end

#     @shops = search_bike_shops(location)
#     # Rails.logger.info "検索で見つかったお店: #{@shops.inspect}"
#   end

#   def show
#     place_id = params[:id]

#     # Google Places APIで店舗情報取得
#     @shop = fetch_place_details(place_id)

#     # ユーザーレビューの取得（DBから）
#     @reviews = Review.where(shop_place_id: place_id).includes(:user)
#     # 検索結果画面から来たときだけセッションに保存
#     return unless request.referer&.include?('/shops/result')

#     session[:back_to_search] = request.referer
#   end

#   private

#   def fetch_place_details(place_id)
#     api_key = ENV.fetch('GOOGLE_MAPS_API_KEY', nil)
#     url = URI("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place_id}&language=ja&key=#{api_key}")

#     res = Net::HTTP.get_response(url)
#     data = JSON.parse(res.body)

#     if data['status'] == 'OK'
#       data['result']
#     else
#       {}
#     end
#   end
# end
