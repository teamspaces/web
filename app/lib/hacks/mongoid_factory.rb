module Mongoid
  module Factory
    extend self
    def from_db(klass, attributes = nil, selected_fields = nil)
      type = (attributes || {})[TYPE]
      if type.blank? || type =~ /http:\/\//
        klass.instantiate(attributes, selected_fields)
      else
        type.camelize.constantize.instantiate(attributes, selected_fields)
      end
    end
  end
end
