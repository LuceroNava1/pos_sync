# fields = %i[id name type sku description price image_url categories inventory_level variants]
# Product = Struct.new(*fields, keyword_init: true)
# bc_prd = Product.new(id: sq.dig(*path))

module Digestors
  category_fields = %i[fields joins after_create]
  DigestorConfig = Struct.new('DigestorConfig', *category_fields, keyword_init: true)

  class Digestor
    def initialize(provider, data)
      file_name = "#{provider.to_s.downcase}.yml"
      @provider = provider
      @data = data

      @conf = YAML.load_file(File.join(File.dirname(__FILE__), file_name))
    end

    def get_data
      case @provider
      when :square
        prd = digest(:product)
        cat = digest(:category)
        var = digest(:variant)
        cat_idx = cat.map {|i| i.to_a.flatten.reject{|x| x.is_a? Symbol } }.to_h
        {
          category: cat,
          category_idx: cat_idx,
          product: prd,
          variant: var
        }
      when :bigcommerce
        bc_cat = digest(:category)
        bc_prd = digest(:product)
        bc_var = digest(:variant)
        bc_sku_idx = @data[:variant].each_with_index.map {|item, idx| [item[:sku], idx] }.to_h
        cat_idx = bc_cat.map {|i| i.to_a.flatten.reject{|x| x.is_a? Symbol } }.to_h
        {
          category: bc_cat,
          product: bc_prd,
          variant: bc_var,
          sku: bc_sku_idx,
          category_idx: cat_idx
        }
      else {}
      end
    end

    def digest(object_name, custom_data: nil)
      #puts "  working on #{object_name}..."
      print '.'
      # object configuration fields
      fields = object_fields(object_name)
      data = custom_data || @data[object_name]

      # Adds additional data
      object_joins(object_name, data)

      if data.is_a? Array
        data.map do |item|
          element = create_element(fields, item)
          after_create_hook(object_name, element)
          element
        end
      else
        element = create_element(fields, data)
        after_create_hook(object_name, element)
        element
      end
    end

    private

    def after_create_hook(object_name, element)
      raw = @conf[object_name]
      after_create = raw['after_create'] || []
      after_create.each do |cmd|
        element.instance_eval cmd
      end
    end

    def object_fields(object_name)
      raw = @conf[object_name]
      fields = raw['fields'] || {}
      normalize_fields(fields)
    end

    def object_joins(object_name, data)
      raw = @conf[object_name]
      joins_hash = raw['joins']
      return if joins_hash.nil? || data.nil? || data.class != Array

      data.each do |element|
        joins_hash.each do |key, val|
          arr = val.split('.')
          object = arr.first.slice(0..-2).downcase.to_sym
          self_id, other_id = arr[1].split('<-').map(&:to_sym)

          join_data = @data[object].select {|item| item[self_id] == element[other_id] }

          if join_data.size == 1
            join_data = join_data.first
          elsif join_data.size == 0
            join_data = nil
          end

          element[key.to_sym] = join_data
        end
      end
    end

    def normalize_fields(fields)
      fields.map do |k, v|
        [k, v.split('.').map(&:to_sym)]
      end.to_h
    end

    def create_element(fields, data)
      return data if fields.empty?

      fields.map do |field, source_field|
        #p source_field
        is_object = source_field.first.match?('!')
        if is_object
          name = source_field.first.slice(0..-2).downcase.to_sym
          path = source_field.slice(1..-1)
          other_data = data.dig(*path)

          value = digest(name, custom_data: other_data)
        else
          value = data.dig(*source_field)
        end

        [field.to_sym, value]
      end.to_h
    end
  end
end
