# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project follows Semantic Versioning.

## [Unreleased]

- No changes yet.

## [0.1.1] - 2026-03-07

### Fixed

- Render `choice_list` as Polaris `s-choice-list` with nested `s-choice` items instead of falling back to `select`.
- Preserve block content for form builder helpers rendered through nested inline templates.

## [0.1.0] - 2026-03-06

### Added

- Initial release of `polaris_form_builder`.
- `PolarisFormBuilder::FormBuilder` with Polaris component mappings for common Rails form helpers.
- `polaris_form_with` helper provided by Rails Engine integration.
- Validation error forwarding from Rails model errors to Polaris component `error` attributes.
- Unit, integration, and playground test suites.
