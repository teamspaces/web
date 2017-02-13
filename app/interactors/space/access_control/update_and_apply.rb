class Space::AccessControl::UpdateAndApply
  include Interactor::Organizer

  organize Space::AccessControl::Update,
           Space::AccessControl::Apply
end
