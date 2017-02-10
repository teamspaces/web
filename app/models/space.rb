class Space < ApplicationRecord
  acts_as_paranoid

  include SpaceCoverUploader[:cover]

  has_many :pages, dependent: :destroy
  belongs_to :team
  has_many :users, through: :team
  validates :team, presence: true
end
