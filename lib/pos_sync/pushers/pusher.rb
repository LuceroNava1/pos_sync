require_relative '../api/bigcommerce_connector'
require_relative 'category'
require_relative 'product'

require_relative '../helpers/progress'

module Pushers
  class Pusher
    def initialize(base_data)
      @bc = Api::BigcommerceConnector.new(ENV['BC_STORE_HASH'], ENV['BC_CLIENT_ID'], ENV['BC_ACCESS_TOKEN'])
      @base = base_data
    end

    def push(data, type:)
      pusher = Object.const_get("Pushers::#{type.to_s.capitalize}").new(@bc, @base)
      x = Helpers::Progress.new "Push #{type.to_s.capitalize} objects", 2
      pusher.create(data[:new]) { x.next }
      pusher.update(data[:update]) { x.next }
      x.end
    end
  end
end
