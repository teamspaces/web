class AllowedTeamEmailDomainValidator < ActiveModel::Validator
  def validate(record)
    if email_with_allowed_team_domain?(record)
      true
    else
      record.errors.add(:email, I18n.t("user.register.errors.email.not_allowed_domain"))
      false
    end
  end

  private

    def email_with_allowed_team_domain?(record)
      record.team.allowed_email_domains.any? do |domain|
        record.email.end_with? domain
      end
    end
end
