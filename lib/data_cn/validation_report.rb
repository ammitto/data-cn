# frozen_string_literal: true

module DataCn
  # Aggregates validation results with summary statistics
  class ValidationReport
    attr_reader :results

    def initialize(results = [])
      @results = results
    end

    def add_result(result)
      @results << result
      self
    end

    def valid_results
      @results.select(&:valid?)
    end

    def invalid_results
      @results.reject(&:valid?)
    end

    def valid?
      @results.all?(&:valid?)
    end

    def total_count
      @results.length
    end

    def valid_count
      valid_results.length
    end

    def invalid_count
      invalid_results.length
    end

    def parse_error_count
      @results.count(&:has_parse_error?)
    end

    def schema_error_count
      invalid_results.count { |r| !r.has_parse_error? }
    end

    def summary
      <<~SUMMARY
        Validation Summary
        ==================
        Total files: #{total_count}
        Valid: #{valid_count}
        Invalid: #{invalid_count}
        #{parse_error_count.positive? ? "Parse errors: #{parse_error_count}" : ''}
        #{schema_error_count.positive? ? "Schema errors: #{schema_error_count}" : ''}
      SUMMARY
    end

    def to_s(verbose: false)
      lines = []

      if verbose
        @results.each do |result|
          lines << result.to_s
        end
        lines << ''
      end

      # Always show invalid results
      if invalid_results.any?
        lines << 'Invalid files:' unless verbose
        invalid_results.each do |result|
          lines << result.to_s unless verbose
        end
        lines << ''
      end

      lines << summary
      lines.join("\n")
    end
  end
end
