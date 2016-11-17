class SpacePolicy::Context < TeamPolicy::Context

    attr_reader :user, :team, :space

    def initialize(user, team, space)
      super(user, team)
      @space = space
    end
end
