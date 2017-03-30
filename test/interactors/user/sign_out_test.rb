require "test_helper"

describe User::SignOut, :model do
  set_fixture_class authie_sessions: Authie::Session

  alias sessions authie_sessions

  subject { User::SignOut }
  let(:maja_at_spaces) { users(:with_several_teams) }
  let(:sven_at_spaces) { users(:sven_at_spaces) }
  let(:spaces) { teams(:spaces) }
  let(:desktop_browser) { "desktop" }

  describe "#call" do
    context "single user" do
      context "from team" do
        it "works" do
          subject.call(user: maja_at_spaces, from_team: spaces)

          refute sessions(:maja_at_spaces).active
          refute sessions(:maja_mobile_browser).active
          assert sessions(:sven_at_spaces).active
          assert sessions(:maja_at_power).active
        end
      end

      context "from browser" do
        it "works" do
          subject.call(user: maja_at_spaces, from_browser: desktop_browser)

          refute sessions(:maja_at_spaces).active
          refute sessions(:maja_at_power).active
          assert sessions(:maja_mobile_browser).active
          assert sessions(:sven_at_spaces).active
        end
      end
    end

    context "all users" do
      context "from team" do
        it "works" do
          subject.call(from_team: spaces)

          refute sessions(:sven_at_spaces).active
          refute sessions(:maja_at_spaces).active
          refute sessions(:maja_mobile_browser).active
          assert sessions(:maja_at_power).active
        end
      end

      context "from browser" do
        it "works" do
          subject.call(from_browser: desktop_browser)

          assert sessions(:maja_mobile_browser).active
          refute sessions(:maja_at_power).active
          refute sessions(:maja_at_spaces).active
          refute sessions(:sven_at_spaces).active
        end
      end
    end
  end
end
