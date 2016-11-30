class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable,
         :registerable, :trackable, :custom_validatable,
         :omniauthable, omniauth_providers: [:slack, :slack_button]

  has_many :authentications, dependent: :destroy
  has_many :team_members, dependent: :destroy
  has_many :teams, through: :team_members

  def name=(name)
    names = name.to_s.split(" ", 2)
    self.first_name = names.first
    self.last_name = names.last
  end

  def name
    "#{first_name} #{last_name}"
  end

  def self.find_for_authentication(warden_conditions)
    find_by(email: warden_conditions[:email], allow_email_login: true)
  end
end
