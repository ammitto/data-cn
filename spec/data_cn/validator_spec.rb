# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/data_cn'

RSpec.describe DataCn::Validator do
  let(:validator) { described_class.new }

  describe '#validate_file' do
    context 'with a valid announcement file' do
      it 'returns a valid result' do
        result = validator.validate_file('sources/sanction-lists/anti-sanction-list/20221223.yml')

        expect(result).to be_valid
        expect(result.schema_type).to eq(:announcement)
        expect(result.errors).to be_empty
      end
    end

    context 'with a non-existent file' do
      it 'returns a parse error' do
        result = validator.validate_file('nonexistent.yml')

        expect(result).not_to be_valid
        expect(result).to have_parse_error
      end
    end
  end

  describe '#validate_all' do
    it 'validates all files in sources directory' do
      report = validator.validate_all('sources')

      expect(report.total_count).to be > 0
      expect(report).to be_valid
    end
  end

  describe '#validate_files' do
    it 'validates multiple files' do
      files = %w[
        sources/sanction-lists/anti-sanction-list/20221223.yml
        sources/sanction-lists/anti-sanction-list/20230407.yml
      ]
      report = validator.validate_files(files)

      expect(report.total_count).to eq(2)
      expect(report).to be_valid
    end
  end
end

RSpec.describe DataCn::SchemaResolver do
  describe '.resolve' do
    context 'with standard announcement directories' do
      it 'returns :announcement' do
        expect(described_class.resolve('sources/sanction-lists/anti-sanction-list/test.yml'))
          .to eq(:announcement)
        expect(described_class.resolve('sources/sanction-lists/import-export-control-list/test.yml'))
          .to eq(:announcement)
        expect(described_class.resolve('sources/sanction-lists/unrealiable-entity-list/test.yml'))
          .to eq(:announcement)
      end
    end

    context 'with modification directories' do
      it 'returns :modification' do
        expect(described_class.resolve('sources/sanction-lists/unreliable-entity-list-updates/test.yml'))
          .to eq(:modification)
      end
    end

    context 'with content detection' do
      it 'returns :modification for content with measure_modifications' do
        content = { 'measure_modifications' => {} }
        expect(described_class.resolve('any/path.yml', content))
          .to eq(:modification)
      end

      it 'returns :announcement for content with sanction_details' do
        content = { 'sanction_details' => {} }
        expect(described_class.resolve('any/path.yml', content))
          .to eq(:announcement)
      end
    end
  end
end

RSpec.describe DataCn::FileFinder do
  describe '#find_all' do
    it 'finds all YAML files' do
      finder = described_class.new('sources')
      files = finder.find_all

      expect(files).to be_an(Array)
      expect(files.length).to be > 0
      expect(files.first).to include('sources/')
    end
  end

  describe '#sources_exist?' do
    it 'returns true for existing sources directory' do
      finder = described_class.new('sources')
      expect(finder.sources_exist?).to be true
    end

    it 'returns false for non-existing directory' do
      finder = described_class.new('nonexistent')
      expect(finder.sources_exist?).to be false
    end
  end
end

RSpec.describe DataCn::ValidationResult do
  describe '#valid?' do
    it 'returns true when no errors' do
      result = described_class.new(
        file_path: 'test.yml',
        schema_type: :announcement,
        errors: []
      )
      expect(result).to be_valid
    end

    it 'returns false when errors present' do
      result = described_class.new(
        file_path: 'test.yml',
        schema_type: :announcement,
        errors: ['Some error']
      )
      expect(result).not_to be_valid
    end

    it 'returns false when parse error' do
      result = described_class.new(
        file_path: 'test.yml',
        schema_type: :announcement,
        parse_error: 'Parse failed'
      )
      expect(result).not_to be_valid
    end
  end

  describe '#has_parse_error?' do
    it 'returns true when parse error present' do
      result = described_class.new(
        file_path: 'test.yml',
        schema_type: :announcement,
        parse_error: 'Parse failed'
      )
      expect(result).to have_parse_error
    end

    it 'returns false when no parse error' do
      result = described_class.new(
        file_path: 'test.yml',
        schema_type: :announcement
      )
      expect(result).not_to have_parse_error
    end
  end
end

RSpec.describe DataCn::ValidationReport do
  describe '#valid?' do
    it 'returns true when all results are valid' do
      valid_result = DataCn::ValidationResult.new(
        file_path: 'test.yml',
        schema_type: :announcement
      )
      report = described_class.new([valid_result, valid_result])
      expect(report).to be_valid
    end

    it 'returns false when any result is invalid' do
      valid_result = DataCn::ValidationResult.new(
        file_path: 'valid.yml',
        schema_type: :announcement
      )
      invalid_result = DataCn::ValidationResult.new(
        file_path: 'invalid.yml',
        schema_type: :announcement,
        errors: ['Error']
      )
      report = described_class.new([valid_result, invalid_result])
      expect(report).not_to be_valid
    end
  end

  describe '#summary' do
    it 'includes validation counts' do
      result = DataCn::ValidationResult.new(
        file_path: 'test.yml',
        schema_type: :announcement
      )
      report = described_class.new([result])
      summary = report.summary

      expect(summary).to include('Total files: 1')
      expect(summary).to include('Valid: 1')
      expect(summary).to include('Invalid: 0')
    end
  end
end
