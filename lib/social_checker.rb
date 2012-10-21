class SocialChecker

  attr_accessor :uid, :token, :vk

  def initialize(user_id, access_token)
    self.uid = user_id
    self.token = access_token

    self.vk = VkontakteApi::Client.new(token)
    self.vk.users.get(uid: uid)
  end

  def get_wall_posts(count = 5)
    posts = vk.wall.get(count: count)

    # Удаляем количество сообщений на стене
    posts.delete_if {|p| p.is_a? Integer}
  end

  def check
    get_wall_posts.each do |post|
      #if check_one(post)
    end
  end

  def check_one(post)

  end

end