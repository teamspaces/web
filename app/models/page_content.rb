class PageContent < ApplicationRecord
  acts_as_paranoid

  belongs_to :page, touch: true
  validates :page, presence: true

  after_commit :update_word_count,
               :reindex_page

  private

    def update_word_count
      page.update_column(:word_count, contents.to_s.split.size)
    end

    def reindex_page
      page.reindex_async
    end
end
