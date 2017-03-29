class User::SessionsController < Devise::SessionsController
  include SessionAuthentication

  # overwrite devise before_action, not needed
  def verify_signed_out_user
  end


  # DELETE /logout
  def destroy
    sign_out_all_users_from_browser

    respond_to_on_destroy
  end
end
