class Page < ApplicationRecord
  acts_as_paranoid

  include HasOneCollabPage
  include HasOnePageContent

  has_closure_tree order: "sort_order"

  belongs_to :space
  has_one :team, through: :space
  validates :space, presence: true

  after_restore :restore_parent

  private

    def restore_parent
      Page.with_deleted
          .find(parent_id)
          .restore(recursive: true) if parent_id

      rebuild!
    end
end
