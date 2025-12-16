# Repository Guidelines

## Project Structure & Module Organization

- `lib/polaris_form_builder/`: gem implementation (`form_builder.rb`, `polaris_tag.rb`, helpers, versioning).
- `data/components/`: source-of-truth component definitions and examples (`*.json`) used by tests and the playground.
- `test/`: Minitest unit tests (`test/test_*.rb`) and fixtures (`test/fixtures/`).
- `test/dummy/`: Rails app used for integration tests (request/response + rendering).
- `app/playground/`: Rails app for interactive preview and system-style regression tests.
- `bin/`: developer scripts (`setup`, `ci`, `rubocop`) and one-off tools under `bin/dev/`.

## Build, Test, and Development Commands

```bash
bin/setup                 # Install gems for root, playground, and dummy apps
bin/rubocop               # Run RuboCop (Rails Omakase)
rake test                 # Default: unit + dummy integration + playground tests
rake test_unit            # Unit tests only (test/test_*.rb, test/dev/*_test.rb)
rake test_integration     # Rails tests in test/dummy
rake test_playground      # Rails tests in app/playground
bin/ci                    # CI entrypoint: setup + lint + full test suite
bundle exec rake install  # Install the gem locally
```

To run the playground locally:

```bash
cd app/playground && bin/rails server
```

## Coding Style & Naming Conventions

- Ruby version is pinned in `.ruby-version` (and in CI).
- Formatting/linting is enforced via RuboCop (`.rubocop.yml`); keep changes clean by running `bin/rubocop`.
- Prefer the existing pattern of `super` (Rails semantics) + `PolarisTag` (tag/attribute shaping) when adding new builder methods.
- Use Ruby conventions: `snake_case` files/methods, `CamelCase` constants, 2-space indentation.

## Testing Guidelines

- Use Minitest throughout.
- Unit tests live in `test/test_*.rb`.
- Integration tests for components live in `test/dummy/test/integration/components/*_test.rb`.
- Keep tests example-driven when possible (matching `data/components/*.json`), and add focused behavior assertions for Rails semantics (name/value/error/checked).

## Commit & Pull Request Guidelines

- Commits follow a Conventional Commits-like style: `type(scope): summary` (e.g., `feat(text_field): support slot`).
- PRs should include: a clear description, linked issue (if any), new/updated tests, and screenshots/GIFs when markup or playground behavior changes.
- Expect CI to run `bin/ci`; run it locally before requesting review.

## Source-of-Truth Notes

- Treat `data/components/*.json` as read-only input; do not edit it to “make tests pass”.
- For adding a new component, follow `NEW_COMPONENT.md` and `TEST.md`.
