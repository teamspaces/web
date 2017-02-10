class Space::AccessControlRule::UpdateAndEnforce
  include Interactor::Organizer

  organize Space::AccessControlRule::Update,
           Space::AccessControlRule::Enforce
end
