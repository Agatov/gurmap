class SocialChecker

  attr_accessor :order, :success, :vk

  # @param [Order] order
  def initialize(unchecked_order)

    self.order = unchecked_order

    self.success = false

    self.vk = VkontakteApi::Client.new(order.user.authentication.token)
    self.vk.users.get(uid: order.user.authentication.uid)
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
    "gurmap.ru/places/#{order.place_id}##{order.id}"
  end

end