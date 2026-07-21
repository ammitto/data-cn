#!/usr/bin/env ruby
# frozen_string_literal: true

# Load China sanctions data into SQLite and run integrity tests using the ammitto gem
#
# Usage:
#   ruby scripts/load_and_test_cn_data.rb                     # Default: processed/
#   ruby scripts/load_and_test_cn_data.rb /path/to/processed  # Custom path

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'ammitto'
require 'ammitto/data/china/loader'

processed_dir = ARGV[0] || File.join(File.dirname(__dir__), 'processed')

unless Dir.exist?(processed_dir)
  puts "Error: Processed directory not found: #{processed_dir}"
  exit(2)
end

loader = Ammitto::Data::China::Loader.new('cn_sanctions.db')
loader.load_from_directory(processed_dir)
success = loader.run_integrity_tests?
exit(success ? 0 : 1)
