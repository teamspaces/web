class Space < ApplicationRecord
  has_many :pages, dependent: :destroy
  belongs_to :team
  validates :team, presence: true
end
