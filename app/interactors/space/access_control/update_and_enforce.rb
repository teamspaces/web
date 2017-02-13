class Space::AccessControl::UpdateAndEnforce
  include Interactor::Organizer

  organize Space::AccessControl::Update,
           Space::AccessControl::Enforce
end
