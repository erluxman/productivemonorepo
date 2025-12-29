# Development Checklist

Use before marking work as complete.

---

## ✅ Code Quality

### Architecture

- ✓ No business logic in UI/presentation
- ✓ Services in `lib/core/`, UI in `lib/features/`
- ✓ Clear separation of concerns

### Correctness

- ✓ Error handling for all external calls (API, Firestore, etc.)
- ✓ Edge cases handled (null, empty, timeout, offline)
- ✓ No silent failures

### Naming & Style

- ✓ Clear, descriptive names
- ✓ Consistent with Flutter/Dart conventions
- ✓ Minimal comments (code is self-documenting)

---

## 🔐 Security

### Secrets & Credentials

- ✓ No hardcoded API keys, tokens, or passwords
- ✓ Sensitive config in environment/Firebase config
- ✓ No secrets in logs or error messages

### Authentication

- ✓ Auth verified at boundaries
- ✓ Proper permission checks
- ✓ No weakening of auth without approval

### Input Validation

- ✓ All user input validated/sanitized
- ✓ Firestore queries use proper security rules

### Logging

- ✓ No PII (emails, names) in logs
- ✓ No tokens or passwords in logs

---

## 🧪 Testing

### Test Coverage

- ✓ Tests for non-trivial logic
- ✓ Bug fixes include repro test (fails before, passes after)
- ✓ Widget tests for complex UI flows

### Test Quality

- ✓ Tests verify behavior, not implementation
- ✓ Happy path + edge cases + error cases covered
- ✓ No flaky tests (deterministic)

### Test Types

- ✓ Unit tests: Core services and logic
- ✓ Widget tests: UI components with state
- ✓ Integration tests: Firebase interactions (if applicable)

---

## 🚀 Before Commit

- ✓ Code follows Flutter/Dart best practices
- ✓ No linter errors (`flutter analyze`)
- ✓ All tests pass (`flutter test`)
- ✓ No console warnings or errors
- ✓ Atomic changes (1-3 files preferred)

---

## 📦 Before Release

See `ai-dev/checklists/release/flutter.md` for complete release checklist.

---

**If you must violate a constraint, document why and get explicit approval.**
