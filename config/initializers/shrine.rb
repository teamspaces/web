require "shrine"
require "shrine/storage/file_system"
require "image_processing/mini_magick"
require "shrine/storage/s3"



Shrine.storages = case ENV["STORAGE_MEDIUM"]
when "s3"
  s3_options = {
    access_key_id:     "abc",
    secret_access_key: "xyz",
    region:            "my-region",
    bucket:            "my-bucket",
  }

  { cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
    store: Shrine::Storage::S3.new(prefix: "store", **s3_options) }
else # default to 'local'
  { cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store") }
end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # cache forms
Shrine.plugin :backgrounding
# perform processing in background
Shrine::Attacher.promote { |data| PromoteJob.perform_later(data) }
Shrine::Attacher.delete { |data| DeleteJob.perform_later(data) }
