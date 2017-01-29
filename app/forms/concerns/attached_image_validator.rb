class AttachedImageValidator < ActiveModel::EachValidator

  # Validates Shrine attacher eg. a team logo or space cover.
  # 
  # Example:
  #   validates :logo, attached_image: true
  def validate_each(record, attribute, value)
    record.instance_variable_get("@#{record.model_name.to_str.downcase}")
          .send("#{attribute}_attacher").errors.each do |message|
            record.errors.add(attribute, message)
          end
  end
end

