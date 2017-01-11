require "shrine"
require "shrine/storage/file_system"
require "image_processing/mini_magick"
require "shrine/storage/s3"

s3_options = {
  access_key_id:     "abc",
  secret_access_key: "xyz",
  region:            "my-region",
  bucket:            "my-bucket",
}

if Rails.env.production?
  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
    store: Shrine::Storage::S3.new(prefix: "store", **s3_options),
  }
else
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"), # permanent
  }
end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for forms
#Shrine.plugin :rack_file # for non-Rails apps

Shrine.plugin :background_helpers

Shrine::Attacher.promote { |data| PromoteJob.perform_later(data) }
Shrine::Attacher.delete { |data| DeleteJob.perform_later(data) }
