class CollabPage
  include Mongoid::Document

  field :_id, type: String
  field :ops, type: Array
  field :_type, type: String
  field :_v, type: Integer
  field :_m, type: Hash
  field :_o, type: BSON::ObjectId
end
