# Flutter Development Guide

**Project**: Productive Flutter App

Quick reference for AI-assisted Flutter development with Cursor.

---

## 📋 Quick Start

### Core Rules (Always Active)

- `.cursor/rules/core/*.mdc` - Core constraints, workflow, security (3 files)
- `.cursor/rules/flutter/*.mdc` - Flutter-specific rules (6 files)

### Key Files

- `ai-dev/DEVELOPMENT_GUIDE.md` - **This file**
- `ai-dev/layout_conventions.md` - Project structure
- `ai-dev/platform_guides/flutter.md` - Flutter conventions
- `ai-dev/checklists/CHECKLIST.md` - Review checklist
- `ai-dev/checklists/release/flutter.md` - Release checklist

---

## 🏗️ Project Structure

```text
lib/
  core/          # Services, providers, shared infrastructure
  features/      # Feature-based UI organization
  models/        # Data models
  utils/         # Utilities and extensions
```

See `ai-dev/layout_conventions.md` for detailed structure.

---

## 🔧 Common Tasks

### New Feature

```text
@ai-dev/prompts/feature_spec.md
```

1. Define spec
2. Plan implementation
3. Write tests
4. Implement
5. Review with `@ai-dev/checklists/CHECKLIST.md`

### Bug Fix

```text
@ai-dev/prompts/tdd_bugfix.md
```

1. Write failing test
2. Fix bug
3. Verify test passes
4. Add regression tests

### Code Review

```text
@ai-dev/prompts/review.md
@ai-dev/checklists/CHECKLIST.md
```

### Release

```text
@ai-dev/checklists/release/flutter.md
```

---

## 🎯 Flutter Rules by Concern

| Concern | Rule File |
| **Common Patterns** | `.cursor/rules/flutter/common_patterns.mdc` |
| **Error Handling** | `.cursor/rules/flutter/error_handling.mdc` |
| **Testing** | `.cursor/rules/flutter/testing.mdc` |
| **Performance** | `.cursor/rules/flutter/performance.mdc` |
| **Accessibility** | `.cursor/rules/flutter/accessibility.mdc` |

Rules auto-load for all files in `lib/**`. See `.cursor/rules/flutter/00_scope.mdc`.

**Note**: The `common_patterns.mdc` covers state management, UI/widgets, navigation, networking, auth, and animations.

---

## 🔐 Hard Constraints

From `.cursor/rules/core/*.mdc`:

1. **No hardcoded secrets** - Use environment/config
2. **No business logic in UI** - Keep in services/core
3. **Handle all errors** - No silent failures
4. **Plan before code** - List files and risks
5. **Tests required** - For non-trivial logic and bugs
6. **Atomic changes** - 1-3 files per step

---

## 🛠️ Tech Stack

- **Framework**: Flutter
- **State**: Riverpod / BLoC (ChangeNotifier)
- **Backend**: Firebase (Auth, Firestore)
- **Error Handling**: Try-catch patterns
- **Testing**: flutter_test

---

## 💡 Cursor Shortcuts

- `Cmd+K` / `Ctrl+K` - Inline edit
- `Cmd+L` / `Ctrl+L` - Open chat
- `Cmd+I` / `Ctrl+I` - Composer
- `Alt+Enter` - Quick questions

---

## 📚 Reference Files

### Prompts (ai-dev/prompts/)

- `feature_spec.md` - Feature specification template
- `tdd_bugfix.md` - TDD bugfix workflow
- `review.md` - Code review template

### Checklists (ai-dev/checklists/)

- `CHECKLIST.md` - Combined code review, security, testing checklist
- `release/flutter.md` - Flutter release checklist

### Platform Guide

- `platform_guides/flutter.md` - Detailed Flutter conventions

### Code Layout

- `layout_conventions.md` - Project structure guide

---

**Keep it simple. Focus on Flutter. Follow the rules.**
