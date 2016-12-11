class PageContent < ApplicationRecord
  belongs_to :page, dependent: :destroy
  validates :page, presence: true
end
