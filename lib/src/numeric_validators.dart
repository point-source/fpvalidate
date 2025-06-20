import 'dart:math';
import 'package:fpvalidate/src/validation_result.dart';

import 'validation_builder.dart';

/// Common numeric validation functions that can be used with the [custom] method.
///
/// These functions provide reusable validation logic that can be applied
/// to any numeric field using the fluent API.
///
/// Example:
/// ```dart
/// final result = someNumber
///     .field('Some Number')
///     .custom(NumericValidators.isInteger())
///     .validate();
/// ```
class NumericValidators {
  /// Validates that a value is an integer.
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<num> isInteger() => (value) {
    if (value != value.toInt()) {
      return ValidationFailure('must be an integer');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a value is even.
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<num> isEven() => (value) {
    if (value % 2 != 0) {
      return ValidationFailure('must be even');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a value is odd.
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<num> isOdd() => (value) {
    if (value % 2 == 0) {
      return ValidationFailure('must be odd');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a value is a perfect square.
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<num> isPerfectSquare() => (value) {
    if (value < 0) {
      return ValidationFailure('must be non-negative to be a perfect square');
    }
    final sqrtValue = sqrt(value);
    if (sqrtValue != sqrtValue.toInt()) {
      return ValidationFailure('must be a perfect square');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a value is a prime number.
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<num> isPrime() => (value) {
    if (value < 2) {
      return ValidationFailure('must be at least 2 to be prime');
    }
    if (value != value.toInt()) {
      return ValidationFailure('must be an integer to be prime');
    }

    final intValue = value.toInt();
    for (int i = 2; i <= sqrt(intValue); i++) {
      if (intValue % i == 0) {
        return ValidationFailure('must be prime');
      }
    }

    return ValidationSuccess(value);
  };

  /// Validates that a value is a power of 2.
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<num> isPowerOfTwo() => (value) {
    if (value <= 0) {
      return ValidationFailure('must be positive to be a power of 2');
    }
    if (value != value.toInt()) {
      return ValidationFailure('must be an integer to be a power of 2');
    }

    final intValue = value.toInt();
    if ((intValue & (intValue - 1)) != 0) {
      return ValidationFailure('must be a power of 2');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a value is within a percentage range of another value.
  ///
  /// [target] is the target value to compare against.
  /// [percentage] is the maximum allowed percentage difference (0-100).
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<num> withinPercentage(num target, num percentage) =>
      (value) {
        if (target == 0) {
          return ValidationFailure('target value cannot be zero');
        }

        final difference = ((value - target).abs() / target.abs()) * 100;
        if (difference > percentage) {
          return ValidationFailure('must be within $percentage% of $target');
        }

        return ValidationSuccess(value);
      };

  /// Validates that a value is a valid port number (1-65535).
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<num> isPortNumber() => (value) {
    if (value != value.toInt()) {
      return ValidationFailure('must be an integer');
    }
    if (value < 1 || value > 65535) {
      return ValidationFailure('must be between 1 and 65535');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a value is a valid year (1900-2100).
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<num> isYear() => (value) {
    if (value != value.toInt()) {
      return ValidationFailure('must be an integer');
    }
    if (value < 1900 || value > 2100) {
      return ValidationFailure('must be between 1900 and 2100');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a value is a valid month (1-12).
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<num> isMonth() => (value) {
    if (value != value.toInt()) {
      return ValidationFailure('must be an integer');
    }
    if (value < 1 || value > 12) {
      return ValidationFailure('must be between 1 and 12');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a value is a valid day of month (1-31).
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<num> isDayOfMonth() => (value) {
    if (value != value.toInt()) {
      return ValidationFailure('must be an integer');
    }
    if (value < 1 || value > 31) {
      return ValidationFailure('must be between 1 and 31');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a value is a valid hour (0-23).
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<num> isHour() => (value) {
    if (value != value.toInt()) {
      return ValidationFailure('must be an integer');
    }
    if (value < 0 || value > 23) {
      return ValidationFailure('must be between 0 and 23');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a value is a valid minute (0-59).
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<num> isMinute() => (value) {
    if (value != value.toInt()) {
      return ValidationFailure('must be an integer');
    }
    if (value < 0 || value > 59) {
      return ValidationFailure('must be between 0 and 59');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a value is a valid second (0-59).
  ///
  /// Returns a validator function that can be used with the [custom] method.
  static Validator<num> isSecond() => (value) {
    if (value != value.toInt()) {
      return ValidationFailure('must be an integer');
    }
    if (value < 0 || value > 59) {
      return ValidationFailure('must be between 0 and 59');
    }

    return ValidationSuccess(value);
  };
}
