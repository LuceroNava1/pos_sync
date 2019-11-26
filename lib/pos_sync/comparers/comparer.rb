require_relative 'category'
require_relative 'product'
require_relative 'variant'

module Comparers
  class Comparer
    def initialize(bc_data:, third_data:)
      @bcd = bc_data
      @td = third_data
    end

    def compare(type:)
      comparator = Object.const_get("Comparers::#{type.to_s.capitalize}").new
      comparator.compare(@bcd, @td)
    end
  end
end
