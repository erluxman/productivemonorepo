# Platform Guide: Flutter

This guide describes how Flutter work is organized and how rules apply.

## Root (canonical)

- **Use this root everywhere**: `apps/mobile/flutter/`
- Implementation detail in this repo: `apps/mobile/flutter/` → `flutter_app/` (symlink managed by `scripts/platform_paths.json`)

## Code layout (recommended)

This layout is aligned with `project_constitution.md` and designed to trigger the right scoped rules:

Recommended “from day 1” layout:

```text
apps/mobile/flutter/
  lib/
    core/
      domain/
      application/
    infrastructure/
    presentation/
      screens/
      widgets/
      state/
      navigation/
```

## Cursor rule mapping

- Always-on:
  - `.cursor/rules/core/*`
- Scoped Flutter rules (by concern):
  - `.cursor/rules/mobile/flutter/state_bloc.mdc`
  - `.cursor/rules/mobile/flutter/state_riverpod.mdc`
  - `.cursor/rules/mobile/flutter/ui_widgets.mdc`
  - `.cursor/rules/mobile/flutter/navigation.mdc`
  - `.cursor/rules/mobile/flutter/networking.mdc`
  - `.cursor/rules/mobile/flutter/auth.mdc`
  - `.cursor/rules/mobile/flutter/animations.mdc`
  - `.cursor/rules/mobile/flutter/performance.mdc`
  - `.cursor/rules/mobile/flutter/error_handling.mdc`
  - `.cursor/rules/mobile/flutter/accessibility.mdc`
  - `.cursor/rules/mobile/flutter/testing.mdc`

## Rule intent

- BLoC/Riverpod rules only load when editing state files.
- Auth/animation rules only load when editing auth/animation code.
- Performance rules apply to presentation layer (widgets, screens).
- Error handling rules apply to all layers.
- Accessibility rules only load when editing presentation layer.
- Testing rules apply to test files.

## Path→Rule alignment (why this layout matters)

Because the layout is layer-first, Cursor can scope rules tightly:

- `lib/presentation/state/**` triggers state rules (BLoC/Riverpod)
- `lib/presentation/widgets/**` triggers UI widget rules
- `lib/infrastructure/**` triggers networking/infrastructure rules
