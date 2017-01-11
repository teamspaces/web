
class User::AttachDefaultAvatar
  include Interactor

  def call

  end
 # before_create :generate_avatar


 # def generate_avatar
 #   attacher = Shrine::AvatarUploader::Attacher.new(self, :avatar)
 #   img = Avatarly.generate_avatar(self.name)
 #   temp_file = Tempfile.new("avatar_temp.png", encoding: "ascii-8bit")
 #   temp_file.write(img)
 #   attacher.assign(temp_file)
 #   temp_file.close
 #   temp_file.delete
 # end

end
