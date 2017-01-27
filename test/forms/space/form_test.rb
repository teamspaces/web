require "test_helper"

describe Space::Form, :model do

  describe "validations" do
    should validate_presence_of(:user)
    should validate_presence_of(:name)
    should validate_presence_of(:team_id)
  end

end

