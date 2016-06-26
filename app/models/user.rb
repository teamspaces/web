class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable, :omniauthable

  has_many :authentications
  has_many :teams, through: :team_members
end
