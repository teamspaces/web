module SignedInUsersCookie
  extend ActiveSupport::Concern

  def add_to_signed_in_users_cookie(user)
    if cookies[:signed_in_user_ids]
      ids = cookies[:signed_in_user_ids]
      ids << user.id
    else
      ids = [user.id].to_json
    end

    cookies[:signed_in_user_ids] = { value: ids, domain: :all,  tld_length: 2}
  end

  def remove_form_signed_in_users_cookie(user)
    if cookies[:signed_in_user_ids]
      ids = JSON.parse(cookies[:signed_in_user_ids])
      ids.delete(user.id)
      cookies[:signed_in_user_ids] = { value: ids, domain: :all}
    end
  end

  def signed_in_users_cookie_users
    users = []
    ids = cookies[:signed_in_user_ids]

    if ids
      JSON.parse(ids).each do |id|
        users << User.find(id)
      end
    end

    users
  end

  def signed_in_users_cookie_teams
    teams = []

    signed_in_users_cookie_users.each do |user|
      teams.concat( user.teams )
    end

    teams
  end
end
