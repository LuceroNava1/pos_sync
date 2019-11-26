module Comparers
  class Category
    NO_CATEGORY_NAME = 'Uncategorized Square Item'

    def initialize
      @result = {
        new: [],
        update: [],
        delete: []
      }
      @compare_col = :name
    end

    def compare(base_data, external_data)
      external_data[:category].each do |ex_cat|
        match = base_data[:category].find { |bc_cat| bc_cat[@compare_col].downcase == ex_cat[@compare_col].downcase }
        @result[:new] << ex_cat unless match
      end

      # handle empty Cat
      any_product_without_category = external_data[:product].any? {|i| i[:categories].nil? }
      empty_category_not_exist = !base_data[:category].any? {|c| c[:name] == NO_CATEGORY_NAME }
      if any_product_without_category && empty_category_not_exist
        new_cat = { id: nil, name: NO_CATEGORY_NAME }
        @result[:new] << new_cat
        external_data[:category] << new_cat
      end

      @result
    end
  end
end
