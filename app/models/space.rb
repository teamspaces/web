class Space < ApplicationRecord
  include SpaceCoverUploader[:cover]

  has_many :pages, dependent: :destroy
  belongs_to :team
  validates :team, presence: true
end
