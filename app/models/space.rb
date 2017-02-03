class Space < ApplicationRecord
  acts_as_paranoid

  include SpaceCoverUploader[:cover]

  has_many :pages, dependent: :destroy
  belongs_to :team
  validates :team, presence: true

  alias_method :archive, :destroy
  alias_method :archived?, :paranoia_destroyed?
end
