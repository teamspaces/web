class ReservedSubdomain

  def self.matches?(request)
    !self.reserved_names.include?(request.subdomain)
  end

  def self.include?(value)
    reserved_names.include?(value)
  end

  private

    def self.reserved_names
      %w(admin api assets
         accounts
         cdn
         develop developer developers docs documentation
         ftp
         image images
         javascript js
         mail marketing
         pop private public
         services sftp smtp ssl status stylesheet stylesheets
         what www)
    end
end
