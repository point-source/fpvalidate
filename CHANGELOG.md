## 0.6.0

- **BREAKING**: Renamed package from `fpvalidate` to `trust_but_verify`
- **BREAKING**: Renamed `field()` to `trust()` - starts a validation chain
- **BREAKING**: Renamed `validate()` to `verify()` - executes validation and returns result
- **BREAKING**: Renamed `validateEither()` to `verifyEither()` - executes validation returning Either
- **BREAKING**: Renamed `validateTaskEither()` to `verifyTaskEither()` - returns TaskEither
- **BREAKING**: Renamed `validateAsync()` to `verifyAsync()` - async batch validation
- **BREAKING**: Now using [email_validator](https://pub.dev/packages/email_validator) for email validation
- **NEW**: Field names are now optional - use `trust()` without arguments for generic messages
- **NEW**: Custom error messages via lambda in `verify()` - e.g., `verify((fieldName) => 'Custom $fieldName error')`
- **NEW**: All error classes now have `copyWith({String? message})` for error message customization
- **NEW**: Improved default messages with cleaner format (e.g., "Email cannot be empty" instead of "Field Email is empty")

## 0.5.0

- **BREAKING**: Updated SDK constraint to ^3.10.0
- **NEW**: Added `CastingExtension` with `isType<T>()` for type-safe validation chains
- **NEW**: Added `typeMismatch` error message to internationalization system
- **NEW**: Added `TypeMismatchValidationError` for cleaner type error handling
- **FIX**: Added missing field extension for Either type from fpdart

## 0.4.0

- **BREAKING**: Renamed `check` to `ensure` for clarity
- **BREAKING**: Renamed `then` to `bind` for consistency with fpdart
- **NEW**: Added `isNotEmpty()` extension method for nullable strings as shortcut for `isNotNull().isNotEmpty()`

## 0.3.0

- **NEW**: Added comprehensive internationalization support for validation messages
  - Type-safe `ValidationMessages` interface for custom message implementations
  - `ValidationMessagesMixin` for partial message overrides while keeping default English fallbacks
  - `EnglishValidationMessages` as the default English implementation
  - Global configuration via `ValidationStep.configureMessages()` and `ValidationStep.resetMessages()`
  - Support for all validation scenarios with proper parameter substitution
  - No breaking changes to existing API - all existing code continues to work unchanged
  - Added comprehensive example demonstrating partial overrides and complete custom implementations

## 0.2.0

- **BREAKING**: Refactored error system with hierarchical error types for better error handling and debugging
  - Introduced specific error classes for different validation scenarios
  - `StringValidationError` for string-specific validation failures
  - `NumericValidationError` for numeric validation failures
  - `NullableValidationError` for nullable field validation failures
  - Core validation errors: `FieldInitializationError`, `AsyncFieldInitializationError`, `TryMapValidationError`, `CheckValidationError`, `BindValidationError`
- Improved type safety in error handling throughout the validation pipeline
- Better stack trace support for debugging validation failures

## 0.1.1

- Added field extensions for Either and TaskEither types from fpdart
- You can now start validation chains directly from Right, Left, and TaskEither values
- Permit `FutureOr` in async `ensure` and `tryMap` methods
- Added `isOneOf()` method for string and numeric validation
- Added `isNoneOf()` method for string and numeric validation
- Renamed `notEmpty()` to `isNotEmpty()` for consistency

## 0.1.0

- Initial version with comprehensive validation library
- Support for functional programming with fpdart Either and TaskEither
- Fluent API for chaining validation rules
- Built-in validators for strings, numbers, and nullable types
- String validators: email, URL, phone, UUID, credit card, postal code, ISO date, 24-hour time
- Numeric validators: min/max, range, even/odd, positive/negative, power of 2, perfect square, port number
- Batch validation for multiple fields
- Async validation support
- Custom validation with ensure() and tryMap()
- Error handling with descriptive messages
- Nullable field support
