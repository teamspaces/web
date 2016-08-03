class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable,
         :omniauthable, omniauth_providers: [:slack]

  has_many :authentications
  has_and_belongs_to_many :teams, through: :team_members

  def name=(name)
    names = name.to_s.split(" ", 2)
    self.first_name = names.first
    self.last_name = names.last
  end

  def name
    "#{first_name} #{last_name}"
  end
end
