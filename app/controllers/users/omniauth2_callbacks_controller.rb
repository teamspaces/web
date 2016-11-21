class Users::Omniauth2CallbacksController < Devise::OmniauthCallbacksController

  def slack
    slack_information = FetchSlackInformation.call(request: request)

    if slack_information.success?
      slack_identity = AuthorizeSlackIdentity.call(user: slack_information.user, token: slack_information.token)
      slack_team_members = RetainSlackTeamMembersInformation.call(team_members: slack_information.team_members)

      if slack_identity.success?
        sign_in slack_identity.user

        if slack_identity.login?
          redirect_to new_team_url(subdomain: "")
        elsif slack_identity.register?
          redirect_to new_team_url(subdomain: "")
        end
      end
    end
  end
end
