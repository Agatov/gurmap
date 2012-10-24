class SocialChecker

  attr_accessor :uid, :token, :place_id, :order_id, :success, :vk

  def initialize(options = {})
    self.uid = options[:uid]
    self.token = options[:token]
    self.place_id = options[:place_id]
    self.order_id = options[:order_id]

    self.success = false

    self.vk = VkontakteApi::Client.new(token)
    self.vk.users.get(uid: uid)
  end

  def get_wall_posts(count = 5)
    posts = vk.wall.get(count: count)

    # Удаляем количество сообщений на стене
    posts.delete_if {|p| p.is_a? Integer}
    posts
  end

  def check
    get_wall_posts.each do |post|
      break if check_one(post).success?
    end
    self 
  end

  def check_one(post)
    if post.include? expected_url
      self.success = true
    end

    self
  end

  def success?
    success
  end

  def expected_url
    "gurmap.ru/places/#{place_id}##{order_id}"
  end

end