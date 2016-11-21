module HasOneCollabPage
  extend ActiveSupport::Concern

  included do
    after_create :create_collab_page
    after_destroy :destroy_collab_page
  end

  def collab_page
    CollabPage.where(id: "#{id}").first_or_create!({
        _type: "http://sharejs.org/types/rich-text/v1",
        _m: {
          ctime: Time.now.to_i.to_f,
          mtime: Time.now.to_i.to_f
        },
        _v: 1,
        ops: [],
        _o: BSON::ObjectId.new
      })
  end

  private

    def create_collab_page
      collab_page
    end

    def destroy_collab_page
      collab_page.destroy
    end
end
