import 'package:fpvalidate/src/validation_result.dart';

import 'validation_builder.dart';

/// Common string validation functions that can be used with the [custom] method.
///
/// These functions provide reusable validation logic that can be applied
/// to any string field using the fluent API.
///
/// Example:
/// ```dart
/// final result = someString
///     .field('Some String')
///     .custom(StringValidators.contains('required'))
///     .validate();
/// ```
class StringValidators {
  /// Validates that a string contains a specific substring.
  ///
  /// [substring] is the substring that must be present in the value.
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<String> contains(String substring) => (value) {
    if (!value.contains(substring)) {
      return ValidationFailure('must contain "$substring"');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a string starts with a specific prefix.
  ///
  /// [prefix] is the prefix that the value must start with.
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<String> startsWith(String prefix) => (value) {
    if (!value.startsWith(prefix)) {
      return ValidationFailure('must start with "$prefix"');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a string ends with a specific suffix.
  ///
  /// [suffix] is the suffix that the value must end with.
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<String> endsWith(String suffix) => (value) {
    if (!value.endsWith(suffix)) {
      return ValidationFailure('must end with "$suffix"');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a string contains only alphanumeric characters.
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<String> alphanumeric() => (value) {
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return ValidationFailure('must contain only alphanumeric characters');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a string contains only letters.
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<String> lettersOnly() => (value) {
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return ValidationFailure('must contain only letters');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a string contains only digits.
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<String> digitsOnly() => (value) {
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return ValidationFailure('must contain only digits');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a string is a valid UUID.
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<String> uuid() => (value) {
    if (!RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    ).hasMatch(value)) {
      return ValidationFailure('must be a valid UUID');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a string is a valid credit card number.
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<String> creditCard() => (value) {
    // Remove spaces and dashes
    final cleanValue = value.replaceAll(RegExp(r'[\s-]'), '');
    if (!RegExp(r'^[0-9]{13,19}$').hasMatch(cleanValue)) {
      return ValidationFailure('must be a valid credit card number');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a string is a valid postal code.
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<String> postalCode() => (value) {
    if (!RegExp(r'^[0-9]{5}(-[0-9]{4})?$').hasMatch(value)) {
      return ValidationFailure('must be a valid postal code');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a string is a valid date in ISO format (YYYY-MM-DD).
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<String> isoDate() => (value) {
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
      return ValidationFailure('must be a valid date in YYYY-MM-DD format');
    }
    try {
      DateTime.parse(value);

      return ValidationSuccess(value);
    } catch (e) {
      return ValidationFailure('must be a valid date');
    }
  };

  /// Validates that a string is a valid time in 24-hour format (HH:MM).
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<String> time24Hour() => (value) {
    if (!RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$').hasMatch(value)) {
      return ValidationFailure('must be a valid time in HH:MM format');
    }

    return ValidationSuccess(value);
  };
}
