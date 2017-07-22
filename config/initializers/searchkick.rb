# Timeout
Searchkick.timeout = 3

# AWS ES Support
if ENV["ENABLE_AWS_ELASTICSEARCH"] == "true"
  Searchkick.aws_credentials = {
    access_key_id: ENV["AWS_ACCESS_KEY_ID"],
    secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
    region: ENV["AWS_REGION"]
  }
end
