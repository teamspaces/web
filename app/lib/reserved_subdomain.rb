class ReservedSubdomain

  def self.matches?(request)
    !self.reserved_names.include?(request.subdomain)
  end

  def self.include?(value)
    reserved_names.include?(value)
  end

  private

    def self.reserved_names
      %w(www ftp mail pop smtp admin ssl sftp what)
    end
end
