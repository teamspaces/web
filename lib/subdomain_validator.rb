class SubdomainValidator < ActiveModel::EachValidator

  def validate_each(object, attribute, value)
    return unless value.present?
    if ReservedSubdomain.include?(value)
      object.errors.add(attribute, :reserved_name)
    end
    object.errors.add(attribute, :must_have_between_3_and_63_characters) unless (3..63) === value.length
    object.errors.add(attribute, :cannot_start_end_with_hypen) unless value =~ /\A[^-].*[^-]\z/i
    object.errors.add(attribute, :must_be_alphanumeric_or_hyphen) unless value =~ /\A[a-z0-9\-]*\z/i
  end

end
