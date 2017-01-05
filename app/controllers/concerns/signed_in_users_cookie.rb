module SignedInUsersCookie
  extend ActiveSupport::Concern

  def add_to_signed_in_users_cookie(user)
    cokie = DeviceUsersCookie.new(cookies)
    cokie.add(user)
#    if cookies[:signed_in_user_ids]
#      ids = JSON.parse(cookies[:signed_in_user_ids])
#      ids << user.id
#    else
#      ids = [user.id]
#    end
#
#    cookies[:signed_in_user_ids] = { value: ids.to_set.to_a.to_json, domain: :all,  tld_length: 2}
  end

  def remove_form_signed_in_users_cookie(user)
    cokie = DeviceUsersCookie.new(cookies)
    cokie.remove(user)
#    if cookies[:signed_in_user_ids]
#      ids = JSON.parse(cookies[:signed_in_user_ids])
#      ids.delete(user.id)
#      cookies[:signed_in_user_ids] = { value: ids, domain: :all}
#    end
  end

  def signed_in_users_cookie_users
    cokie = DeviceUsersCookie.new(cookies)
    cokie.users
#    users = []
#    ids = cookies[:signed_in_user_ids]

#    if ids
#      JSON.parse(ids).each do |id|
#        users << User.find_by(id: id)
#      end
#    end

#    users
  end

  def signed_in_users_cookie_teams
    cokie = DeviceUsersCookie.new(cookies)
    cokie.teams
  end
end
