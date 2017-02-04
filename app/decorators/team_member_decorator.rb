class TeamMemberDecorator < Draper::Decorator
  delegate_all

  def space_member?(space)
    SpaceMember.exists?(space: space, team_member: object)
  end
end
