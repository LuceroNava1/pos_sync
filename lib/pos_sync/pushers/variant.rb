module Pushers
  class Variant
    attr_reader :connector, :base_data

    def initialize(connector, base_data)
      @connector = connector
      @base_data = base_data
    end

    def create(tasks)
    end

    def update(tasks)
    end
  end
end
