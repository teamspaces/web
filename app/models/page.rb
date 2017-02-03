class Page < ApplicationRecord
  acts_as_paranoid

  include HasOneCollabPage
  include HasOnePageContent

  has_closure_tree order: "sort_order"
  after_restore :append_to_root

  belongs_to :space
  has_one :team, through: :space
  validates :space, presence: true

  alias_method :archived?, :paranoia_destroyed?

  private

    def append_to_root
      update(parent_id: nil)
    end
end
