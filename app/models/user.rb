class User < ApplicationRecord
  include UserAvatarUploader[:avatar]

  devise :database_authenticatable, :recoverable, :rememberable,
         :registerable, :trackable, :custom_validatable, :custom_confirmable,
         :omniauthable, omniauth_providers: [:slack, :slack_button]

  include EmailConfirmable

  has_many :authentications, dependent: :destroy
  has_many :team_members, dependent: :destroy
  has_many :teams, through: :team_members

  has_many :sessions, class_name: "Authie::Session", foreign_key: "user_id", dependent: :destroy

  after_commit :send_pending_notifications

  def name=(name)
    names = name.to_s.split(" ", 2)
    self.first_name = names.first
    self.last_name = names.last
  end

  def name
    "#{first_name} #{last_name}"
  end

  # Devise: custom scoping to email login
  def self.find_for_authentication(warden_conditions)
    find_by(email: warden_conditions[:email],
            allow_email_login: true)
  end

  # Devise: send emails with background job
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  protected

    def send_devise_notification(notification, *args)
      # If the record is new or changed then delay the
      # delivery until the after_commit callback otherwise
      # send now because after_commit will not be called.
      if new_record? || changed?
        pending_notifications << [notification, args]
      else
        devise_mailer.send(notification, self, *args).deliver_later
      end
    end

    def send_pending_notifications
      pending_notifications.each do |notification, args|
        devise_mailer.send(notification, self, *args).deliver_later
      end

      # Empty the pending notifications array because the
      # after_commit hook can be called multiple times which
      # could cause multiple emails to be sent.
      pending_notifications.clear
    end

    def pending_notifications
      @pending_notifications ||= []
    end
end
