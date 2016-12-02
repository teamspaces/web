class TestHelpers
  class Slack

    def self.identity(type)
      Identity.new.public_send(type)
    end

    class Identity

      def unknown_user
        identity = default_identity

        identity.user.merge!({id: "U2ZILGD39",
                              real_name: "Maria Balvin",
                              team_id: "T0C8MBADA",
                              profile: { email: "maria@balvin.com" }})
        identity
      end

      def existing_user
        identity = default_identity

        identity.user.merge!({id: "U2ZKLGE49",
                              real_name: "Milad Marzano",
                              team_id: "T0C7MBADQ",
                              profile: { email: "milad@lui.com" }})
        identity
      end

      private

        def default_identity
          @default_identity ||= OmniAuth::AuthHash.new(JSON.parse("{\"ok\":true,\"user\":{\"id\":\"U2ZKLGD39\",\"team_id\":\"T0C8MBADQ\",\"name\":\"emmanuel\",\"deleted\":false,\"status\":null,\"color\":\"3c989f\",\"real_name\":\"Emmanuel Stadler\",\"tz\":\"Europe/Amsterdam\",\"tz_label\":\"Central European Time\",\"tz_offset\":3600,\"profile\":{\"first_name\":\"Emmanuel\",\"last_name\":\"Stadler\",\"avatar_hash\":\"7f9c724553d0\",\"image_24\":\"https://avatars.slack-edge.com/2016-11-13/104047724484_7f9c724553d01d5edd8f_24.jpg\",\"image_32\":\"https://avatars.slack-edge.com/2016-11-13/104047724484_7f9c724553d01d5edd8f_32.jpg\",\"image_48\":\"https://avatars.slack-edge.com/2016-11-13/104047724484_7f9c724553d01d5edd8f_48.jpg\",\"image_72\":\"https://avatars.slack-edge.com/2016-11-13/104047724484_7f9c724553d01d5edd8f_72.jpg\",\"image_192\":\"https://avatars.slack-edge.com/2016-11-13/104047724484_7f9c724553d01d5edd8f_192.jpg\",\"image_512\":\"https://avatars.slack-edge.com/2016-11-13/104047724484_7f9c724553d01d5edd8f_192.jpg\",\"image_1024\":\"https://avatars.slack-edge.com/2016-11-13/104047724484_7f9c724553d01d5edd8f_192.jpg\",\"image_original\":\"https://avatars.slack-edge.com/2016-11-13/104047724484_7f9c724553d01d5edd8f_original.jpg\",\"title\":\"\",\"phone\":\"\",\"skype\":\"\",\"real_name\":\"Emmanuel Stadler\",\"real_name_normalized\":\"Emmanuel Stadler\",\"email\":\"emmanuel@furrow.io\"},\"is_admin\":true,\"is_owner\":true,\"is_primary_owner\":false,\"is_restricted\":false,\"is_ultra_restricted\":false,\"is_bot\":false,\"has_2fa\":false}}"))
        end
    end
  end
end

