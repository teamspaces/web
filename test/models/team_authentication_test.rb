require 'test_helper'

describe TeamAuthentication do
  should belong_to(:team)

  should validate_presence_of(:team)
  should validate_presence_of(:token)
end
