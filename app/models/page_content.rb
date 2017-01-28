class PageContent < ApplicationRecord
  belongs_to :page, dependent: :destroy
  validates :page, presence: true

  after_save :update_word_count

  private

    def update_word_count
      page.update_column(:word_count, contents.to_s.split.size)
    end
end
