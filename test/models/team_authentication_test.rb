require "test_helper"

describe TeamAuthentication do
  let(:team_authentication) { TeamAuthentication.new }

  it "must be valid" do
    value(team_authentication).must_be :valid?
  end
end
