class ItemService

  def initialize(item)
    @item = item
  end

  def update(data)
    @item.attributes = data

    self
  end

  def save
    @item.save
  end
end
