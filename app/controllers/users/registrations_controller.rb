class Users::RegistrationsController < Devise::RegistrationsController
  include InvitationTokenSignUpIn
end
