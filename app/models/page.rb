class Page < ApplicationRecord
  acts_as_paranoid

  include HasOneCollabPage
  include HasOnePageContent

  has_closure_tree order: "sort_order"

  belongs_to :space
  has_one :team, through: :space
  validates :space, presence: true

  after_restore :append_to_root

  private

    def append_to_root
      node = self

      while node.parent
        node.parent.restore
        node = node.parent
      end

      Page.rebuild!
    end
end
