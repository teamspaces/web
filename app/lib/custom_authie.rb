Authie::Session.class_eval do

  # this field was removed from the Authie migration
  attr_accessor :data

  scope :active, -> { where(active: true) }

  def self.start(controller, params = {})
    cookies = controller.send(:cookies)
    current_team_id = controller.try(:current_team)&.id

    self.where(browser_id: cookies[:browser_id], team_id: current_team_id).each(&:invalidate!)

    session = self.new(params)
    session.controller = controller
    session.browser_id = cookies[:browser_id]
    session.login_at = Time.now
    session.login_ip = controller.request.ip
    session.team_id = current_team_id

    session.save!
    session
  end
end

Authie::ControllerDelegate.class_eval do

  def set_browser_id
    until cookies[:browser_id]
      proposed_browser_id = SecureRandom.uuid
      unless Authie::Session.where(browser_id: proposed_browser_id).exists?

        cookies[:browser_id] = { value: proposed_browser_id, expires: 20.years.from_now,
                                 domain: :all, tld_length: 2 }
      end
    end
  end
end
