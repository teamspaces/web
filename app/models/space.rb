class Space < ApplicationRecord
  belongs_to :team
  validates :team, presence: true
end
