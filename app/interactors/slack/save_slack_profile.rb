class Slack::SaveSlackProfile
  include Interactor

  attr_reader :slack_user

  def call
    @slack_user = context.slack_user
    save
  end


  def save
    slack_profile = SlackProfile.find_or_initialize_by(user_id: slack_user.id)

    slack_profile.team_id = slack_user.team_id
    slack_profile.name = slack_user.name
    slack_profile.deleted = slack_user.deleted
    slack_profile.color = slack_user.color

    profile = slack_user.profile

    slack_profile.first_name = profile.first_name
    slack_profile.last_name = profile.last_name
    slack_profile.real_name = profile.real_name
    slack_profile.email = profile.email
    slack_profile.skype = profile.skype
    slack_profile.phone = profile.phone
    slack_profile.image_24 = profile.image_24
    slack_profile.image_32 = profile.image_32
    slack_profile.image_48 = profile.image_48
    slack_profile.image_72 = profile.image_72
    slack_profile.image_192 = profile.image_192
    slack_profile.image_512 = profile.image_512

    slack_profile.is_admin = slack_user.is_admin
    slack_profile.is_owner = slack_user.is_owner
    slack_profile.is_primary_owner = slack_user.is_primary_owner
    slack_profile.is_restricted = slack_user.is_restricted
    slack_profile.is_ultra_restricted = slack_user.is_ultra_restricted
    slack_profile.has_2fa = slack_user.has_2fa
    slack_profile.two_factor_type = slack_user.two_factor_type
    slack_profile.has_files = slack_user.has_files

    slack_profile.save
  end
end
