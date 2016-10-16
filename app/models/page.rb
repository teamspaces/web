class Page < ApplicationRecord
  belongs_to :space
  validates :space, presence: true
end
