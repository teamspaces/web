class Users::SessionsController < Devise::SessionsController
  include InvitationTokenSignUpIn
end
