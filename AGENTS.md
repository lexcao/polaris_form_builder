# Repository Guidelines

## Test
- Please use the following command to run the test with the target Ruby version
```
# Test for sinle file
mise exec ruby@3.4.5 -- bundle exec ruby -I test {test.rb}

# Test all
mise exec ruby@3.4.5 -- rake test
```

## Task flow
- Always use create new branches for tasks.

## Project Structure & Module Organization
- `lib/` holds the gem’s runtime code: `form_builder.rb` for the custom `PolarisFormBuilder::FormBuilder`, `helpers.rb` for view helpers (`polaris_form_with`), `railtie.rb` for ActionView auto-injection, and `version.rb` for releases. `polaris_form_builder.rb` wires everything.
- `bin/` includes local tooling (`bin/setup` for dependencies, `bin/console` for REPL).
- `test/` uses Minitest; top-level files cover form helpers, and `test/dev/parser_test.rb` exercises parser logic. `test/dummy/` is a Rails app used for integration-style checks.
- Root files: `polaris_form_builder.gemspec`, `Rakefile`, `Gemfile`, and `README.md` for setup and release steps.

## Build, Test, and Development Commands
- `bin/setup`: install Ruby and gem dependencies.
- `bundle exec rake test` (or `rake test`): run the full Minitest suite.
- `bin/console`: open an IRB session with the gem loaded for quick experiments.
- `bundle exec rake install`: build and install the gem locally into your environment.
- Maintainers: `bundle exec rake release` tags, builds, and pushes to RubyGems after bumping `lib/polaris_form_builder/version.rb`.

## Coding Style & Naming Conventions
- Ruby 2-space indentation with `# frozen_string_literal: true` headers on new files.
- Prefer snake_case for methods and variables; class/module names follow CamelCase.
- Keep form-builder APIs aligned with Rails `FormBuilder`; accept keyword args and let Rails helpers handle HTML safety. Use `@template.tag`/`content_tag` to emit Polaris elements.
- When rendering Polaris components in tests, mirror existing ERB snippets and favor clear option hashes over positional args.
- Please read the separate file STYLE.md for some guidance on coding style.

## Testing Guidelines
- Framework: Minitest (`test/*_test.rb`). Name files `*_test.rb` and derive from `TestCase` in `test/test_helper.rb` to inherit Rails/Polaris setup and helpers like `form_body`.
- Use `bundle exec rake test` before opening a PR. Add focused unit cases for new fields/helpers and, when touching parsing behavior, extend `test/dev/parser_test.rb`.
- For integration behaviors that depend on routing or layouts, add fixtures under `test/dummy/`.
## Commit & Pull Request Guidelines
- Follow the existing Conventional Commit style (`feat(scope): ...`, `fix: ...`, `build: ...`).
- Commits should stay scoped and include test updates when behavior changes.
- PRs: include a short summary of the change, steps to reproduce/verify, and note any UI/markup impact (a rendered form snippet is helpful). Link related issues when available and confirm `bundle exec rake test` passes.

## Security & Configuration Tips
- Ruby >= 3.1 per gemspec; keep new code compatible with supported Rails versions used by ActionView.
- Avoid introducing runtime dependencies that assume a specific Rails version beyond what the gemspec declares.
- When adding helpers that emit HTML, rely on Rails escaping and prefer option hashes over string interpolation to reduce XSS risk.
- Adding new form fields: fetch object values with `object.public_send`, build names as `"#{@object_name}[#{method}]"`, collect errors from `object.errors[method]`, build an attributes hash and call `@template.tag`/`content_tag`, then `.compact` to drop nils.
