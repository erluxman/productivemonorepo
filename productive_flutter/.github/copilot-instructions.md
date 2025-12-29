# Copilot Instructions

## Core Rules (Always Active)

- `.cursor/rules/core/*.mdc` - Core constraints, workflow, security
- `.cursor/rules/flutter/*.mdc` - Flutter-specific rules

## Development Guide

- `ai-dev/DEVELOPMENT_GUIDE.md` - Start here for all development tasks

## Hard Constraints

- No hardcoded secrets, tokens, or API keys
- No business logic in UI/widgets
- Handle all errors explicitly (no silent failures)
- Tests required for non-trivial logic and bug fixes
- Plan before code - list files and risks
- Keep changes atomic (1-3 files per step)

## Before Marking Work Complete

- Check `ai-dev/checklists/CHECKLIST.md`
- Verify all tests pass
- No linter errors

**If unsure, ask for clarification. Do not guess requirements.**
