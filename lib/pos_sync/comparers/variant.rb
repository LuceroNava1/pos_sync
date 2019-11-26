module Comparers
  class Variant
    def initialize
      @result = {
        new: [],
        update: [],
        delete: []
      }
      @compare_col = :sku
    end

    def compare(base_data, external_data)
      external_data[:variant].each do |ex_var|
        base_var_idx = base_data[:sku][ex_var[:sku]]

        if base_var_idx
          # Variant Exists
          base_var = base_data[:variant][base_var_idx]
          changed = field_compare(base_var, ex_var)
          @result[:update] << changed if changed&.dig(:_status) == :changed
        else
          # Variant is
          exists_product = base_data[:product_matched][ex_var[:product_id]]
          next unless exists_product

          new_var = ex_var.dup
          @result[:new] << new_var
        end
      end
      @result
    end

    def field_compare(base, external)
      compare_fields = %i[sku price inventory_level option_values]
      nested_fields = {
        option_values: %i[label option_display_name]
      }
      new_obj = nil
      external.keys.each do |k|
        nested = nil
        next unless compare_fields.include? k
        next if base[k] == external[k]
        if k == :option_values
          next if base[k].empty?
          nested = nested_field_compare(base[k], external[k], nested_fields[k])
          next if nested&.empty?
        end
        next if k == :inventory_level && external[k] == nil && base[k] == 0

        new_obj ||= base.dup
        new_obj[:_changes] ||= {}
        new_obj[:_changes][k] = [base[k], external[k]]
        new_obj[k] = nested || external[k]
        new_obj[:_status] = :changed
      end
      new_obj
    end

    def nested_field_compare(base, external, fields)
      if external.is_a? Array
        result = []
        external.each do |i|
          base_n = base.find {|b| b[:label] == i[:label] }
          result << nested_field_compare(base_n, i, fields)
        end
        return result.compact
      end

      # Hash record
      new_obj = nil
      external.keys.each do |k|
        next if base[k] == external[k]
        new_obj ||= base.dup
        new_obj[:_changes] ||= {}
        new_obj[:_changes][k] = [base[k], external[k]]
        new_obj[k] = external[k]
        new_obj[:_status] = :changed
      end
      new_obj
    end
  end
end