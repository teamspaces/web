class Space < ApplicationRecord
  include SpaceCoverUploader[:cover]

  has_many :pages, dependent: :destroy
  belongs_to :team
  validates :team, presence: true

  def users
    if access_control
      team.users
    else
      team.users
    end
  end
end
