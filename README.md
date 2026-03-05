# PolarisFormBuilder

Use Shopify Polaris Web Components as a Rails form builder, while keeping Rails form semantics.

- Polaris Web Components docs: https://shopify.dev/docs/api/app-home/polaris-web-components

## What This Gem Does

- Provides `PolarisFormBuilder::FormBuilder` as a drop-in Rails form builder.
- Provides `polaris_form_with` for explicit per-form opt-in.
- Integrates via Rails Engine so helpers are available in ActionView.
- Maps model validation errors to Polaris component `error` attributes.
- Preserves Rails helper behavior (`name`, `value`, `checked`, etc.) by building on top of `super`.

## Requirements

- Ruby `>= 3.1.0`
- Rails app using `form_with` / `ActionView::Helpers::FormBuilder`

## Installation

```bash
bundle add polaris_form_builder
bundle install
```

## Usage

### Recommended: Opt in per form

```erb
<%= polaris_form_with model: @user do |f| %>
  <%= f.text_field :email, placeholder: "Enter email" %>
  <%= f.password_field :password %>
  <%= f.text_area :bio %>
  <%= f.check_box :agree_terms %>
  <%= f.submit "Create Account" %>
<% end %>
```

### Global default builder

```ruby
# config/application.rb (or environment files)
config.action_view.default_form_builder = PolarisFormBuilder::FormBuilder
```

Then regular `form_with` will use Polaris components automatically.

```erb
<%= form_with model: @user do |f| %>
  <%= f.text_field :email %>
  <%= f.password_field :password %>
  <%= f.submit %>
<% end %>
```

## Supported Helpers

### Core Rails-style fields

- `text_field`
- `number_field`
- `email_field`
- `password_field`
- `url_field`
- `search_field`
- `color_field`
- `date_field`
- `file_field` (`drop_zone` alias)
- `text_area`
- `check_box`
- `select`
- `submit`

### Polaris-oriented helpers

- `drop_zone`
- `money_field`
- `color_picker`
- `date_picker`
- `switch`
- `choice_list`

## Validation Error Mapping

When your model has errors, corresponding Polaris components receive `error` automatically.

```ruby
class User < ApplicationRecord
  validates :email, presence: true
end
```

```erb
<%= polaris_form_with model: @user do |f| %>
  <%= f.text_field :email %>
<% end %>
```

If `@user.errors[:email]` is present, the rendered Polaris field gets an `error` attribute.

## Development

```bash
bin/setup
bin/rubocop
rake test
bin/ci
```

Useful commands:

```bash
rake test_unit
rake test_integration
rake test_playground
bin/console
```

## Release

1. Update `lib/polaris_form_builder/version.rb`.
2. Update `CHANGELOG.md`.
3. Run `bin/ci`.
4. Publish:

```bash
bundle exec rake release
```

## Contributing

Issues and pull requests are welcome:

This project follows the Contributor Covenant Code of Conduct.

## License

Released under MIT. See `LICENSE.txt`.
