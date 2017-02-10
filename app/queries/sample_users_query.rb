class SampleUsersQuery

  attr_reader :users_count_to_return, :relation

  def initialize(users_count_to_return:, _for: relation)
    @users_count_to_return = users_count_to_return
    @relation = relation
  end

  def sample_users
    User.where(id: sample_relation_user_ids).all
  end

  def not_returned_users_count
    [(relation_users.count - users_count_to_return), 0].max
  end

  private

    def relation_users
      relation.users
    end

    def sample_relation_user_ids
      relation_users.limit(100)
                    .pluck(:id)
                    .sample(users_count_to_return)
    end

end
