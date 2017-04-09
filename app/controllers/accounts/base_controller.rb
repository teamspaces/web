class Accounts::BaseController < ApplicationController

  private

    def pundit_user
      DefaultContext.new(current_user, nil)
    end
end
