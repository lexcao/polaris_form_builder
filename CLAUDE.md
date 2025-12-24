# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

**For complete repository guidelines, architecture details, development commands, and coding standards, please refer to [AGENTS.md](./AGENTS.md).**

AGENTS.md contains comprehensive documentation including:
- Project overview and structure
- Development and testing commands
- Architecture and core components
- Adding new form field types
- Coding style and conventions
- Testing guidelines
- Commit and PR guidelines
- Key constraints and best practices

## Coding Guidelines (from Review)

### Code Placement
- Logic should be placed at the actual execution point (bottom layer), not at the entry point
- Example: `field_error_proc` handling belongs in `FormBuilder.text_field/check_box`, not in `polaris_form_with`
- This ensures all call patterns work correctly

### Avoid Redundancy
- If the bottom layer handles something, the entry point should not duplicate it

### Temporary Tests
- Tests created for verification purposes should be removed after verification is complete

### File Organization
- Development tools (rake tasks, scripts) go in `bin/`, not `lib/`
- `lib/` is packaged into the gem, should only contain library code
