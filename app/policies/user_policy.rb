class UserPolicy
  extend AliasMethods

  attr_reader :user, :default_context_user

  def initialize(default_context, user)
    @default_context_user = default_context.user
    @user = user
  end

  def is_owner?
    default_context_user == user
  end

   alias_methods :is_owner?, [:read?, :show?, :new?, :edit?, :create?, :update?, :destroy?]
end
