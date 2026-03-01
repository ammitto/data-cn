#!/usr/bin/env ruby
# frozen_string_literal: true

require 'thor'
require_relative '../lib/data_cn'

module DataCn
  # CLI for validating China sanctions data
  class Cli < Thor
    desc 'validate [PATH]', 'Validate YAML files against JSON schemas'
    option :verbose, type: :boolean, default: false, aliases: '-v',
                     desc: 'Show detailed output for all files'
    option :sources, type: :string, default: 'sources', aliases: '-s',
                     desc: 'Path to sources directory'
    def validate(path = nil)
      validator = Validator.new

      report = if path && File.file?(path)
                 validator.validate_files([path])
               else
                 sources_dir = path || options[:sources]
                 validator.validate_all(sources_dir)
               end

      puts report.to_s(verbose: options[:verbose])

      exit(report.valid? ? 0 : 1)
    rescue ArgumentError => e
      puts "Error: #{e.message}"
      exit(2)
    rescue SchemaNotFoundError => e
      puts "Schema error: #{e.message}"
      exit(2)
    end

    desc 'list', 'List all YAML files in sources directory'
    option :sources, type: :string, default: 'sources', aliases: '-s',
                     desc: 'Path to sources directory'
    def list
      finder = FileFinder.new(options[:sources])

      unless finder.sources_exist?
        puts "Error: Sources directory not found: #{options[:sources]}"
        exit(2)
      end

      files = finder.find_all
      if files.empty?
        puts "No YAML files found in #{options[:sources]}"
      else
        puts "YAML files in #{options[:sources]}:"
        files.each do |file|
          schema_type = SchemaResolver.resolve(file)
          puts "  #{file} (#{schema_type})"
        end
        puts "\nTotal: #{files.length} files"
      end
    end

    desc 'schema [TYPE]', 'Show schema information'
    def schema(type = nil)
      case type
      when 'announcement', nil
        puts 'Announcement Schema: schemas/cn-announcement.yml'
        puts 'Used for standard sanction announcements with sanction_details'
      when 'modification'
        puts 'Modification Schema: schemas/cn-measure-modification.yml'
        puts 'Used for temporal modifications (suspend/continue/stop) with measure_modifications'
      else
        puts "Unknown schema type: #{type}"
        puts 'Available types: announcement, modification'
        exit(1)
      end
    end

    def self.exit_on_failure?
      true
    end
  end
end

DataCn::Cli.start(ARGV) if __FILE__ == $PROGRAM_NAME
