require 'square'
require 'pry'

module Api
  class SquareConnector
    attr_reader :connection

    def initialize(token)
      @connection = Square::Client.new(access_token: token,
                                       environment: 'production',
                                       max_retries: 3)
    end

    def locations
      res = @connection.locations.list_locations
      res.data.locations
    end

    def products(cursor = nil)
      filter = {
        object_types: %w[CATEGORY ITEM ITEM_VARIATION IMAGE],
        begin_time: nil
      }
      puts "    (Products) Using cursor #{cursor}"
      filter[:cursor] = cursor if cursor
      res = @connection.catalog.search_catalog_objects(body: filter)

      if res.success?
        time = res.data.latest_time
        additional_data = []
        additional_data = products(res.body.cursor) if res.body.dig(:cursor)

        res.data.objects + additional_data
      else
        puts res.errors
        OpenStruct.new(errors: res.errors)
      end
    end

    def inventory(cursor = nil)
      filter = {
        location_ids: nil,
        states: ['IN_STOCK']
      }.compact
      puts "    (Inventory) Using cursor #{cursor}"
      filter[:cursor] = cursor if cursor

      res = @connection.inventory.batch_retrieve_inventory_counts(body: filter)

      additional_data = []
      additional_data = inventory(res.body.cursor) if res.body.dig(:cursor)

      res.body.counts + additional_data
    end
  end
end
