require 'test_helper'

describe Team do
  should have_many(:members).dependent(:destroy)
  should have_many(:invitations).dependent(:destroy)
  should have_many(:spaces).dependent(:destroy)
end
