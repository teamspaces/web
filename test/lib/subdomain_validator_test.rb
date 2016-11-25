require "test_helper"

describe SubdomainValidator do

  subject do
    Class.new do
      def self.name; "Subdomain"; end
      include ActiveModel::Model
      attr_accessor :subdomain

      validates :subdomain, subdomain: true
    end
  end

  describe "reserved names" do
    it "is invalid" do
      ["what", "www"].each do |reserved_name|
        object = subject.new(subdomain: reserved_name)
        refute object.valid?
        assert_includes object.errors[:subdomain], "cannot be a reserved name"
      end
    end
  end

  describe "length" do
    context "less than 3 characters" do
      it "is invalid" do
        object = subject.new(subdomain: "te")
        refute object.valid?
        assert_includes object.errors[:subdomain], "must have between 3 and 63 characters"
      end
    end

    context "more than 63 characters" do
      it "is invalid" do
        object = subject.new(subdomain: "t" * 64)
        refute object.valid?
        assert_includes object.errors[:subdomain], "must have between 3 and 63 characters"
      end
    end

    context "between 3 and 63 characters" do
      it "is valid" do
        assert subject.new(subdomain: "teamone").valid?
      end
    end
  end

  describe "hypen" do
    context "starts with hypen" do
      it "is invalid" do
        object = subject.new(subdomain: "-team")
        refute object.valid?
        assert_includes object.errors[:subdomain], "cannot start or end with a hyphen"
      end
    end

    context "ends with hypen" do
      it "is invalid" do
        object = subject.new(subdomain: "team-")
        refute object.valid?
        assert_includes object.errors[:subdomain], "cannot start or end with a hyphen"
      end
    end

    context "hypen in middle" do
      it "is valid" do
        assert subject.new(subdomain: "tea-m").valid?
      end
    end
  end

  describe "alphanumeric or hyphen" do
    context "includes special characters" do
      it "is invalid" do
        object = subject.new(subdomain: "tea!m")
        refute object.valid?
        assert_includes object.errors[:subdomain], "must be alphanumeric (or hyphen)"
      end
    end
  end
end
