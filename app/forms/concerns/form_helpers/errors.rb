module FormHelpers
  module Errors

    def add_errors_from(record)
      record.valid?
      record.errors.each do |attribute, message|
        self.errors.add(attribute, message)
      end
    end
  end
end
