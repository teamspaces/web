#require "test_helper"

#describe LoginRegisterFunnel::UserAcceptInvitationPath, :controller do

 # describe "invitation exists" do
  #  let(:invitation) { invitations(:slack_user_milad_invitation) }

   # before(:each) do
   #   get accept_invitation_url(invitation.token, subdomain:  ENV["DEFAULT_SUBDOMAIN"])
   # end

   # describe "user is invited" do
   #   let(:invited_user) { users(:slack_user_milad) }

    #  it "does accept invitation" do
    #    @controller.user_accept_invitation_path(invited_user)

    #    assert_includes invited_user.teams, invitation.team
    #  end

    #  it "returns host team url" do
    #    url = @controller.user_accept_invitation_path(invited_user)

    #    assert url.include? team_url(subdomain: invitation.team.subdomain)
    #  end
    #end

    #describe "user is not invited" do
    #  let(:not_invited_user) { users(:lars) }

     # it "does not accept invitation" do
      #  @controller.user_accept_invitation_path(not_invited_user)

       # refute_includes not_invited_user.teams, invitation.team
   #   end

    #  it "returns sign in path" do
     #   path = @controller.user_accept_invitation_path(not_invited_user)

      #  assert_equal @controller.sign_in_path_for(not_invited_user), path
  #    end
  #  end
  #end

  #describe "invitation does not exist" do
  #  it "returns sign in path" do
  #    user = users(:lars)
  #    get accept_invitation_url("invalid_invitation_token", subdomain:  ENV["DEFAULT_SUBDOMAIN"])
  #    path = @controller.user_accept_invitation_path(user)

#      assert_equal @controller.sign_in_path_for(user), path
#    end
#  end
#end
