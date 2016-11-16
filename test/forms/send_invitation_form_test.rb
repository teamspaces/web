require "test_helper"

describe SendInvitationForm, :model do
  let(:invitation) { invitations(:furrow) }
  subject { SendInvitationForm.new(invitation.attributes) }

  describe "validations" do
    it "validates presence of team" do
      subject.team = nil
      subject.save
      assert_includes subject.errors[:team], "can't be blank"
    end

    it "validates presence of user" do
      subject.user = nil
      subject.save
      assert_includes subject.errors[:user], "can't be blank"
    end

    it "validates format of email" do
      subject.email = "invalid_format"
      subject.save
      assert_includes subject.errors[:email], "is invalid"
    end

    it "validates presence of email" do
      subject.email = nil
      subject.save
      assert_includes subject.errors[:email], "is invalid"
    end

    it "validates email only one invitation for team" do
      subject.team = invitation.team
      subject.email = invitation.email
      subject.save
      assert_includes subject.errors[:email], "already has invitation for team"
    end
  end
end
