class UserPolicy
  extend AliasMethods

  attr_reader :user, :default_context_user

  def initialize(default_context, user)
    @default_context_user = default_context.user
    @user = user
  end

  def allowed?
    user == default_context_user
  end

   alias_methods :allowed?, [:read?, :show?, :new?, :edit?, :create?, :update?, :destroy?]
end
