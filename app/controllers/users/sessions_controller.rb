class Users::SessionsController < Devise::SessionsController
  include CreateSessionRegistrationWithInvitation
end
