class LineFood < ApplicationRecord
  belongs_to :food
  belongs_to :restaurant
  belongs_to :order, optional: true

  validates :count, numericality: { greater_than: 0 }

  # LineFoodからwhereによってacticve; trueの一覧をactive_recordの形で返してくれる。  使い方：LineFood.active
  scope :active, -> { where(active: true) }
  # restaurant_idが特定の店舗idではないものの一覧を返してくれる。例外パターンで使用する。
  scope :other_restaurant, -> (picked_restaurant_id) { where.not(restaurant_id: picked_restaurant_id) }

  # line_foodインスタンスの合計価格を算出。modelに書くことで様々な箇所から呼び出せるみたい。
  def total_amount
    food.price * count
  end
end