# frozen_string_literal: true

require 'json'
require 'json-schema'
require 'yaml'

module DataCn
  # Main validator class for validating YAML files against JSON schemas
  class Validator
    def initialize
      @schemas = {}
    end

    # Validate a single file
    # @param file_path [String] Path to the YAML file
    # @return [ValidationResult, nil] Validation result, or nil if file should be skipped
    def validate_file(file_path)
      content = load_yaml(file_path)
      schema_type = SchemaResolver.resolve(file_path, content)

      # Skip files that don't have a schema (e.g., legal-instruments)
      return nil if schema_type.nil?

      return parse_error_result(file_path, content) if content.is_a?(Exception)

      schema = load_schema(schema_type)
      return schema_not_found_result(file_path, schema_type) if schema.nil?

      errors = validate_against_schema(content, schema)
      ValidationResult.new(
        file_path: file_path,
        schema_type: schema_type,
        errors: errors
      )
    end

    # Validate multiple files
    # @param file_paths [Array<String>] List of file paths
    # @return [ValidationReport] Aggregated validation report
    def validate_files(file_paths)
      results = file_paths.map { |path| validate_file(path) }.compact
      ValidationReport.new(results)
    end

    # Validate all YAML files in sources directory
    # @param sources_dir [String] Path to sources directory
    # @return [ValidationReport] Aggregated validation report
    def validate_all(sources_dir = 'sources')
      finder = FileFinder.new(sources_dir)
      raise ArgumentError, "Sources directory not found: #{sources_dir}" unless finder.sources_exist?

      validate_files(finder.find_all)
    end

    private

    def load_yaml(file_path)
      YAML.safe_load_file(file_path, permitted_classes: [Date, Time], aliases: true)
    rescue Psych::SyntaxError => e
      e
    rescue StandardError => e
      e
    end

    def load_schema(schema_type)
      @schemas[schema_type] ||= begin
        case schema_type
        when :announcement
          SchemaLoader.load_announcement_schema
        when :modification
          SchemaLoader.load_modification_schema
        when :legal_instrument
          SchemaLoader.load_legal_instrument_schema
        end
      rescue SchemaNotFoundError
        nil
      end
    end

    def validate_against_schema(content, schema)
      # Convert content to JSON and back to ensure all values are in a format
      # that the JSON schema validator expects (e.g., dates as strings)
      json_content = JSON.parse(content.to_json)
      JSON::Validator.fully_validate(schema, json_content, validate_schema: false)
    rescue StandardError => e
      ["Validation error: #{e.message}"]
    end

    def parse_error_result(file_path, error)
      ValidationResult.new(
        file_path: file_path,
        schema_type: :unknown,
        parse_error: error.message
      )
    end

    def schema_not_found_result(file_path, schema_type)
      ValidationResult.new(
        file_path: file_path,
        schema_type: schema_type,
        errors: ["Schema not found for type: #{schema_type}"]
      )
    end
  end
end
