# frozen_string_literal: true

module DataCn
  # Loads and caches JSON schemas for validation
  class SchemaLoader
    SCHEMAS_DIR = File.join(File.dirname(__FILE__), '..', '..', 'schemas')

    ANNOUNCEMENT_SCHEMA = 'cn-announcement.yml'
    MODIFICATION_SCHEMA = 'cn-measure-modification.yml'
    LEGAL_INSTRUMENT_SCHEMA = 'cn-legal-instrument.yml'

    class << self
      def load_announcement_schema
        load_schema(ANNOUNCEMENT_SCHEMA)
      end

      def load_modification_schema
        load_schema(MODIFICATION_SCHEMA)
      end

      def load_legal_instrument_schema
        load_schema(LEGAL_INSTRUMENT_SCHEMA)
      end

      private

      def load_schema(filename)
        schema_path = File.join(SCHEMAS_DIR, filename)
        raise SchemaNotFoundError, "Schema not found: #{schema_path}" unless File.exist?(schema_path)

        YAML.safe_load_file(schema_path)
      end
    end
  end

  class SchemaNotFoundError < StandardError; end
end
