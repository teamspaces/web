class CollabPage
  include Mongoid::Document
  store_in collection: "collab_pages"

  field :_id, type: String
  field :ops, type: Array
  field :_type, type: String
  field :_v, type: Integer
  field :_m, type: Hash
  field :_0, type: BSON::ObjectId
end
