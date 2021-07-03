class Food < ApplicationRecord
  belongs_to :restaurant
  belongs_to :order, optional: time_required
  has_one :line_foods
end