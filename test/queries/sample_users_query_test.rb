require "test_helper"

describe SampleUsersQuery, :model do
  let(:team) { teams(:spaces) }
  let(:space) { spaces(:spaces) }

  subject { SampleUsersQuery }

  describe "#sample_users" do
    it "returns given count of sample users" do
      sample_users = subject.new(resource: space, total_users_to_sample: 2)
                            .sample_users


      assert_equal 2, sample_users.length
      assert_instance_of User, sample_users.first
    end
  end

  describe "#users_not_in_sample_count" do
    it "returns count of users that are not in sample" do
      not_in_sample_count = subject.new(resource: team, total_users_to_sample: 50)
                                   .users_not_in_sample_count

      assert_equal 0, not_in_sample_count
    end
  end
end
