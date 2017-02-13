class Space::AccessControl

  PRIVATE = "private"
  TEAM = "team"

  def initialize(space)
    @space = space
  end

  def private?
    access_control == PRIVATE
  end

  def team?
    access_control == TEAM
  end

  def access_control
    @space.read_attribute(:access_control)
  end
end
