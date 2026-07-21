#!/usr/bin/env ruby
# frozen_string_literal: true

# Validate China sanctions data using the ammitto gem
#
# Usage:
#   ruby scripts/validate_cn_data.rb                    # Validate all files
#   ruby scripts/validate_cn_data.rb sources/           # Validate specific directory
#   ruby scripts/validate_cn_data.rb file.yml -v        # Validate single file with verbose output

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'ammitto'
require 'ammitto/cli/validate_command'

Ammitto::Cmd::ValidateCommand.start(['china'] + ARGV)
