#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

# Paths
MAIN_INDEX = '/Users/mulgogi/src/ammitto/data/api/v1/search-index.json'
CN_INDEX = '/Users/mulgogi/src/ammitto/data-cn/api/search-index.json'
OUTPUT_INDEX = '/Users/mulgogi/src/ammitto/data/api/v1/search-index.json'

puts 'Loading main search index...'
main_data = JSON.parse(File.read(MAIN_INDEX))

puts 'Loading CN search index...'
cn_data = JSON.parse(File.read(CN_INDEX))

# Get CN entity refs from the new data
cn_refs = cn_data['entities'].map { |e| e['ref'] }
puts "CN entities in new data: #{cn_refs.count}"

# Remove old CN entities from main index
old_count = main_data['entities'].count
main_data['entities'].reject! { |e| e['ref'].start_with?('cn/') }
new_count = main_data['entities'].count
removed = old_count - new_count
puts "Removed #{removed} old CN entities from main index"

# Add new CN entities
main_data['entities'].concat(cn_data['entities'])
puts "Added #{cn_data['entities'].count} new CN entities"

# Update metadata
main_data['metadata']['totalEntities'] = main_data['entities'].count
main_data['metadata']['generated'] = Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')

puts "Total entities: #{main_data['metadata']['totalEntities']}"

# Write output
puts "Writing to #{OUTPUT_INDEX}..."
File.write(OUTPUT_INDEX, JSON.generate(main_data))

puts 'Done!'

# Also copy to website
WEBSITE_OUTPUT = '/Users/mulgogi/src/ammitto/ammitto.github.io/public/api/v1/search-index.json'
puts 'Copying to website...'
File.write(WEBSITE_OUTPUT, JSON.generate(main_data))

puts 'All done!'
