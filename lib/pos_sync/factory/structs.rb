category_fields = %i[id name]
Struct.new('Category', *category_fields, keyword_init: true)

product_fields = %i[id type name description image_url price inventory_level inventory_tracking categories variants]
Struct.new('Product', *product_fields, keyword_init: true)

variant_fields = %i[id sku price inventory_level option_values]
Struct.new('Variant', *variant_fields, keyword_init: true)

listing_fields = %i[product_id state name description external_id variants]
Struct.new('Listing', *listing_fields, keyword_init: true)

listing_variant_fields = %i[ variant_id name product_id state external_id]
Struct.new('ListingVariant', *listing_variant_fields, keyword_init: true)

# MyModule.constants
# Kernel.const_get("Struct::Product").new
