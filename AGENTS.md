# Repository Guidelines

This file provides comprehensive guidance for AI agents (Claude Code, Cursor, Copilot, etc.) when working with code in this repository.

## Project Overview

PolarisFormBuilder is a Ruby gem that provides a Rails Engine integrating a custom form builder with Shopify Polaris Web Components. It seamlessly replaces Rails form inputs with modern, accessible Polaris Web Components without changing your Rails code style.

Official Polaris Web Components documentation: https://shopify.dev/docs/api/app-home/polaris-web-components

The gem wraps Rails form helpers to automatically generate Polaris component markup (e.g., `<s-input>`, `<s-textarea>`, `<s-checkbox>`, etc.) and integrates Rails validations with Polaris error UI.

## Project Structure & Module Organization

- `lib/polaris_form_builder/`: Gem implementation (form_builder.rb, polaris_tag.rb, helpers, railtie, version)
- `data/components/`: Source-of-truth component definitions and examples (`*.json`) used by tests and the playground
- `test/`: Minitest unit tests (`test/test_*.rb`) and fixtures (`test/fixtures/`)
- `test/dummy/`: Rails app used for integration tests (request/response + rendering)
- `app/playground/`: Rails app for interactive preview and system-style regression tests
- `bin/`: Developer scripts (`setup`, `ci`, `rubocop`) and one-off tools under `bin/dev/`

## Build, Test, and Development Commands

### Setup and Testing
```bash
bin/setup                    # Install gems for root, playground, and dummy apps
bin/ci                       # Run full CI suite: setup + lint + all tests
bin/rubocop                  # Run RuboCop (Rails Omakase)

rake test                    # Run all tests (unit + integration + playground)
rake test_unit               # Unit tests only (test/test_*.rb, test/dev/*_test.rb)
rake test_integration        # Rails integration tests in test/dummy
rake test_playground         # Rails tests in app/playground

# Run single test file
mise exec ruby@3.4.5 -- bundle exec ruby -I test test/test_text_field.rb

# Run specific integration test
mise exec ruby@3.4.5 -- rake test TEST=test/dummy/test/integration/components/text_field_test.rb
```

### Development Tools
```bash
bin/console                  # Launch IRB with gem loaded
bin/command                  # Developer CLI for code generation
```

### Playground (Interactive Preview)
```bash
cd app/playground && bin/rails server
```

### Gem Management
```bash
bundle exec rake install     # Install gem locally for testing
bundle exec rake release     # Build and release gem (requires version bump first)
```

To release a new version:
1. Update version in `lib/polaris_form_builder/version.rb`
2. Run `bundle exec rake release`

## Architecture

### Core Components

#### 1. Rails Engine Integration (lib/polaris_form_builder/railtie.rb)
The gem is implemented as a Rails Engine that:
- Isolates the namespace to avoid conflicts
- Auto-injects view helpers into ActionView on load via initializer
- Makes `polaris_form_with` helper available in all Rails views

#### 2. Custom Form Builder Pattern (lib/polaris_form_builder/form_builder.rb)
The FormBuilder extends `ActionView::Helpers::FormBuilder` and overrides methods like `text_field` to:
- Call Rails `super` to generate standard HTML (preserving `name/value/checked/disabled/...` semantics)
- Use `Tag` to transform tags (e.g., `<input>` → `<s-text-field>`)
- Extract ActiveModel object attributes and errors
- Handle validation error display by reading from `object.errors`
- Support blocks as slot content

**Key implementation pattern:**
```ruby
# TODO
```

#### 3. Tag Transformer (lib/polaris_form_builder/polaris_tag.rb)
A fluent API for HTML tag transformation that:
- Renames tags (e.g., `input` → `s-text-field`)
- Removes unwanted attributes (e.g., `type`)
- Inserts slot content from blocks
- Ensures proper closing tags for custom elements

#### 4. View Helper Wrapper (lib/polaris_form_builder/helpers.rb)
The `polaris_form_with` method wraps Rails' `form_with` helper, automatically setting the `:builder` option to use PolarisFormBuilder.

### Testing Infrastructure

#### Three-layer Test Strategy

1. **Unit Tests** (`test/test_*.rb`):
   - Example-driven: Use `ComponentExampleTest` to validate against `data/components/*.json` examples
   - Behavior-driven: Test Rails semantics (name/value/error/checked attributes)
   - Run with: `mise exec ruby@3.4.5 -- bundle exec ruby -I test test/test_<component>.rb`

2. **Integration Tests** (`test/dummy/test/integration/components/*_test.rb`):
   - Full Rails request/response cycle in dummy app
   - Three-path coverage per component:
     - GET: Render main example successfully
     - POST invalid: Show validation errors (422 response)
     - POST valid: Redirect and display submitted values (303 response)
   - Uses `PreviewForm` (ActiveModel) for validation
   - Run with: `mise exec ruby@3.4.5 -- rake test TEST=test/dummy/test/integration/components/<component>_test.rb`

3. **Playground Tests** (`app/playground/test/`):
   - System-level regression tests
   - Interactive preview for manual testing
   - Run with: `BUNDLE_GEMFILE=app/playground/Gemfile RAILS_ENV=test bundle exec rails test`

### Source of Truth: `data/components/*.json`

- Treat as **read-only input** — never modify to make tests pass
- Contains canonical component definitions from Shopify Polaris documentation
- Each JSON includes:
  - `properties`: Component attributes
  - `examples`: Code samples with `html_code` and `erb_code`
- Component key naming: `s-<kebab-case>` tag → `<snake_case>` key (e.g., `s-text-field` → `text_field`)
- JSON file naming: CamelCase (e.g., `TextField.json`, `Checkbox.json`)

## Adding New Form Field Types

Follow the component pipeline documented in `NEW_COMPONENT.md`:

### Quick Reference

1. **Naming alignment**: Determine component key (from tag), JSON filename (CamelCase), and Ruby helper name (Rails convention)

2. **Implementation** in `lib/polaris_form_builder/form_builder.rb`:
   - Prefer `super` + `Tag` pattern (don't hand-roll Rails semantics)
   - Allow multi-tag output when Rails generates semantic helpers (e.g., hidden input for checkboxes)
   - Don't modify caller's `options` hash — use `.dup` first
   - Follow method signature of Rails FormBuilder for compatibility

3. **Unit tests** in `test/test_<component>.rb`:
   - Example-driven tests from JSON
   - Behavior assertions for Rails semantics
   - Skip inconsistent examples with clear comments

4. **Integration tests** in `test/dummy/test/integration/components/<component>_test.rb`:
   - Update `ComponentsController#component_fields` with field mappings
   - Add fields + validations to `PreviewForm`
   - Create three-path test (GET, POST invalid, POST valid)

5. **Playground wiring**:
   - Add field to `app/playground/app/controllers/components_controller.rb` permit list
   - Add attribute to `app/playground/app/models/preview.rb`
   - Optionally add round-trip test in `app/playground/test/components_preview_test.rb`

6. **Verification**:
   - Run unit tests
   - Run integration tests
   - Run `bin/ci` locally before submitting PR

## Coding Style & Naming Conventions

Follow the style guide in `STYLE.md`:

- Ruby version is pinned in `.ruby-version` (and in CI)
- Formatting/linting is enforced via RuboCop (`.rubocop.yml`); keep changes clean by running `bin/rubocop`
- Use Ruby conventions: `snake_case` files/methods, `CamelCase` constants, 2-space indentation
- **Conditional returns**: Prefer expanded conditionals over guard clauses (except at method start for non-trivial bodies)
- **Method ordering**: `class` methods → `public` methods (with `initialize` at top) → `private` methods
- **Invocation order**: Methods arranged vertically by call order
- **Visibility modifiers**: No newline under modifier, indent content under them
- **CRUD controllers**: Model as REST resources, introduce new resources instead of custom actions
- **Vanilla Rails**: Thin controllers directly invoking rich domain model, avoid service layer abstraction
- **Jobs**: Use `_later` suffix for async methods, `_now` for synchronous versions

## Testing Guidelines

- Use Minitest throughout
- Unit tests live in `test/test_*.rb`
- Integration tests for components live in `test/dummy/test/integration/components/*_test.rb`
- Keep tests example-driven when possible (matching `data/components/*.json`), and add focused behavior assertions for Rails semantics (name/value/error/checked)

## Key Constraints

1. **Source of Truth**: `data/components/*.json` is read-only. If examples are inconsistent:
   - **Skip**: Mark test as skipped with clear reason
   - **Snapshot**: Maintain fixture in `test/fixtures/components/` (requires test infrastructure update)

2. **Rails Compatibility**: When implementing Rails FormBuilder methods, maintain signature and semantics compatibility

3. **Test Hygiene**: Don't add `require` statements in implementation for test dependencies — use `test/test_helper.rb`

4. **Options Discipline**: Never modify caller's `options` hash in-place — always `.dup` first

## Commit & Pull Request Guidelines

- Commits follow Conventional Commits style: `type(scope): summary`
  - Examples: `feat(text_field): support slot`, `fix(checkbox): handle unchecked value`
- PRs should include:
  - Clear description with linked issue (if any)
  - New/updated tests (unit + integration)
  - Screenshots/GIFs for markup or playground behavior changes
- Run `bin/ci` locally before requesting review
- Expect CI to run full suite (`bin/setup` + `bin/rubocop` + `rake test`)

## Dependencies

- Ruby >= 3.1.0 (pinned in `.ruby-version`)
- Rails (for ActionView::Helpers::FormBuilder and Engine support)
- Minitest for testing
- RuboCop (Rails Omakase configuration)

## Repository

GitHub: https://github.com/lexcao/polaris_form_builder

## License

Released under the MIT License.
