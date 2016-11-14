class PageRevisionAuthor < ApplicationRecord
  belongs_to :page_revision
  belongs_to :user_id
end
