require "test_helper"

describe Space do
  should have_many(:pages).dependent(:destroy)
  should belong_to(:team)
  should validate_presence_of(:team)
end
