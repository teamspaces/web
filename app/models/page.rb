class Page < ApplicationRecord
  include HasOneCollabPage

  belongs_to :space
  has_one :team, through: :space
  validates :space, presence: true
end
