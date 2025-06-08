class Content < ApplicationRecord
  # アソシエーション
  belongs_to :site

  # バリデーション
  validates :path, presence: true
  validates :content, presence: true
end
