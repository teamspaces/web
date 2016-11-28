class Slack::Identity::Existing
  # fixture users.yml (slack_user_milad)
  def self.new
    return Slack::Messages::Message.new({
      "ok"=>true,
      "user"=>{ "name"=>"Milad Marzano",
                "id"=>"U2ZKLGE49",
                "email"=>"milad@lui.com",
                "image_24"=>"https://avatars.slack-edge.com/2016-11-13/104047724484_7f9c724553d01d5edd8f_24.jpg",
                "image_32"=>"https://avatars.slack-edge.com/2016-11-13/104047724484_7f9c724553d01d5edd8f_32.jpg",
                "image_48"=>"https://avatars.slack-edge.com/2016-11-13/104047724484_7f9c724553d01d5edd8f_48.jpg",
                "image_72"=>"https://avatars.slack-edge.com/2016-11-13/104047724484_7f9c724553d01d5edd8f_72.jpg",
                "image_192"=>"https://avatars.slack-edge.com/2016-11-13/104047724484_7f9c724553d01d5edd8f_192.jpg",
                "image_512"=>"https://avatars.slack-edge.com/2016-11-13/104047724484_7f9c724553d01d5edd8f_192.jpg",
                "image_1024"=>"https://avatars.slack-edge.com/2016-11-13/104047724484_7f9c724553d01d5edd8f_192.jpg"
              },
      "team"=>{ "id"=>"T0C7MBADQ",
                "name"=>"La Industria",
                "domain"=>"laindustria",
                "image_34"=>"https://a.slack-edge.com/66f9/img/avatars-teams/ava_0013-34.png",
                "image_44"=>"https://a.slack-edge.com/66f9/img/avatars-teams/ava_0013-44.png",
                "image_68"=>"https://a.slack-edge.com/66f9/img/avatars-teams/ava_0013-68.png",
                "image_88"=>"https://a.slack-edge.com/66f9/img/avatars-teams/ava_0013-88.png",
                "image_102"=>"https://a.slack-edge.com/66f9/img/avatars-teams/ava_0013-102.png",
                "image_132"=>"https://a.slack-edge.com/66f9/img/avatars-teams/ava_0013-132.png",
                "image_230"=>"https://a.slack-edge.com/9e9be/img/avatars-teams/ava_0013-230.png",
                "image_default"=>true
              }
    })
  end
end
