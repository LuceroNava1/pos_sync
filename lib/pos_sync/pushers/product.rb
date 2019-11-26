require_relative '../factory/factory'

module Pushers
  class Product
    attr_reader :connector, :base_data

    def initialize(connector, base_data)
      @connector = connector
      @base_data = base_data
    end

    def create(tasks)
      created = []
      tasks.each do |prd|
        new_prd = Factory.product(prd)
        new_prd[:categories] = [base_data[:category].find {|c| c[:name]&.downcase == prd[:categories]&.downcase }&.dig(:id)].compact
        new_prd.compact!
        new_obj = connector.products_push(new_prd)
        created << new_obj.dig(:data)
        base_data[:product] << new_obj.dig(:data)

        next if new_obj.dig(:data, :_errors)

        new_prd_id = new_obj.dig(:data, :id)

        # Prd Image
        new_img = Factory.image(prd)
        new_obj = connector.image_push(new_prd_id, new_img) if new_img

        # Prd Listing
        channel_id = 20771
        new_listing = Factory.listing(prd)
        new_obj = connector.listing_push(channel_id, new_listing)

        yield if block_given?
      end
      created
    end

    def update(tasks)
      updated = []

      tasks.each do |prd|
        prd.delete_if {|k,v| k.to_s.match(/^_/) }
        prd.compact!
        updated = connector.products_update(prd)

        yield if block_given?
      end
      updated
    end
  end
end
