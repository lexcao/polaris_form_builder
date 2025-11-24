# PolarisFormBuilder

**Use Shopify Polaris Web Components as the default Rails FormBuilder.**
Seamlessly replace Rails form inputs with modern, accessible Polaris Web Components — without changing your Rails code style.
- https://shopify.dev/docs/api/app-home/polaris-web-components

This gem provides:

* A drop-in `PolarisFormBuilder`
* A `polaris_form_with` helper
* Automatic ActionView helper injection via Rails Engine
* Rails validations + Polaris error UI integration

---

## 🚀 Installation

Add the gem to your Rails project:

```bash
bundle add polaris_form_builder
bundle install
```

---

## 🧩 Usage

### Option A — Use globally (replace all Rails form builders)

```ruby
# config/application.rb or any environment file
config.action_view.default_form_builder = PolarisFormBuilder::FormBuilder
```

Then any Rails form automatically uses Polaris:

```erb
<%= form_with model: @user do |f| %>
  <%= f.text_field :email %>
  <%= f.password_field :password %>
  <%= f.submit %>
<% end %>
```

---

### Option B — Use only where needed (recommended)

```erb
<%= polaris_form_with model: @user do |f| %>
  <%= f.text_field :email, placeholder: "Enter email" %>
  <%= f.text_area :bio %>
  <%= f.check_box :agree_terms %>
  <%= f.submit "Create Account" %>
<% end %>
```

---

## 🧪 Development

Clone the repo:

```bash
bin/setup
```

Run tests:

```bash
rake test
```

Interactive console:

```bash
bin/console
```

Install locally:

```bash
bundle exec rake install
```

Release:

1. Update version in `lib/polaris_form_builder/version.rb`
2. Run:

```bash
bundle exec rake release
```

---

## 🤝 Contributing

Bug reports and pull requests are welcome at:

```
https://github.com/lexcao/polaris_form_builder
```

This project follows the Contributor Covenant Code of Conduct.

---

## 📄 License

Released under the MIT License.
See [LICENSE](https://opensource.org/licenses/MIT) for details.
