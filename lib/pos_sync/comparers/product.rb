module Comparers
  class Product
    def initialize
      @result = {
        new: [],
        update: [],
        delete: []
      }
      @compare_col = :sku
    end

    #           Prd | Var
    #  new    |     |
    #  update |     |
    def compare(base_data, external_data)
      external_data[:product].each do |ex_prd|
        base_prd_id = base_data[:product_matched][ex_prd[:id]]
        changed = nil

        if base_prd_id
          # Product exists
          base_prd = base_data[:product].find {|p| p[:id] == base_prd_id }
          changed = field_compare(base_prd, ex_prd, base_data[:category_matched])
          @result[:update] << changed if changed
        else
          # Product is new
          changed = ex_prd.dup
          @result[:new] << changed
        end

        next unless changed
        # Product Special Rules
        has_dummy_variant = ex_prd[:variants].any? {|v| v[:option_values].empty?  }
        changed.delete(:variants) if has_dummy_variant
        changed[:ex_options] = ex_prd[:variants].map {|i| [i[:sku], i[:option_values].first[:label]] }.to_h if changed[:variants]
        changed[:categories] = external_data[:category].find {|c| c[:id] == changed[:categories] }&.dig(:name)
        changed[:inventory_tracking] = if ex_prd[:variants].all? {|i| i[:inventory_level].nil? }
                                        'none'
                                      elsif ex_prd[:variants].size == 1
                                        'product'
                                      else
                                        'variant'
                                      end
        changed[:inventory_level] = 0
        changed[:inventory_level] = ex_prd[:variants].first[:inventory_level] if changed[:inventory_tracking] == 'product'
      end
      @result[:update].each {|i| clean_fields(i) }
      @result
    end

    def field_compare(base, external, category_idx)
      # left out variants as compare purpose it will be process separetely
      compare_fields = %i[name description sku image_url price inventory_level categories]
      new_obj = nil
      external.keys.each do |k|
        next unless compare_fields.include? k
        next if base[k] == external[k]

        next if k == :image_url && base[:images].size > 0 # Has an image
        next if k == :description && base[k] == external[k].to_s

        if k == :categories
          next if base[:categories].first == category_idx.dig(external[k])
          base[:categories] = [category_idx.dig(external[k])]
        end

        new_obj ||= base.dup
        new_obj[:_changes] ||= {}
        new_obj[:_changes][k] = [base[k], external[k]]
        new_obj[k] = external[k]
      end
      new_obj
    end

    def clean_fields(prd_hash)
      clean_fields = %i[variants images]
      prd_hash.delete_if {|k, _| clean_fields.include? k }
    end
  end
end
