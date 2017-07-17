class Page < ApplicationRecord
  include HasOneCollabPage
  include HasOnePageContent

  belongs_to :space
  has_one :team, through: :space
  has_one :content

  validates :space, presence: true

  after_restore :restore_parent

  # Soft-delete
  acts_as_paranoid

  # Search
  searchkick callbacks: :async,
             routing: true

  has_many :searches, class_name: "Searchjoy::Search", as: :convertable

  def search_data
    {
      title: title,
      space_id: space_id,
      conversions: searches.group(:query).uniq.count(:user_id),
      content: content.contents  
    }
  end

  # Tree
  has_closure_tree order: "sort_order"

  private

    # Internal: restore parent pages in tree.
    def restore_parent
      Page.with_deleted
          .find(parent_id)
          .restore(recursive: true) if parent_id

      rebuild!
    end
end
