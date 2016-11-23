class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable,
         :registerable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:slack]#,
         #authentication_keys: [:invitation_token, :email]

  attr_accessor :invitation_token

  has_many :authentications, dependent: :destroy
  has_many :team_members, dependent: :destroy
  has_many :teams, through: :team_members

#   validates :invitation_token, length: { minimum: 50 }

  def name=(name)
    names = name.to_s.split(" ", 2)
    self.first_name = names.first
    self.last_name = names.last
  end

  def name
    "#{first_name} #{last_name}"
  end

  #def self.val_ini(invitation_token)
  #  debugger
  #end

  #def valid_for_authentication?
  #  false
  #  Rails.logger.debug "Show this message!"
  #end

  #def active_for_authentication?
        # Uncomment the below debug statement to view the properties of the returned self model values.
        # logger.debug self.to_yaml

        #super && account_active?
    #    Rails.logger.debug invitation_token
   #     false
  #end

  #def inactive_message
  #  "#{self.invitation_token} que pasea"
  #end

 ##def self.find_first_by_auth_conditions warden_conditions
  #    record = new
  #     record.errors.add(:invitation_token, :not_implemented, message: "must be implemented")
  #  conditions = warden_conditions.dup
#  warden_conditions.delete(:invitation_token)

   # if ini =
   #   val_ini ini
   # else
   #   super(warden_conditions)
   # end
   #user = User.first
   #user.errors.add(:invitation_token, "ola")
   #user
  #end



end
