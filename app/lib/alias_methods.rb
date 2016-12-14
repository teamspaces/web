module AliasMethods
  def alias_methods(alias_to, methods)
    methods.each { |method| alias_method method, alias_to }
  end
end
