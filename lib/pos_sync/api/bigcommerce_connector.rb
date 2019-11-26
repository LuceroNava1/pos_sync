require 'bigcommerce'

module Api
  class BigcommerceConnector
    attr_reader :connection

    BASE_URL = 'https://api.bigcommerce.com'

    def initialize(store_hash, client_id, access_token)
      @store_url = URI.join(BASE_URL, "/stores/#{store_hash}/").to_s

      @connection = Bigcommerce.configure do |config|
        config.store_hash = store_hash
        config.client_id = client_id
        config.access_token = access_token
      end
    end

    def products
      #Bigcommerce::Product.all
      url = build_url('v3/catalog/products?include=variants,images,options&limit=250')
      res = @connection.get(url)
      res_h = JSON.parse(res.env.body, symbolize_names: true)
      res_h[:data]
    end

    def products_push(payload)
      url = build_url('v3/catalog/products')
      res = @connection.post(url, payload.to_json)
      raise(res.env.body) unless res.success? # this endpoint dont raise exception like categories endpoint

      JSON.parse(res.env.body, symbolize_names: true)
    rescue => ex
      error = JSON.parse(ex.message, symbolize_names: true)
      puts error[:errors].values.join(',').red
      payload[:_errors] = error[:errors].values.join(',')
      { data: payload }
    end

    def products_update(payload)
      url = build_url("v3/catalog/products/#{payload[:id]}")
      res = @connection.put(url, payload.to_json)
      JSON.parse(res.env.body, symbolize_names: true)
    end

    def image_push(id, payload)
      url = build_url("v3/catalog/products/#{id}/images")
      res = @connection.post(url, payload.to_json)
      JSON.parse(res.env.body, symbolize_names: true)
    rescue => ex
      error = JSON.parse(ex.message, symbolize_names: true)
      puts error[:errors].values.join(',').red
      payload[:_errors] = error[:errors].values.join(',')
      { data: payload }
    end

    def option_push(product_id, name, variants)
      url = build_url("v3/catalog/products/#{product_id}/options")
      variants = variants.map.with_index do |item, idx|
        { label: item, sort_order: idx }
      end
      payload = {
        name: name,
        display_name: name.capitalize,
        type: "rectangles",
        option_values: variants
      }
      res = @connection.post(url, payload)
      JSON.parse(res.env.body, symbolize_names: true)
    end

    def option_value_push(product_id, option_id, name)
      url = build_url("v3/catalog/products/#{product_id}/options/#{option_id}/values")
      payload = {
        label: name,
        sort_order: 0
      }.to_json
      res = @connection.post(url, payload)
      JSON.parse(res.env.body, symbolize_names: true)
    end

    def variant_push(product_id, values = {})
      url = build_url("v3/catalog/#{product_id}/variants")
      options = options.each do |item|
        { option_id: item, id: item }
      end
      payload = {
        sku: values[:sku],
        option_values: options
      }
      res = @connection.post(url)
      JSON.parse(res.env.body, symbolize_names: true)
    end

    def category_push(payload)
      url = build_url("v3/catalog/categories")
      res = @connection.post(url, payload.to_json)
      JSON.parse(res.env.body, symbolize_names: true)
    rescue => ex
      error = JSON.parse(ex.message, symbolize_names: true)
      msg = error[:errors].empty? ? error[:title] : error[:errors].values.join(',')
      puts msg.red
      payload[:_errors] = error[:errors].values.join(',')
      { data: payload }
    end

    def listing_push(channel_id, payload)
      url = build_url("v3/channels/#{channel_id}/listings")
      res = @connection.post(url, payload.to_json)
      JSON.parse(res.env.body, symbolize_names: true)
    rescue => ex
      error = JSON.parse(ex.message, symbolize_names: true)
      puts error[:errors].values.join(',').red
      payload[:_errors] = error[:errors].values.join(',')
      { data: payload }
    end

    def categories
      Bigcommerce::Category.all
    end

    def variants
      url = build_url('v3/catalog/variants?limit=250')
      res = @connection.get(url)
      res_h = JSON.parse(res.env.body, symbolize_names: true)
      res_h[:data]
    end

    private

    def build_url(endpoint)
      URI.join(@store_url, endpoint).to_s
    end

  end
end
