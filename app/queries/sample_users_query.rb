class SampleUsersQuery

  attr_reader :total_users_to_sample, :resource

  def initialize(total_users_to_sample:, resource:)
    @total_users_to_sample = total_users_to_sample
    @resource = resource
  end

  def users
    User.where(id: user_ids).all
  end

  def users_not_in_sample_count
    [(resource_users.count - total_users_to_sample), 0].max
  end

  private

    def user_ids
      resource_users.limit(100)
                    .pluck(:id)
                    .sample(total_users_to_sample)
    end

    def resource_users
      resource.users
    end
end
