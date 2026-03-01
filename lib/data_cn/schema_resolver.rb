# frozen_string_literal: true

module DataCn
  # Determines which schema to use for a given file
  class SchemaResolver
    MODIFICATION_DIRECTORIES = %w[
      sanction-updates
      unreliable-entity-list-updates
    ].freeze

    # Directories that use legal instrument schema
    LEGAL_INSTRUMENT_DIRECTORIES = [
      'legal-instruments'
    ].freeze

    class << self
      # Determine schema type based on file path and content
      # @param file_path [String] Path to the YAML file
      # @param content [Hash, nil] Parsed YAML content (optional)
      # @return [Symbol, nil] :announcement, :modification, :legal_instrument, or nil if skipped
      def resolve(file_path, content = nil)
        return :legal_instrument if legal_instrument_directory?(file_path)
        return :modification if modification_directory?(file_path)

        # Check content if available
        if content
          return :modification if modification_content?(content)
          return :announcement if announcement_content?(content)
          return :legal_instrument if legal_instrument_content?(content)
        end

        # Default to announcement for standard directories
        :announcement
      end

      # Check if file is in a legal-instruments directory
      def legal_instrument_directory?(file_path)
        normalized_path = file_path.to_s.downcase
        LEGAL_INSTRUMENT_DIRECTORIES.any? { |dir| normalized_path.include?(dir) }
      end

      # Check if file is in a modification-specific directory
      def modification_directory?(file_path)
        normalized_path = file_path.to_s.downcase
        MODIFICATION_DIRECTORIES.any? { |dir| normalized_path.include?(dir) }
      end

      # Check if content has measure_modifications key
      def modification_content?(content)
        content.is_a?(Hash) && content.key?('measure_modifications')
      end

      # Check if content has sanction_details key
      def announcement_content?(content)
        content.is_a?(Hash) && content.key?('sanction_details')
      end

      # Check if content has legal instrument structure (title and content keys)
      def legal_instrument_content?(content)
        content.is_a?(Hash) && content.key?('title') && content.key?('content')
      end
    end
  end
end
