class ShopsController < ApplicationController
  def search
    # フォーム画面表示
  end

  def result
    @address = params[:address]
    @lat = params[:lat]
    @lng = params[:lng]

    # 本来ならGoogle Maps APIで近隣の店舗を取得する処理
    # 今回はデモ用に仮の店舗データで代用
    @shops = [
      { name: "サイクルベースあさひ", address: "東京都新宿区..." },
      { name: "バイチャリ池袋", address: "東京都豊島区..." }
    ]
  end
end
