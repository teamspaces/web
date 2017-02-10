require "test_helper"

describe SampleUsersQuery, :model do
  let(:team) { teams(:spaces) }
  let(:space) { spaces(:spaces) }

  subject { SampleUsersQuery }

  describe "#sample_users" do
    it "returns given count of sample users" do
      sample_users = subject.new(_for: space, users_count_to_return: 2)
                            .sample_users


      assert_equal 2, sample_users.length
      assert_instance_of User, sample_users.first
    end
  end

  describe "#users_not_in_sample_count" do
    it "returns count of users that are not in sample" do
      not_in_sample_count = subject.new(_for: team, users_count_to_return: 0)
                                   .users_not_in_sample_count

      assert_instance_of Integer, not_in_sample_count
      assert not_in_sample_count > 1
    end
  end
end
