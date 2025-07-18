# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
tags = [
  "即日対応可",
  "出張修理あり",
  "代車貸出あり",
  "スポーツ自転車のみ対応",
  "他店自転車修理可",
  "パーツ販売あり"
]

tags.each do |tag_name|
  Tag.find_or_create_by!(name: tag_name)
end
