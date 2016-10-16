class Space < ApplicationRecord
  has_many :pages
  belongs_to :team
  validates :team, presence: true
end
