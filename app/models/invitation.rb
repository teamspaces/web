class Invitation < ApplicationRecord
  belongs_to :sender_team_member, primary_key: "sender_team_member_id", foreign_key: "id", class_name: 'TeamMember'
  belongs_to :recipient_team_member, primary_key: "recipient_team_member_id", foreign_key: "id", class_name: 'TeamMember'
end
