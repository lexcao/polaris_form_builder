# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PolarisFormBuilder is a Ruby gem that provides a Rails Engine integrating a custom form builder with Shopify Polaris Web Components. It seamlessly replaces Rails form inputs with modern, accessible Polaris Web Components without changing your Rails code style.

Official Polaris Web Components documentation: https://shopify.dev/docs/api/app-home/polaris-web-components

The gem wraps Rails form helpers to automatically generate Polaris component markup (e.g., `<s-input>`, `<s-textarea>`, `<s-checkbox>`, etc.) and integrates Rails validations with Polaris error UI.

## Architecture

### Rails Engine Integration (lib/polaris_form_builder/engine.rb:4-13)

The gem is implemented as a Rails Engine that:
- Isolates the namespace to avoid conflicts
- Auto-injects view helpers into ActionView on load via initializer
- Makes `polaris_form_with` helper available in all Rails views

### Custom Form Builder Pattern (lib/polaris_form_builder/form_builder.rb:4-27)

The FormBuilder extends `ActionView::Helpers::FormBuilder` and overrides methods like `text_field` to:
- Extract ActiveModel object attributes and errors
- Transform Rails form parameters into Polaris component attributes
- Generate custom element tags (e.g., `<s-input>`) using Rails tag helpers
- Handle validation error display by reading from `object.errors`

### View Helper Wrapper (lib/polaris_form_builder/helpers.rb:5-8)

The `polaris_form_with` method wraps Rails' `form_with` helper, automatically setting the `:builder` option to use PolarisFormBuilder instead of the default Rails form builder.

## Usage Patterns

The gem supports two usage patterns:

### Global Configuration (Option A)
Set PolarisFormBuilder as the default form builder for all Rails forms:
```ruby
# config/application.rb or any environment file
config.action_view.default_form_builder = PolarisFormBuilder::FormBuilder
```

After this configuration, all `form_with` calls automatically use Polaris components.

### Selective Usage (Option B - Recommended)
Use `polaris_form_with` helper only where Polaris components are needed:
```erb
<%= polaris_form_with model: @user do |f| %>
  <%= f.text_field :email, placeholder: "Enter email" %>
  <%= f.text_area :bio %>
  <%= f.check_box :agree_terms %>
  <%= f.submit "Create Account" %>
<% end %>
```

This approach allows mixing standard Rails forms with Polaris forms in the same application.

## Development Commands

### Setup
```bash
bin/setup                    # Install dependencies
```

### Testing
```bash
rake test                    # Run all tests (default task)
rake                         # Same as rake test
```

### Interactive Console
```bash
bin/console                  # Launch IRB with gem loaded
```

### Gem Management
```bash
bundle exec rake install     # Install gem locally for testing
bundle exec rake release     # Build and release gem (requires version bump first)
```

To release a new version:
1. Update version in `lib/polaris_form_builder/version.rb`
2. Run `bundle exec rake release`

## Key Implementation Notes

### Adding New Form Field Types

When adding form field methods (e.g., `textarea`, `select`):
1. Define method in FormBuilder class (lib/polaris_form_builder/form_builder.rb)
2. Extract value from object using `object.public_send(method)`
3. Build field name as `"#{@object_name}[#{method}]"`
4. Pull errors from `object.errors[method]`
5. Use `@template.tag.public_send` to generate the corresponding Polaris component tag
6. Remember to `.compact` the attributes hash to remove nil values

### Testing with Rails

Since this is a Rails Engine, testing form rendering requires a Rails environment. The current test suite uses Minitest but may need Rails test helpers for integration testing form builders.

## Dependencies

- Ruby >= 3.1.0
- Rails (for ActionView::Helpers::FormBuilder and Engine support)
- Minitest for testing

## Installation in Rails Projects

Add the gem to a Rails project:
```bash
bundle add polaris_form_builder
bundle install
```

## Repository

GitHub: https://github.com/lexcao/polaris_form_builder

## License

Released under the MIT License.

## Installation in Rails Projects

Add the gem to a Rails project:
```bash
bundle add polaris_form_builder
bundle install
```

## Repository

GitHub: https://github.com/lexcao/polaris_form_builder

## License

Released under the MIT License.
