# frozen_string_literal: true

desc "Validate component coverage: JSON definitions vs implementations vs tests"
task :validate_components do
  require "json"

  # Load all JSON component definitions
  json_components = Dir["data/components/*.json"].map do |path|
    File.basename(path, ".json")
  end.sort

  # Map JSON names to expected FormBuilder method names
  # Some components have Rails-specific naming (e.g., Checkbox -> check_box)
  method_mapping = {
    "Checkbox" => "check_box",
    "TextField" => "text_field",
    "TextArea" => "text_area",
    "NumberField" => "number_field",
    "EmailField" => "email_field",
    "PasswordField" => "password_field",
    "URLField" => "url_field",
    "SearchField" => "search_field",
    "Select" => "select",
    "Switch" => "switch",
    "ChoiceList" => "choice_list",
    "DateField" => "date_field",
    "DatePicker" => "date_picker",
    "ColorField" => "color_field",
    "ColorPicker" => "color_picker",
    "MoneyField" => "money_field",
    "DropZone" => "drop_zone"
  }

  # Read FormBuilder to find implemented methods
  form_builder_source = File.read("lib/polaris_form_builder/form_builder.rb")
  implemented_methods = form_builder_source.scan(/^\s*def (\w+)\(/).flatten

  # Find unit test files
  unit_tests = Dir["test/test_*.rb"].map do |path|
    File.basename(path, ".rb").delete_prefix("test_")
  end

  # Find integration test files
  integration_tests = Dir["test/dummy/test/integration/components/*_test.rb"].map do |path|
    File.basename(path, "_test.rb")
  end

  puts "\n=== Component Coverage Report ===\n\n"
  puts format("%-20s %-15s %-15s %-15s", "Component", "Implemented", "Unit Test", "Integration")
  puts "-" * 70

  missing_impl = []
  missing_unit = []
  missing_integration = []

  json_components.each do |component|
    method_name = method_mapping[component] || component.gsub(/([a-z])([A-Z])/, '\1_\2').downcase
    has_impl = implemented_methods.include?(method_name)
    has_unit = unit_tests.include?(method_name) || unit_tests.include?(component.downcase)
    has_integration = integration_tests.include?(method_name) || integration_tests.include?(component.downcase)

    impl_status = has_impl ? "✓" : "✗"
    unit_status = has_unit ? "✓" : "✗"
    integration_status = has_integration ? "✓" : "✗"

    puts format("%-20s %-15s %-15s %-15s", component, impl_status, unit_status, integration_status)

    missing_impl << component unless has_impl
    missing_unit << component unless has_unit
    missing_integration << component unless has_integration
  end

  puts "\n=== Summary ===\n"
  puts "Total components: #{json_components.size}"
  puts "Implemented: #{json_components.size - missing_impl.size}/#{json_components.size}"
  puts "Unit tests: #{json_components.size - missing_unit.size}/#{json_components.size}"
  puts "Integration tests: #{json_components.size - missing_integration.size}/#{json_components.size}"

  if missing_impl.any?
    puts "\nMissing implementations: #{missing_impl.join(", ")}"
  end

  if missing_unit.any?
    puts "Missing unit tests: #{missing_unit.join(", ")}"
  end

  if missing_integration.any?
    puts "Missing integration tests: #{missing_integration.join(", ")}"
  end

  puts
end
