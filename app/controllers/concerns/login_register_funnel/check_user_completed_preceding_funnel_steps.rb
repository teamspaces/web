module LoginRegisterFunnel::CheckUserCompletedPrecedingFunnelSteps
  extend ActiveSupport::Concern

  included do
    before_action :check_user_completed_preceding_funnel_steps
  end

  private

    def check_user_completed_preceding_funnel_steps
      redirect_to choose_login_method_path unless user_already_provided_email_address?
    end

    def user_already_provided_email_address?
      in_login_register_funnel_provided_email.present?
    end
end
