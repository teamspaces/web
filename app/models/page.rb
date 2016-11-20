class Page < ApplicationRecord
  include HasOneCollabPage

  belongs_to :space
  validates :space, presence: true
end
