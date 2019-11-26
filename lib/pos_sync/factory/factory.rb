class Factory
  def self.catalog(data)
    fields = %i[name]
    default = {
      parent_id: 0
    }
    fields.each {|f| default[f] = data[f] }
    default
  end

  def self.product(data = {})
    fields = %i[name description sku price inventory_level inventory_tracking categories variants]
    default = {
      type: 'physical',
      weight: 1,
      price: 0,
      inventory_tracking: 'none',
    }
    fields.each {|f| default[f] = data[f] if data[f] }
    default[:variants] = default[:variants]&.map do |var|
      variant(var)
    end

    default
  end

  def self.variant(data = {})
    fields = %i[sku price inventory_level option_values]
    Hash.new.tap do |h|
      fields.each {|f| h[f] = data[f] }
    end
  end

  def self.image(data = {})
    fields = %i[image_url]
    default = {}
    fields.each {|f| default[f] = data[f] if data[f] }
    default
  end

  def self.listing(data = {})

  end

  def self.listing_variant(data = {})

  end
end