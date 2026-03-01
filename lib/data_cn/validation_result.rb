# frozen_string_literal: true

module DataCn
  # Represents the validation result for a single file
  class ValidationResult
    attr_reader :file_path, :schema_type, :errors, :parse_error

    def initialize(file_path:, schema_type:, errors: [], parse_error: nil)
      @file_path = file_path
      @schema_type = schema_type
      @errors = errors
      @parse_error = parse_error
    end

    def valid?
      @parse_error.nil? && @errors.empty?
    end

    def has_parse_error?
      !@parse_error.nil?
    end

    def error_count
      @errors.length
    end

    def to_s
      if valid?
        "✓ #{file_path} (#{schema_type})"
      elsif has_parse_error?
        "✗ #{file_path} - Parse Error: #{parse_error}"
      else
        error_list = errors.map { |e| "  - #{e}" }.join("\n")
        "✗ #{file_path} (#{schema_type})\n#{error_list}"
      end
    end
  end
end
