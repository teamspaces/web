require "shrine"
require "shrine/storage/file_system"
require "image_processing/mini_magick"
require "shrine/storage/s3"

def set_s3_as_storage_medium
  s3_options = {
    access_key_id:     "abc",
    secret_access_key: "xyz",
    region:            "my-region",
    bucket:            "my-bucket",
  }

  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
    store: Shrine::Storage::S3.new(prefix: "store", **s3_options),
  }
end

def set_file_system_as_storage_medium
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"), # permanent
  }
end

case ENV["STORAGE_MEDIUM"]
  when "s3" then set_s3_as_storage_medium
  when "local" then set_file_system_as_storage_medium
end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # cache forms
Shrine.plugin :backgrounding
# perform processing in background
Shrine::Attacher.promote { |data| PromoteJob.perform_later(data) }
Shrine::Attacher.delete { |data| DeleteJob.perform_later(data) }
