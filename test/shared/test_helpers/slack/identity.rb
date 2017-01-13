class TestHelpers
  class Slack

    def self.identity(type)
      Identity.new.public_send(type)
    end

    def self.user_object(type)
      UserObject.new.public_send(type)
    end

    class Identity

      def unknown_user
        identity = default_identity

        identity.merge!({ team: { id: "T0C8MBADA" },
                          user: { id: "U2ZILGD39",
                                  name: "Maria Balvin",
                                  email: "maria@balvin.com" }})
        identity
      end

      def existing_user
        identity = default_identity

        identity.merge!({ team: { id: "T0C7MBADQ" },
                          user: { id: "U2ZKLGE49",
                                  name: "Milad Marzano",
                                  email: "milad@lui.com" }})

        identity
      end

      private

        def default_identity
          OmniAuth::AuthHash.new({ok: true,
                                  team: {
                                    domain: "teamspaces",
                                    id: "T0C8MBADQ",
                                    image_102: "https://a.slack-edge.com/66f9/img/avatars-teams/ava_0013-102.png",
                                    image_132: "https://a.slack-edge.com/66f9/img/avatars-teams/ava_0013-132.png",
                                    image_230: "https://a.slack-edge.com/bfaba/img/avatars-teams/ava_0013-230.png",
                                    image_34: "https://a.slack-edge.com/66f9/img/avatars-teams/ava_0013-34.png",
                                    image_44: "https://a.slack-edge.com/66f9/img/avatars-teams/ava_0013-44.png",
                                    image_68: "https://a.slack-edge.com/66f9/img/avatars-teams/ava_0013-68.png",
                                    image_88: "https://a.slack-edge.com/66f9/img/avatars-teams/ava_0013-88.png",
                                    image_default: true,
                                    name: "Spaces"
                                  },
                                  user: {
                                    email: "emmanuel@furrow.io",
                                    id: "U2ZKLGD39",
                                    image_1024: "https://avatars.slack-edge.com/2016-11-13/webmock_avatar_image_192.jpg",
                                    image_192: "https://avatars.slack-edge.com/2016-11-13/webmock_avatar_image_192.jpg",
                                    image_24: "https://avatars.slack-edge.com/2016-11-13/webmock_avatar_image_24.jpg",
                                    image_32: "https://avatars.slack-edge.com/2016-11-13/webmock_avatar_image_32.jpg",
                                    image_48: "https://avatars.slack-edge.com/2016-11-13/webmock_avatar_image_48.jpg",
                                    image_512:"https://avatars.slack-edge.com/2016-11-13/webmock_avatar_image_192.jpg",
                                    image_72: "https://avatars.slack-edge.com/2016-11-13/webmock_avatar_image_72.jpg",
                                    name: "Emmanuel Stadler"
                                  }
                              })
        end
    end

    class UserObject

      def unknown_user
        user_object = default_user_object

        user_object.user.merge!({id: "U2ZILGD39",
                                 real_name: "Maria Balvin",
                                 team_id: "T0C8MBADA",
                                 profile: { email: "maria@balvin.com" }})
        user_object
      end

      def existing_user
        user_object = default_user_object

        user_object.user.merge!({id: "U2ZKLGE49",
                                 real_name: "Milad Marzano",
                                 team_id: "T0C7MBADQ",
                                 profile: { email: "milad@lui.com" }})
        user_object
      end

      def invited_user_for_spaces_team
        user_object = default_user_object

        user_object.user.merge!({id: "U4919w39",
                                 real_name: "Nina Malone",
                                 profile: { email: "nina_malone@spaces.is" }})
        user_object
      end

      def slack_bot
        user_object = default_user_object

        user_object.user.merge!({id: "USLACKBOT",
                                 name: "slackbot",
                                 real_name: "slackbot"})
        user_object
      end

      def deleted
        user_object = default_user_object

        user_object.user.merge!({deleted: true})

        user_object
      end

      private

        def default_user_object
          OmniAuth::AuthHash.new({ok: true,
                                  user: { id: "U2ZKLGD39",
                                          team_id: "T0C8MBADQ",
                                          name: "emmanuel",
                                          deleted: false,
                                          status: nil,
                                          color: "3c989f",
                                          real_name: "Emmanuel Stadler",
                                          tz: "Europe/Amsterdam",
                                          tz_label: "Central European Time",
                                          tz_offset: 3600,
                                          profile: { first_name: "Emmanuel",
                                                     last_name: "Stadler",
                                                     avatar_hash: "7f9c724553d0",
                                                     image_24: "https://avatars.slack-edge.com/2016-11-13/webmock_avatar_image_24.jpg",
                                                     image_32: "https://avatars.slack-edge.com/2016-11-13/webmock_avatar_image_32.jpg",
                                                     image_48: "https://avatars.slack-edge.com/2016-11-13/webmock_avatar_image_48.jpg",
                                                     image_72: "https://avatars.slack-edge.com/2016-11-13/webmock_avatar_image_72.jpg",
                                                     image_192: "https://avatars.slack-edge.com/2016-11-13/webmock_avatar_image_192.jpg",
                                                     image_512: "https://avatars.slack-edge.com/2016-11-13/webmock_avatar_image_192.jpg",
                                                     image_1024: "https://avatars.slack-edge.com/2016-11-13/webmock_avatar_image_192.jpg",
                                                     image_original: "https://avatars.slack-edge.com/2016-11-13/webmock_avatar_image_original.jpg",
                                                     title: "",
                                                     phone: "",
                                                     skype: "",
                                                     real_name: "Emmanuel Stadler",
                                                     real_name_normalized: "Emmanuel Stadler",
                                                     email: "emmanuel@spaces.is"
                                                    },
                                          is_admin: true,
                                          is_owner: true,
                                          is_primary_owner: false,
                                          is_restricted: false,
                                          is_ultra_restricted: false,
                                          is_bot: false,
                                          has_2fa: false}
                              })
        end
    end

  end
end
