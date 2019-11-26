require_relative 'square_connector'
require_relative 'bigcommerce_connector'

module Api
  class Connector
    attr_accessor :data

    def initialize(integration)
      send(integration) if self.respond_to? integration
    end

    def square
      puts '  Getting Square data...'.cyanish
      token = ENV['SQ_TOKEN']
      square = SquareConnector.new(token)
      p = square.products
      i = square.inventory
      l = square.locations

      @data = {
        product: p.select { |x| x[:type] == 'ITEM' },
        category: p.select { |x| x[:type] == 'CATEGORY' },
        inventory: i,
        image: p.select { |x| x[:type] == 'IMAGE' },
        # TODO: Delete if not needed at PoC end
        variant: p.select { |x| x[:type] == 'ITEM_VARIATION' }
      }
    end

    def bigcommerce
      puts '  Getting BigCommerce data...'.cyanish
      bc = BigcommerceConnector.new(ENV['BC_STORE_HASH'], ENV['BC_CLIENT_ID'], ENV['BC_ACCESS_TOKEN'])

      @data = {
        product: bc.products,
        category: bc.categories,
        variant: bc.variants
      }
    end

  end
end
