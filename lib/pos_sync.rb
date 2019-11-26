require 'dotenv/load'
require 'awesome_print'
require_relative 'pos_sync/api/connector'
require_relative 'pos_sync/digestors/digestor'
require_relative 'pos_sync/comparers/comparer'
require_relative 'pos_sync/pushers/pusher'
require_relative 'pos_sync/helpers/cache'

start = Time.now

cache = Helpers::Cache.new

# --------------------------------------------------------------------------------------
puts 'Getting data...'
bc_data = cache.load_file('bc_data') || Api::Connector.new(:bigcommerce).data
sq_data = cache.load_file('sq_data') || Api::Connector.new(:square).data
cache.write_file('bc_data', bc_data)
cache.write_file('sq_data', sq_data)
puts "API Getting values Time: #{Time.now - start} sec.\n".blue

# --------------------------------------------------------------------------------------
puts 'Start digesting...'
second = Time.now
sq_digest = Digestors::Digestor.new(:square, sq_data).get_data
bc_digest = Digestors::Digestor.new(:bigcommerce, bc_data).get_data

prd_matched = sq_data[:variant].map do |v|
                sqsku = v[:item_variation_data][:sku]
                next unless bc_digest[:sku][sqsku]
                sq_id = v[:item_variation_data][:item_id]
                bc_id = bc_data[:variant][bc_digest[:sku][sqsku]][:product_id]
                [sq_id, bc_id]
              end.compact.to_h
cat_matched = sq_data[:category].map do |v|
                name = v[:category_data][:name]
                bc_category = bc_data[:category].find {|x| x[:name] == name }
                next unless bc_category
                sq_id = v[:id]
                bc_id = bc_category[:id]
                [sq_id, bc_id]
              end.compact.to_h
# Adds the square no category option to index
cat_matched[nil] = bc_digest[:category].find {|c| c[:name] == Comparers::Category::NO_CATEGORY_NAME }&.dig(:id)

bc_digest[:product_matched] = prd_matched
bc_digest[:category_matched] = cat_matched

## ap prd, multiline: true, limit: true
puts "\nDigesting Time: #{Time.now - second} sec.\n".blue

# --------------------------------------------------------------------------------------
puts 'Start comparing...'
second = Time.now
comparer = Comparers::Comparer.new(bc_data: bc_digest, third_data: sq_digest)
cat_tasks = comparer.compare(type: :category)
var_tasks = comparer.compare(type: :variant)
prd_tasks = comparer.compare(type: :product)
puts "Comparing Time: #{Time.now - second} sec.\n".blue

# --------------------------------------------------------------------------------------
puts 'Start pushing...'
second = Time.now
pusher = Pushers::Pusher.new(bc_digest)
cat_pushed = pusher.push(cat_tasks, type: :category)
prd_pushed = pusher.push(prd_tasks, type: :product)
#var_pushed = pusher.push(prd_tasks, type: :variant)
puts "Pushing Time: #{Time.now - second} sec.\n".blue

puts "Total Elapsed Time: #{Time.now - start} sec.".yellow

#env file


# https://github.com/square/square-ruby-sdk
