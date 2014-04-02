class UserService

  def initialize(user)
    @user = user
  end

  def update(data)
    @user.attributes = data

    self
  end

  def save
    @user.save
  end
end
