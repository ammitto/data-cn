# frozen_string_literal: true

module DataCn
  # Discovers YAML files in the sources directory
  class FileFinder
    DEFAULT_SOURCES_DIR = 'sources'

    attr_reader :sources_dir

    def initialize(sources_dir = DEFAULT_SOURCES_DIR)
      @sources_dir = sources_dir
    end

    # Find all YAML files in sources directory
    # @return [Array<String>] List of file paths
    def find_all
      Dir.glob(File.join(sources_dir, '**', '*.{yml,yaml}')).sort
    end

    # Find files for a specific subdirectory
    # @param subdir [String] Subdirectory name
    # @return [Array<String>] List of file paths
    def find_in(subdir)
      Dir.glob(File.join(sources_dir, subdir, '**', '*.{yml,yaml}')).sort
    end

    # Check if sources directory exists
    def sources_exist?
      Dir.exist?(sources_dir)
    end
  end
end
