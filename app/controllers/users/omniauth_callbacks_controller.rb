class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def slack
    token = auth_response.credentials.token
    users_identity_url = "https://slack.com/api/users.identity?token=#{token}"
    response = HTTParty.get(users_identity_url)

    ap response.parsed_response

    # 1. User Creation
    # 1.1 There's already an account with this email which is not connected to Slack.
    #    Sign in with this account and then connect slack if you like.
    # 2.1 Pre-fill all fields (Team Name, URL, Name, Username, Email).
    #
    # 2. Team Creation
    # 2.1 There's already a team with that URL

    # {
    #   "ok" => true,
    #   "user" => {
    #             "name" => "Martin Samami",
    #               "id" => "U0C8MBAE6",
    #            "email" => "martin@furrow.io",
    #         "image_24" => "https://avatars.slack-edge.com/2016-05-23/44963978023_46d03d2e50e6d99474d7_24.jpg",
    #         "image_32" => "https://avatars.slack-edge.com/2016-05-23/44963978023_46d03d2e50e6d99474d7_32.jpg",
    #         "image_48" => "https://avatars.slack-edge.com/2016-05-23/44963978023_46d03d2e50e6d99474d7_48.jpg",
    #         "image_72" => "https://avatars.slack-edge.com/2016-05-23/44963978023_46d03d2e50e6d99474d7_72.jpg",
    #        "image_192" => "https://avatars.slack-edge.com/2016-05-23/44963978023_46d03d2e50e6d99474d7_192.jpg",
    #        "image_512" => "https://avatars.slack-edge.com/2016-05-23/44963978023_46d03d2e50e6d99474d7_512.jpg",
    #       "image_1024" => "https://avatars.slack-edge.com/2016-05-23/44963978023_46d03d2e50e6d99474d7_512.jpg"
    #   },
    #   "team" => {
    #                  "id" => "T0C8MBADQ",
    #                "name" => "Furrow",
    #              "domain" => "furrow",
    #            "image_34" => "https://a.slack-edge.com/66f9/img/avatars-teams/ava_0013-34.png",
    #            "image_44" => "https://a.slack-edge.com/66f9/img/avatars-teams/ava_0013-44.png",
    #            "image_68" => "https://a.slack-edge.com/66f9/img/avatars-teams/ava_0013-68.png",
    #            "image_88" => "https://a.slack-edge.com/66f9/img/avatars-teams/ava_0013-88.png",
    #           "image_102" => "https://a.slack-edge.com/66f9/img/avatars-teams/ava_0013-102.png",
    #           "image_132" => "https://a.slack-edge.com/66f9/img/avatars-teams/ava_0013-132.png",
    #           "image_230" => "https://a.slack-edge.com/9e9be/img/avatars-teams/ava_0013-230.png",
    #       "image_default" => true
    #   }
    # }

    # First requests authorizes but only returns very basic information, like
    # team name and nickname of the user. You need to make subsequent requests
    # which then have been authorizsed in the first request, to get name, email,
    # and avatar image.
    #
    # https://slack.com/api/users.identity?token=xoxp-12293384466-12293384482-54462895425-144f9d291b
  end

  def failure
    redirect_to root_path
  end

  def auth_response
    request.env["omniauth.auth"]
  end
end
