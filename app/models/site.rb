class Site < ApplicationRecord
  # アソシエーション
  has_many :contents, dependent: :destroy

  # バリデーション
  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true,
            format: { with: /\A[a-zA-Z0-9-]+\z/, message: "は英数字とハイフンのみ使用可能です" }
end
