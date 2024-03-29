require "shrine"
require "shrine/storage/file_system"
require "image_processing/mini_magick"
require "shrine/storage/s3"

# Our uploaded files are public by default. Shrine busts our
# CDN cache and spends unnecessary time on generating keys
# without this.
class Shrine::Storage::PublicS3 < Shrine::Storage::S3
  def url(id, download: nil, public: true, host: self.host, **options)
    super
  end
end

Shrine.storages = case ENV["STORAGE_MEDIUM"]
when "s3"
  s3_options = {
    access_key_id:     ENV["AWS_ACCESS_KEY_ID"],
    secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
    region:            ENV["AWS_REGION"],
    bucket:            ENV["S3_FILES_BUCKET"]
  }

  { cache: Shrine::Storage::PublicS3.new(prefix: "cache", upload_options: { acl: "public-read", cache_control: "public, max-age=#{30.days}" }, **s3_options),
    store: Shrine::Storage::PublicS3.new(prefix: "store", upload_options: { acl: "public-read", cache_control: "public, max-age=#{30.days}" }, **s3_options) }
else # default to 'local'
  { cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store") }
end

if ENV["STORAGE_MEDIUM"] == "local"
  # delete cached files older than 3 days
  file_system = Shrine.storages[:cache]
  file_system.clear!(older_than: Time.now - 3*24*60*60)
end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # cache forms
Shrine.plugin :backgrounding
# perform processing in background
Shrine::Attacher.promote { |data| PromoteJob.perform_later(data) }
Shrine::Attacher.delete { |data| DeleteJob.perform_later(data) }
