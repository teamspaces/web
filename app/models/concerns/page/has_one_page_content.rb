class Page
  module HasOnePageContent
    extend ActiveSupport::Concern

    included do
      has_one :page_content
      after_create :create_page_content
    end

    def contents
      page_content.contents
    end

    private

      def create_page_content
        PageContent.find_or_create_by(page_id: id)
      end
  end
end
