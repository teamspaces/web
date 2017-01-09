InvitationCookieMock = Struct.new(:invitation) do
  def delete
    self.invitation = nil
  end
end
