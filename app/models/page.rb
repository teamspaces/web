class Page < ApplicationRecord
  include HasOneCollabPage
  include HasOnePageContent

  belongs_to :space
  has_one :team, through: :space
  validates :space, presence: true
end
