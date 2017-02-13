class Space::AccessControl

  def initialize(space)
    @space = space
  end

  def private?
    access_control == :private
  end

  def team?
    access_control == :team
  end

  def access_control
    #da gibts whatheinlich son to
    @space.access_control
  end

end
