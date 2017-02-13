class Space::AccessControl

  def initialize(space)
    @space = space
  end

  def private?
    access_control == "private"
  end

  def team?
    access_control == "team"
  end

  def access_control
    @space.read_attribute(:access_control)
  end
end
