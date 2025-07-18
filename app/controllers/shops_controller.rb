require 'net/http'
require 'uri'
require 'json'
require 'erb'

class ShopsController < ApplicationController

  # 住所 → 緯度経度に変換
  def geocode_address(address)
    api_key = ENV['GOOGLE_MAPS_API_KEY']
    encoded_address = ERB::Util.url_encode(address)
    url = URI("https://maps.googleapis.com/maps/api/geocode/json?address=#{encoded_address}&key=#{api_key}")

    response = Net::HTTP.get(url)
    # Rails.logger.info "Geocode API response: #{response}"  # 追加

    result = JSON.parse(response)

    if result['status'] == 'OK'
      lat = result['results'][0]['geometry']['location']['lat']
      lng = result['results'][0]['geometry']['location']['lng']
      "#{lat},#{lng}"
    else
      # Rails.logger.error "Geocode API error status: #{result['status']}, message: #{result['error_message']}"  # 追加
      nil
    end
  end

  # 緯度経度 → 自転車店検索
  def search_bike_shops(location)
    api_key = ENV['GOOGLE_MAPS_API_KEY']
    keyword = ERB::Util.url_encode("自転車")

    url = URI("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{location}&radius=4000&type=bicycle_store&keyword=#{keyword}&language=ja&key=#{api_key}")

    # Rails.logger.info "Places API URL: #{url}"

    response = Net::HTTP.get(url)
    result = JSON.parse(response)

    #  Rails.logger.info "Places API status: #{result['status']}, results count: #{result['results']&.count}"

    if result['status'] == 'OK'
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
    else
      []
    end
  end

  def result
    @address = params[:address]
    @lat = params[:lat].presence
    @lng = params[:lng].presence

    #  Rails.logger.info "受け取った住所: #{@address.inspect}"
    # Rails.logger.info "受け取った緯度: #{@lat.inspect}, 経度: #{@lng.inspect}"

    if @address.present?
      location = geocode_address(@address)
      if location.nil?
        @shops = []
        flash.now[:alert] = "住所のジオコーディングに失敗しました。"
        return
      end
      Rails.logger.info "ジオコーディングで得た場所: #{location.inspect}"
    elsif @lat && @lng
      location = "#{@lat},#{@lng}"
    else
      @shops = []
      flash.now[:alert] = "住所または現在地を指定してください。"
      return
    end

    @shops = search_bike_shops(location)
    # Rails.logger.info "検索で見つかったお店: #{@shops.inspect}"
  end

  def show
    place_id = params[:id]

    # Google Places APIで店舗情報取得
    @shop = fetch_place_details(place_id)

    # ユーザーレビューの取得（DBから）
    @reviews = Review.where(shop_place_id: place_id).includes(:user)
    # 検索結果画面から来たときだけセッションに保存
    if request.referer&.include?("/shops/result")
      session[:back_to_search] = request.referer
    end
  end

  private

  def fetch_place_details(place_id)
    api_key = ENV['GOOGLE_MAPS_API_KEY']
    url = URI("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place_id}&language=ja&key=#{api_key}")

    res = Net::HTTP.get_response(url)
    data = JSON.parse(res.body)

    if data["status"] == "OK"
      data["result"]
    else
      {}
    end
  end
end
