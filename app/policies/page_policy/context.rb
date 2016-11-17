class PagePolicy
  class Context < DefaultContext

    attr_reader :user, :team, :space

    def initialize(user, team, space)
      super(user, team)
      @space = space
    end
  end
end
