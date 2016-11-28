class Slack::Identity::Invalid
  def self.new
    return Slack::Messages::Message.new({
            "ok": false,
            "error": "missing_scope",
            "needed": "identity.basic",
            "provided": "identify,read,post,client,apps,admin"
        })
  end
end
