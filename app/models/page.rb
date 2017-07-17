class Page < ApplicationRecord
  include HasOneCollabPage
  include HasOnePageContent

  # Soft-delete
  acts_as_paranoid
  after_restore :restore_parent

  # Search
  has_many :searches, class_name: "Searchjoy::Search", as: :convertable
  searchkick callbacks: :async,
             routing: true,
             conversions: ["unique_user_conversions", "total_conversions"],
             highlight: [:title, :contents],
             word_start: [:title]

  def search_data
    {
      title: title,
      contents: contents,
      unique_user_conversions: searches.group(:query).distinct.count(:user_id),
      total_conversions: searches.group(:query).count
    }
  end

  # Internal: Faster search results, routing to shards using this key.
  #   See https://www.elastic.co/blog/customizing-your-document-routing for
  #   more information.
  def search_routing
    space.team_id
  end

  # Tree
  has_closure_tree order: "sort_order"

  # Relations
  belongs_to :space
  has_one :team, through: :space
  has_one :content, class_name: "PageContent"

  # Validations
  validates :space, presence: true

  def contents
    content.contents
  end

  private

    # Internal: restore parent pages in tree.
    def restore_parent
      Page.with_deleted
          .find(parent_id)
          .restore(recursive: true) if parent_id

      rebuild!
    end
end
