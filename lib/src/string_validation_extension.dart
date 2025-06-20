import 'validation_builder.dart';
import 'validation_result.dart';

/// Extension that provides string-specific validation methods for [ValidationBuilder<String>].
///
/// This extension adds convenient string validation methods that can be chained
/// directly on a [ValidationBuilder<String>] without needing to use the [custom] method.
///
/// Example:
/// ```dart
/// final result = someString
///     .field('Some String')
///     .notEmpty()
///     .minLength(5)
///     .contains('required')
///     .startsWith('http')
///     .validate();
/// ```
extension StringValidationExtension on ValidationBuilder<String> {
  /// Validates that the field is not empty.
  ///
  /// Checks if the string is not empty and not just whitespace.
  ///
  /// [trim] is a boolean flag that determines if the string should be trimmed
  /// of whitespace before checking if it's empty.
  /// Defaults to true.
  ValidationBuilder<String> notEmpty({bool trim = true}) {
    return custom((value) {
      return (trim ? value.trim().isEmpty : value.isEmpty)
          ? ValidationFailure('$fieldName not provided')
          : ValidationSuccess(value);
    });
  }

  /// Validates that the field has a minimum length.
  ///
  /// Checks if the string length is at least [minLength].
  ValidationBuilder<String> minLength(int minLength) {
    return custom((value) {
      return value.length < minLength
          ? ValidationFailure(
              '$fieldName must be at least $minLength characters',
            )
          : ValidationSuccess(value);
    });
  }

  /// Validates that the field has a maximum length.
  ///
  /// Checks if the string length is no more than [maxLength].
  ValidationBuilder<String> maxLength(int maxLength) {
    return custom((value) {
      return value.length > maxLength
          ? ValidationFailure(
              '$fieldName must be no more than $maxLength characters',
            )
          : ValidationSuccess(value);
    });
  }

  /// Validates that the field matches a regular expression pattern.
  ///
  /// Checks if the string matches the given [pattern].
  /// [description] is used in the error message to describe what the pattern represents.
  ValidationBuilder<String> pattern(RegExp pattern, String description) {
    return custom((value) {
      return !pattern.hasMatch(value)
          ? ValidationFailure('$fieldName must match pattern: $description')
          : ValidationSuccess(value);
    });
  }

  /// Validates that the field is a valid email address.
  ///
  /// Uses a basic email regex pattern to validate email format.
  ValidationBuilder<String> email() {
    return pattern(RegExp(r'^[^@]+@[^@]+\.[^@]+$'), 'valid email format');
  }

  /// Validates that the field is a valid URL.
  ///
  /// Uses a basic URL regex pattern to validate URL format.
  ValidationBuilder<String> url() {
    return pattern(RegExp(r'^https?://.*'), 'valid URL format');
  }

  /// Validates that the field is a valid phone number.
  ///
  /// Uses a basic phone regex pattern that accepts various formats.
  ValidationBuilder<String> phone() {
    return pattern(
      RegExp(r'^[\+]?[1-9][\d]{0,15}$'),
      'valid phone number format',
    );
  }

  /// Validates that the string contains a specific substring.
  ///
  /// [substring] is the substring that must be present in the value.
  ValidationBuilder<String> contains(String substring) {
    return custom((value) {
      if (!value.contains(substring)) {
        return ValidationFailure('$fieldName must contain "$substring"');
      }

      return ValidationSuccess(value);
    });
  }

  /// Validates that the string starts with a specific prefix.
  ///
  /// [prefix] is the prefix that the value must start with.
  ValidationBuilder<String> startsWith(String prefix) {
    return custom((value) {
      if (!value.startsWith(prefix)) {
        return ValidationFailure('$fieldName must start with "$prefix"');
      }

      return ValidationSuccess(value);
    });
  }

  /// Validates that the string ends with a specific suffix.
  ///
  /// [suffix] is the suffix that the value must end with.
  ValidationBuilder<String> endsWith(String suffix) {
    return custom((value) {
      if (!value.endsWith(suffix)) {
        return ValidationFailure('$fieldName must end with "$suffix"');
      }

      return ValidationSuccess(value);
    });
  }

  /// Validates that the string contains only alphanumeric characters.
  ValidationBuilder<String> alphanumeric() {
    return custom((value) {
      if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
        return ValidationFailure(
          '$fieldName must contain only alphanumeric characters',
        );
      }

      return ValidationSuccess(value);
    });
  }

  /// Validates that the string contains only letters.
  ValidationBuilder<String> lettersOnly() {
    return custom((value) {
      if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
        return ValidationFailure('$fieldName must contain only letters');
      }

      return ValidationSuccess(value);
    });
  }

  /// Validates that the string contains only digits.
  ValidationBuilder<String> digitsOnly() {
    return custom((value) {
      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return ValidationFailure('$fieldName must contain only digits');
      }

      return ValidationSuccess(value);
    });
  }

  /// Validates that the string is a valid UUID.
  ValidationBuilder<String> uuid() {
    return custom((value) {
      if (!RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
        caseSensitive: false,
      ).hasMatch(value)) {
        return ValidationFailure('$fieldName must be a valid UUID');
      }

      return ValidationSuccess(value);
    });
  }

  /// Validates that the string is a valid credit card number.
  ValidationBuilder<String> creditCard() {
    return custom((value) {
      // Remove spaces and dashes
      final cleanValue = value.replaceAll(RegExp(r'[\s-]'), '');
      if (!RegExp(r'^[0-9]{13,19}$').hasMatch(cleanValue)) {
        return ValidationFailure(
          '$fieldName must be a valid credit card number',
        );
      }

      return ValidationSuccess(value);
    });
  }

  /// Validates that the string is a valid postal code.
  ValidationBuilder<String> postalCode() {
    return custom((value) {
      if (!RegExp(r'^[0-9]{5}(-[0-9]{4})?$').hasMatch(value)) {
        return ValidationFailure('$fieldName must be a valid postal code');
      }

      return ValidationSuccess(value);
    });
  }

  /// Validates that the string is a valid date in ISO format (YYYY-MM-DD).
  ValidationBuilder<String> isoDate() {
    return custom((value) {
      final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value);
      if (match == null) {
        return ValidationFailure(
          '$fieldName must be a valid date in YYYY-MM-DD format',
        );
      }
      try {
        final year = int.parse(match.group(1)!);
        final month = int.parse(match.group(2)!);
        final day = int.parse(match.group(3)!);
        final parsed = DateTime.parse(value);
        if (parsed.year != year || parsed.month != month || parsed.day != day) {
          return ValidationFailure('$fieldName must be a valid date');
        }

        return ValidationSuccess(value);
      } catch (e) {
        return ValidationFailure('$fieldName must be a valid date');
      }
    });
  }

  /// Validates that the string is a valid time in 24-hour format (HH:MM).
  ValidationBuilder<String> time24Hour() {
    return custom((value) {
      if (!RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$').hasMatch(value)) {
        return ValidationFailure(
          '$fieldName must be a valid time in HH:MM format',
        );
      }

      return ValidationSuccess(value);
    });
  }
}
