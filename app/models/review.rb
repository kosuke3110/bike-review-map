class Review < ApplicationRecord
  belongs_to :user
  # validates :shop_place_id, :comment, presence: true
  validates :rating_overall, :rating_skill, :rating_service, :rating_price,
            presence: true,
            inclusion: { in: 1..5 }
end
