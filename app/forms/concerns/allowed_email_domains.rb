module AllowedEmailDomains
  extend ActiveSupport::Concern

  included do
    attribute :allowed_email_domains, String

    validate :validate_format_of_allowed_email_domains
    validate :validate_privacy_of_allowed_email_domains
  end

  def allowed_email_domains
    @allowed_email_domains.join(", ")
  end

  def allowed_email_domains=(email_domains)
    @allowed_email_domains = if email_domains.kind_of?(Array)
      email_domains
    else
      email_domains.split(",").map(&:strip) if email_domains
    end
  end

  private

    def validate_format_of_allowed_email_domains
      domain_with_invalid_format = @allowed_email_domains.find { |domain| !domain.include? "@" }
      self.errors.add(:allowed_email_domains, I18n.t("team.errors.allowed_email_domains.missing_at_sign", domain: domain_with_invalid_format)) if domain_with_invalid_format.present?

      !domain_with_invalid_format.present?
    end

    def validate_privacy_of_allowed_email_domains
      domain_with_invalid_host = @allowed_email_domains.find { |domain| EmailProviderDomains.include?(domain) }
      self.errors.add(:allowed_email_domains, I18n.t("team.errors.allowed_email_domains.not_team_domain", domain: domain_with_invalid_host)) if domain_with_invalid_host.present?

      !domain_with_invalid_host.present?
    end
end
