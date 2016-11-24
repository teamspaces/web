class Users::RegistrationsController < Devise::RegistrationsController
  include CreateSessionRegistrationWithInvitation
end
