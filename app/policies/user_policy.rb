class UserPolicy
  extend AliasMethods

  attr_reader :user

  def initialize(default_context, user)
    @user = user
  end

  def allowed?
    true
  end

   alias_methods :allowed?, [:read?, :show?, :new?, :edit?, :create?, :update?, :destroy?]
end
