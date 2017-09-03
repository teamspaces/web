class LinkReferenceSerializer < ActiveModel::Serializer
  attributes :id, :reference_id, :reference_model, :text, :link

  def text
    Page.find(object.reference_id).title
  end

  def link
    scope.page_url(object.reference_id)
  end
end
