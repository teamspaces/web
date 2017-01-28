class Page < ApplicationRecord
  include HasOneCollabPage
  include HasOnePageContent

  has_closure_tree order: "sort_order"

  belongs_to :parent, class_name: "Page",
                      foreign_key: "parent_id",
                      primary_key: "id",
                      optional: true

  belongs_to :space
  has_one :team, through: :space
  validates :space, presence: true
end
