module Pushers
  class Category
    attr_reader :connector, :base_data

    def initialize(connector, base_data)
      @connector = connector
      @base_data = base_data
    end

    def create(tasks)
      created = []
      tasks.each do |cat|
        new_cat = Factory.catalog(cat)
        new_obj = connector.category_push(new_cat)
        created << new_obj.dig(:data)
        base_data[:category] << new_obj.dig(:data)
        yield if block_given?
      end
      created
    end

    # Not needed in catalogs
    def update(tasks)
      updated = []
    end
  end
end
