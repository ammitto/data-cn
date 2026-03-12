# TODO: Create Complete Harmonized Data Model

## Context

The Ammitto project needs a comprehensive harmonized data model that serves as a **SUPERSET** of all sanctions data structures across different sources (China, EU, UN, US, UK, etc.). The current ammitto gem is missing several critical models that are needed to properly represent the complexity of international sanctions data.

### Missing Models Identified

1. **SanctionList** - Only exists as source-specific model, needs harmonized version
2. **SanctionGroup** - Not found; needed to group entries from same announcement
3. **LocalizedString** - Not found; needed for proper multilingual support
4. **SanctionPeriodModification** - Not found; StatusHistory is insufficient
5. **LegalCitation** - Not found; needed to properly cite specific articles

---

## Progress Tracker

### Phase 1: Foundation Models
- [x] 1.1 Create LocalizedString model (`lib/ammitto/ontology/value_objects/localized_string.rb`)
- [x] 1.2 Create LegalCitation model (`lib/ammitto/ontology/value_objects/legal_citation.rb`)

### Phase 2: Core Sanctions Models
- [x] 2.1 Create SanctionList model (`lib/ammitto/ontology/sanction/sanction_list.rb`)
- [x] 2.2 Create SanctionGroup model (`lib/ammitto/ontology/sanction/sanction_group.rb`)
- [x] 2.3 Create SanctionPeriodModification model (`lib/ammitto/ontology/sanction/sanction_period_modification.rb`)

### Phase 3: Update Existing Models
- [x] 3.1 Update SanctionEntry (add group_id, modifications, legal_citations)
- [x] 3.2 Update OfficialAnnouncement (add sanction_group_ids, modifications, legal_citations)
- [x] 3.3 NameVariant already has language/script support - no change needed

### Phase 4: Integration
- [x] 4.1 Update value_objects.rb to require new files
- [x] 4.2 Update sanction.rb to require new files
- [x] 4.3 Run rubocop and fix any issues
- [x] 4.4 Run tests and verify all pass
- [x] 4.5 Simplified code using `key_value do` instead of separate json/yaml mappings

### Phase 5: Documentation
- [x] 5.1 Update data-cn README.adoc with Harmonized Data Model section

### Phase 6: Test Coverage
- [x] 6.1 Create RSpec tests for LocalizedString
- [x] 6.2 Create RSpec tests for LegalCitation
- [x] 6.3 Create RSpec tests for SanctionList
- [x] 6.4 Create RSpec tests for SanctionGroup
- [x] 6.5 Create RSpec tests for SanctionPeriodModification

### Phase 7: Validation
- [x] 7.1 Run data-cn validation: `bundle exec ruby scripts/validate_cn_data.rb validate`
- [x] 7.2 Run ammitto gem rubocop - passes with no offenses
- [x] 7.3 Run ammitto gem tests - 456 examples, 0 failures

### Phase 8: Future Work (IN PROGRESS)
- [x] 8.1 Update JSON-LD context for new models (schema/context.rb updated)
- [x] 8.2 Update China transformer to create SanctionGroup from multi-entity announcements
- [x] 8.3 Update China transformer to create SanctionPeriodModification from measure_modifications
- [x] 8.4 Update China transformer to create LegalCitation from instruments field
- [x] 8.5 Regenerate all data from sources
  - Fixed harmonize command to use safe_load with permitted_classes
  - Fixed harmonize command to search in sources/sanction-lists/ directories
  - Fixed CnMeasure to map zh-Hans to zh_hans
  - Successfully harmonized 323 entities from CN data
- [x] 8.6 Update ammitto harmonized database (@../data)
  - Generated all.jsonld (1.3MB)
  - Generated all.ttl (1.1MB)
  - Generated search-index.json (105KB)
  - Generated stats.json
- [x] 8.7 Update ammitto.github.io website
  - Copied cn.jsonld to ammitto.github.io/api/v1/sources/
  - Updated stats.json (CN: 168 -> 323 entities, Total: 83918 -> 84073)
  - Regenerated search-index.json
  - Regenerated node files

### Implementation Notes

**New Files Created:**
- `lib/ammitto/sources/cn/cn_announcement.rb` - Source model for data-cn YAML format
- `lib/ammitto/sources/cn/cn_measure_modification.rb` - Source model for modification YAML format

**New Transformer Methods:**
- `transform_cn_announcement` - Transforms CnAnnouncement to harmonized models
- `transform_cn_entity` - Transforms single CnEntity
- `transform_cn_modification` - Transforms CnMeasureModification
- `create_sanction_group` - Creates SanctionGroup for multi-entity announcements
- `create_sanction_period_modification` - Creates modifications from YAML
- `create_legal_citations` - Creates LegalCitation from instruments

**Remaining Work:**
The harmonize command in the ammitto gem needs to be properly configured to:
1. Read from data-cn sources directory
2. Output to data-cn api directory
3. Handle the new YAML format properly

---

## Completion Summary

**All core phases (1-7) are COMPLETE.**

### Verification Results
- **Ammitto gem tests:** 456 examples, 0 failures
- **Rubocop:** 7 files inspected, no offenses detected
- **data-cn validation:** 47 files, all valid

### What Was Implemented
1. **5 new models** with full serialization support
2. **2 existing models** enhanced with new relationships
3. **5 RSpec test files** with comprehensive coverage
4. **Documentation** added to README.adoc

### Remaining Work (Optional)
Phase 8 contains optional future work for:
- JSON-LD context integration
- China transformer updates to utilize the new models

These are documented but not required for the core harmonized data model to function.

---

## Files Status

### Ammitto Gem - New Files Created

| File | Description | Status |
|------|-------------|--------|
| `lib/ammitto/ontology/value_objects/localized_string.rb` | LocalizedString model | ✅ DONE |
| `lib/ammitto/ontology/value_objects/legal_citation.rb` | LegalCitation model | ✅ DONE |
| `lib/ammitto/ontology/sanction/sanction_list.rb` | SanctionList model | ✅ DONE |
| `lib/ammitto/ontology/sanction/sanction_group.rb` | SanctionGroup model | ✅ DONE |
| `lib/ammitto/ontology/sanction/sanction_period_modification.rb` | SanctionPeriodModification model | ✅ DONE |

### Ammitto Gem - Modified Files

| File | Changes | Status |
|------|---------|--------|
| `lib/ammitto/ontology/sanction/sanction_entry.rb` | Add group_id, modifications, legal_citations | ✅ DONE |
| `lib/ammitto/official_announcement.rb` | Add sanction_group_ids, modifications, legal_citations | ✅ DONE |
| `lib/ammitto/ontology/value_objects.rb` | Require LocalizedString and LegalCitation | ✅ DONE |
| `lib/ammitto/ontology/sanction.rb` | Require SanctionList, SanctionGroup, SanctionPeriodModification | ✅ DONE |

### Ammitto Gem - Test Files Created

| File | Description | Status |
|------|-------------|--------|
| `spec/ammitto/ontology/value_objects/localized_string_spec.rb` | LocalizedString tests | ✅ DONE |
| `spec/ammitto/ontology/value_objects/legal_citation_spec.rb` | LegalCitation tests | ✅ DONE |
| `spec/ammitto/ontology/sanction/sanction_list_spec.rb` | SanctionList tests | ✅ DONE |
| `spec/ammitto/ontology/sanction/sanction_group_spec.rb` | SanctionGroup tests | ✅ DONE |
| `spec/ammitto/ontology/sanction/sanction_period_modification_spec.rb` | SanctionPeriodModification tests | ✅ DONE |

### data-cn Repository

| File | Changes | Status |
|------|---------|--------|
| `README.adoc` | Add comprehensive "Harmonized Ontology Models" section | ✅ DONE |

---

## Completion Summary (Phase 1-7)

Completed successfully:

1. **Created 5 new models:**
   - `LocalizedString` - Multilingual text support
   - `LegalCitation` - Legal instrument citations with articles
   - `SanctionList` - Sanctions regime/list management
   - `SanctionGroup` - Collective sanction grouping
   - `SanctionPeriodModification` - Temporal modifications (suspend/resume/stop)

2. **Updated 2 existing models:**
   - `SanctionEntry` - Added group_id, modifications, legal_citations
   - `OfficialAnnouncement` - Added sanction_group_ids, modifications, legal_citations

3. **Updated index files:**
   - `value_objects.rb` - Added LocalizedString and LegalCitation
   - `sanction.rb` - Added SanctionList, SanctionGroup, SanctionPeriodModification

4. **Simplified code:**
   - Used `key_value do` instead of separate json/yaml mappings
   - Removed redundant `to_hash` methods (provided by key_value)

5. **Documentation:**
   - Added comprehensive "Harmonized Ontology Models" section to README.adoc

6. **Test Coverage:**
   - Created RSpec test files for all 5 new models
   - All tests pass (456 examples, 0 failures)

7. **Validation:**
   - data-cn validation passes (47 valid files)
   - Rubocop passes with no offenses

---

## Remaining Work Summary

### Phase 6: Test Coverage
Need to create RSpec test files for each new model to ensure:
- Attribute definitions are correct
- Serialization/deserialization works
- Helper methods work as expected
- Edge cases are handled

### Phase 7: Transformer Integration
The China transformer (`lib/ammitto/sources/cn/transformer.rb`) needs updates to:
- Create `SanctionGroup` when processing multi-entity announcements
- Create `SanctionPeriodModification` from `measure_modifications` YAML files
- Create `LegalCitation` from `instruments` field in source data

### Phase 8: Validation
Final verification that everything works together.

---

## Model Specifications

### 1. LocalizedString

**Purpose:** Text in a specific language with optional script and region

**Location:** `ammitto/lib/ammitto/ontology/value_objects/localized_string.rb`

```ruby
class LocalizedString < Lutaml::Model::Serializable
  attribute :value, :string                 # The text content
  attribute :language, :string              # ISO 639-1 (zh, en, ru, ar)
  attribute :script, :string                # ISO 15924 (Latn, Hani, Cyrl, Arab, Hant)
  attribute :region, :string                # ISO 3166-1 (CN, TW, HK)
  attribute :is_primary, :boolean, default: false
  attribute :is_transliteration, :boolean, default: false
  attribute :transliteration_system, :string  # pinyin, wade-giles, etc.

  key_value do
    map :value, to: :value
    map :lang, to: :language
    map :script, to: :script
    map :region, to: :region
    map :is_primary, to: :is_primary
    map :is_transliteration, to: :is_transliteration
    map :transliteration_system, to: :transliteration_system
  end
end
```

**IRI Pattern:** N/A (embedded value object)

---

### 2. LegalCitation

**Purpose:** Reference from an announcement to a legal instrument with specific articles

**Location:** `ammitto/lib/ammitto/ontology/value_objects/legal_citation.rb`

```ruby
class LegalCitation < Lutaml::Model::Serializable
  attribute :id, :string
  attribute :legal_instrument_id, :string  # Reference to LegalInstrument
  attribute :articles, :string, collection: true  # ["第四条", "第五条"]
  attribute :sections, :string, collection: true
  attribute :paragraphs, :string, collection: true
  attribute :citation_type, :string        # legal_basis, reference, amendment
  attribute :context, :string              # Why this instrument is cited
  attribute :quoted_text, LocalizedString, collection: true

  key_value do
    map :id, to: :id
    map :legal_instrument_id, to: :legal_instrument_id
    map :articles, to: :articles
    map :sections, to: :sections
    map :paragraphs, to: :paragraphs
    map :citation_type, to: :citation_type
    map :context, to: :context
    map :quoted_text, to: :quoted_text
  end
end
```

**Citation Types:**
| Type | Description |
|------|-------------|
| `legal_basis` | Primary legal authority for sanctions |
| `reference` | Supporting reference |
| `amendment` | Cited for amendment purposes |
| `interpretation` | Cited for interpretation guidance |

**IRI Pattern:** `https://www.ammitto.org/citation/{source}/{id}`

---

### 3. SanctionList

**Purpose:** A sanctions regime/list maintained by an authority

**Location:** `ammitto/lib/ammitto/ontology/sanction/sanction_list.rb`

```ruby
class SanctionList < Lutaml::Model::Serializable
  attribute :id, :string                    # Unique IRI
  attribute :source, :string                # Source code (cn, eu, un, us)
  attribute :code, :string                  # List code (e.g., "UEL" for Unreliable Entity List)
  attribute :name, LocalizedString, collection: true
  attribute :description, LocalizedString, collection: true
  attribute :authority, Authority
  attribute :regime, SanctionRegime
  attribute :legal_citations, LegalCitation, collection: true
  attribute :list_type, :string             # primary, secondary, consolidated
  attribute :status, :string, default: 'active'  # active, inactive, archived
  attribute :established_date, :date
  attribute :url, :string
  attribute :metadata, :hash

  key_value do
    # ... mappings ...
  end
end
```

**IRI Pattern:** `https://www.ammitto.org/list/{source}/{code}`

---

### 4. SanctionGroup

**Purpose:** Collection of sanction entries announced together in a single announcement

**Location:** `ammitto/lib/ammitto/ontology/sanction/sanction_group.rb`

```ruby
class SanctionGroup < Lutaml::Model::Serializable
  attribute :id, :string                    # Unique IRI
  attribute :announcement_id, :string       # Reference to OfficialAnnouncement
  attribute :list_id, :string               # Reference to SanctionList
  attribute :entry_ids, :string, collection: true  # IDs of entries in this group
  attribute :shared_measures, SanctionEffect, collection: true
  attribute :shared_reasons, SanctionReason, collection: true
  attribute :effective_date, :date
  attribute :effective_time, :string
  attribute :entity_count, :integer
  attribute :notes, :string

  key_value do
    # ... mappings ...
  end
end
```

**IRI Pattern:** `https://www.ammitto.org/group/{source}/{announcement_id}`

**Rationale:**
- An announcement may sanction multiple entities with identical measures
- Provides context for understanding collective sanctions
- Enables efficient querying of "all entities sanctioned together"
- Reduces data redundancy by sharing measures/reasons

---

### 5. SanctionPeriodModification

**Purpose:** Structured record of temporal changes to sanctions

**Location:** `ammitto/lib/ammitto/ontology/sanction/sanction_period_modification.rb`

```ruby
class SanctionPeriodModification < Lutaml::Model::Serializable
  # What is being modified
  attribute :id, :string
  attribute :target_type, :string           # entry, group, list
  attribute :target_id, :string             # IRI of target
  attribute :target_announcement_id, :string
  attribute :target_announcement_date, :date
  attribute :affected_entity_count, :integer
  attribute :affected_entity_names, :string, collection: true

  # The modification action
  attribute :action, :string                # suspend, resume, stop, amend, extend
  attribute :effective_date, :date
  attribute :effective_time, :string
  attribute :until_date, :date              # For suspend/resume
  attribute :until_time, :string
  attribute :duration_days, :integer
  attribute :duration_description, :string  # "90天", "1年"

  # Context
  attribute :announcement_id, :string       # Announcement that triggered this
  attribute :legal_citations, LegalCitation, collection: true
  attribute :reason, LocalizedString, collection: true
  attribute :notes, :string
  attribute :status, :string, default: 'active'  # active, expired, superseded

  key_value do
    # ... mappings ...
  end
end
```

**Action Types:**
| Action | Description |
|--------|-------------|
| `suspend` | Temporarily pause measures |
| `resume` | Resume suspended measures |
| `stop` | Permanently terminate measures |
| `amend` | Modify specific measures |
| `extend` | Extend suspension period |

**IRI Pattern:** `https://www.ammitto.org/modification/{source}/{id}`

---

## Updated Existing Models

### SanctionEntry (Enhanced)

```ruby
class SanctionEntry
  # ... existing attributes ...

  # NEW: Reference to group (if part of collective sanction)
  attribute :group_id, :string

  # NEW: Modifications affecting this entry
  attribute :modifications, SanctionPeriodModification, collection: true

  # NEW: Legal citations (specific to this entry)
  attribute :legal_citations, LegalCitation, collection: true
end
```

### OfficialAnnouncement (Enhanced)

```ruby
class OfficialAnnouncement
  # ... existing attributes ...

  # NEW: Groups created by this announcement
  attribute :sanction_group_ids, :string, collection: true

  # NEW: Modifications announced by this
  attribute :modifications, SanctionPeriodModification, collection: true

  # NEW: Legal citations
  attribute :legal_citations, LegalCitation, collection: true
end
```

---

## Relationship Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           AMMITTO HARMONIZED ONTOLOGY                        │
└─────────────────────────────────────────────────────────────────────────────┘

                              ┌──────────────────┐
                              │   Authority      │
                              └────────┬─────────┘
                                       │ maintains
                                       ▼
┌──────────────────┐         ┌──────────────────┐         ┌──────────────────┐
│ SanctionRegime   │◄────────│   SanctionList   │────────►│  LegalCitation   │
└──────────────────┘  has    └────────┬─────────┘  has    └────────┬─────────┘
                                       │                          │ cites
                                       │ contains                 │
                                       ▼                          ▼
                              ┌──────────────────┐         ┌──────────────────┐
                              │  SanctionGroup   │         │ LegalInstrument  │
                              └────────┬─────────┘         └──────────────────┘
                                       │ contains
                                       ▼
┌──────────────────┐         ┌──────────────────┐
│     Entity       │◄────────│  SanctionEntry   │
│  (Person/Org/    │  links  ├──────────────────┤
│   Vessel/Aircraft)│  to    │ has measures     │───────► SanctionEffect
└──────────────────┘         │ has reasons      │───────► SanctionReason
                              │ has period       │───────► TemporalPeriod
                              │ has modifications│───────► SanctionPeriodModification
                              │ part of group    │
                              └────────┬─────────┘
                                       │ from
                                       ▼
                              ┌──────────────────┐         ┌──────────────────┐
                              │ OfficialAnnounce │────────►│  LegalCitation   │
                              └──────────────────┘  cites  └──────────────────┘

                    ┌──────────────────────────────────────┐
                    │          Value Objects               │
                    ├──────────────────────────────────────┤
                    │ LocalizedString (NEW)                │
                    │ NameVariant (has language/script)    │
                    │ TemporalPeriod                       │
                    │ Address                              │
                    │ Identification                       │
                    │ BirthInfo                            │
                    │ ContactInfo                          │
                    │ EntityLink                           │
                    │ SourceReference                      │
                    │ Tonnage                              │
                    └──────────────────────────────────────┘
```

---

## China Data Mapping

| Source YAML Field | Harmonized Object | Harmonized Field |
|-------------------|-------------------|------------------|
| `sanction_list` | SanctionEntry.list_id | `list_type` |
| `effective_date` | SanctionEntry.period | `effective_date` |
| `effective_time` | SanctionEntry.period | `effective_time` |
| `name.zh-Hans` | Entity.names[] | `{value, lang: "zh", script: "Hani"}` |
| `name.en` | Entity.names[] | `{value, lang: "en", script: "Latn"}` |
| `type` | Entity | `entity_type` |
| `measures[].type[]` | SanctionEffect | `effect_type` (array) |
| `measures[].zh-Hans` | SanctionEffect | `description` |
| `reason[].zh-Hans` | SanctionReason | `description` |
| `title.zh-Hans` | PersonEntity | `title` |
| `gender` | PersonEntity | `gender` |
| `announcement.title` | OfficialAnnouncement | `title` |
| `announcement.url` | OfficialAnnouncement | `url` |
| `announcement.publish_date` | OfficialAnnouncement | `published_date` |
| `announcement.publish_time` | OfficialAnnouncement | `published_time` |
| `announcement.authority` | OfficialAnnouncement | `authority` |
| `announcement.document_id` | OfficialAnnouncement | `document_id` |
| `instruments[].law` | LegalCitation | `legal_instrument_id` |
| `instruments[].articles` | LegalCitation | `articles[]` |
| `modifications[].action` | SanctionPeriodModification | `action` |
| `modifications[].effective_date` | SanctionPeriodModification | `effective_date` |
| `modifications[].until_date` | SanctionPeriodModification | `until_date` |

---

## Verification Commands

```bash
# Run ammitto gem tests
cd /Users/mulgogi/src/ammitto/ammitto
bundle exec rspec

# Run ammitto rubocop
bundle exec rubocop

# Run data-cn validation
cd /Users/mulgogi/src/ammitto/data-cn
bundle exec ruby scripts/validate_cn_data.rb validate
```

---

## Notes

- All new models inherit from `Lutaml::Model::Serializable`
- Use `key_value do` for serialization mappings (replaces separate json/yaml blocks)
- Use `:string` type for IRI references to other entities
- All dates use `:date` type, times use `:string`
- Collections use `collection: true` attribute option
