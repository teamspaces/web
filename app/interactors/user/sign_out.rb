class User::SignOut
  include Interactor

  attr_reader :user, :from_team, :from_browser

  def call
    @user = context.user # single user or :all
    @from_team = context&.from_team
    @from_browser = context&.from_browser

    sign_out
  end

  private

    def sign_out
      user_sessions.find_each(&:invalidate!)
    end

    def user_sessions
      @relation = active_user_sessions
      @relation = matching_team_sessions
      @relation =
    end


    def active_user_sessions
      if user == :all
        Authie::Session.active
      else
        Authie::Session.active.where(user_id: user.id)
      end
    end


end
