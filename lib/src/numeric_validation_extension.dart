import 'dart:math';
import 'validation_builder.dart';
import 'validation_result.dart';

/// Extension that provides numeric-specific validation methods for [ValidationBuilder<T>] where T extends num.
///
/// This extension adds convenient numeric validation methods that can be chained
/// directly on a [ValidationBuilder<T>] without needing to use the [custom] method.
///
/// Example:
/// ```dart
/// final result = 42.field('Age').isInteger().isEven().validate();
/// ```
extension NumericValidationExtension<T extends num> on ValidationBuilder<T> {
  /// Validates that the field is greater than a minimum value.
  ValidationBuilder<T> min(T min) {
    return custom((value) {
      return value < min
          ? ValidationFailure('$fieldName must be at least $min')
          : ValidationSuccess(value);
    });
  }

  /// Validates that the field is less than a maximum value.
  ValidationBuilder<T> max(T max) {
    return custom((value) {
      return value > max
          ? ValidationFailure('$fieldName must be no more than $max')
          : ValidationSuccess(value);
    });
  }

  /// Validates that the field is within a range (inclusive).
  ValidationBuilder<T> inRange(T min, T max) {
    return custom((value) {
      return value < min || value > max
          ? ValidationFailure('$fieldName must be between $min and $max')
          : ValidationSuccess(value);
    });
  }

  /// Validates that the field is positive (greater than 0).
  ValidationBuilder<T> positive() {
    return custom((value) {
      return value > 0
          ? ValidationSuccess(value)
          : ValidationFailure('$fieldName must be positive');
    });
  }

  /// Validates that the field is negative (less than 0).
  ValidationBuilder<T> negative() {
    return custom((value) {
      return value < 0
          ? ValidationSuccess(value)
          : ValidationFailure('$fieldName must be negative');
    });
  }

  /// Validates that the field is non-negative (greater than or equal to 0).
  ValidationBuilder<T> nonNegative() {
    return custom((value) {
      return value >= 0
          ? ValidationSuccess(value)
          : ValidationFailure('$fieldName must be non-negative');
    });
  }

  ValidationBuilder<T> isInteger() {
    return custom((value) {
      if (value != value.toInt()) {
        return ValidationFailure('$fieldName must be an integer');
      }

      return ValidationSuccess(value);
    });
  }

  ValidationBuilder<T> isEven() {
    return custom((value) {
      if (value % 2 != 0) {
        return ValidationFailure('$fieldName must be even');
      }

      return ValidationSuccess(value);
    });
  }

  ValidationBuilder<T> isOdd() {
    return custom((value) {
      if (value % 2 == 0) {
        return ValidationFailure('$fieldName must be odd');
      }

      return ValidationSuccess(value);
    });
  }

  ValidationBuilder<T> isPerfectSquare() {
    return custom((value) {
      if (value < 0) {
        return ValidationFailure(
          '$fieldName must be non-negative to be a perfect square',
        );
      }
      final sqrtValue = sqrt(value);
      if (sqrtValue != sqrtValue.toInt()) {
        return ValidationFailure('$fieldName must be a perfect square');
      }

      return ValidationSuccess(value);
    });
  }

  ValidationBuilder<T> isPrime() {
    return custom((value) {
      if (value < 2) {
        return ValidationFailure('$fieldName must be at least 2 to be prime');
      }
      if (value != value.toInt()) {
        return ValidationFailure('$fieldName must be an integer to be prime');
      }
      final intValue = value.toInt();
      for (int i = 2; i <= sqrt(intValue).toInt(); i++) {
        if (intValue % i == 0) {
          return ValidationFailure('$fieldName must be prime');
        }
      }

      return ValidationSuccess(value);
    });
  }

  ValidationBuilder<T> isPowerOfTwo() {
    return custom((value) {
      if (value <= 0) {
        return ValidationFailure(
          '$fieldName must be positive to be a power of 2',
        );
      }
      if (value != value.toInt()) {
        return ValidationFailure(
          '$fieldName must be an integer to be a power of 2',
        );
      }
      final intValue = value.toInt();
      if ((intValue & (intValue - 1)) != 0) {
        return ValidationFailure('$fieldName must be a power of 2');
      }

      return ValidationSuccess(value);
    });
  }

  ValidationBuilder<T> withinPercentage(T target, num percentage) {
    return custom((value) {
      if (target == 0) {
        return ValidationFailure('$fieldName target value cannot be zero');
      }
      final difference = ((value - target).abs() / target.abs()) * 100;
      if (difference > percentage) {
        return ValidationFailure(
          '$fieldName must be within $percentage% of $target',
        );
      }

      return ValidationSuccess(value);
    });
  }

  ValidationBuilder<T> isPortNumber() {
    return custom((value) {
      if (value != value.toInt()) {
        return ValidationFailure('$fieldName must be an integer');
      }
      if (value < 1 || value > 65535) {
        return ValidationFailure('$fieldName must be between 1 and 65535');
      }

      return ValidationSuccess(value);
    });
  }

  ValidationBuilder<T> isYear() {
    return custom((value) {
      if (value != value.toInt()) {
        return ValidationFailure('$fieldName must be an integer');
      }
      if (value < 1900 || value > 2100) {
        return ValidationFailure('$fieldName must be between 1900 and 2100');
      }

      return ValidationSuccess(value);
    });
  }

  ValidationBuilder<T> isMonth() {
    return custom((value) {
      if (value != value.toInt()) {
        return ValidationFailure('$fieldName must be an integer');
      }
      if (value < 1 || value > 12) {
        return ValidationFailure('$fieldName must be between 1 and 12');
      }

      return ValidationSuccess(value);
    });
  }

  ValidationBuilder<T> isDayOfMonth() {
    return custom((value) {
      if (value != value.toInt()) {
        return ValidationFailure('$fieldName must be an integer');
      }
      if (value < 1 || value > 31) {
        return ValidationFailure('$fieldName must be between 1 and 31');
      }

      return ValidationSuccess(value);
    });
  }

  ValidationBuilder<T> isHour() {
    return custom((value) {
      if (value != value.toInt()) {
        return ValidationFailure('$fieldName must be an integer');
      }
      if (value < 0 || value > 23) {
        return ValidationFailure('$fieldName must be between 0 and 23');
      }

      return ValidationSuccess(value);
    });
  }

  ValidationBuilder<T> isMinute() {
    return custom((value) {
      if (value != value.toInt()) {
        return ValidationFailure('$fieldName must be an integer');
      }
      if (value < 0 || value > 59) {
        return ValidationFailure('$fieldName must be between 0 and 59');
      }

      return ValidationSuccess(value);
    });
  }

  ValidationBuilder<T> isSecond() {
    return custom((value) {
      if (value != value.toInt()) {
        return ValidationFailure('$fieldName must be an integer');
      }
      if (value < 0 || value > 59) {
        return ValidationFailure('$fieldName must be between 0 and 59');
      }

      return ValidationSuccess(value);
    });
  }
}

/* extension IntValidationExtension on ValidationBuilder<int> {
  ValidationBuilder<int> min(int min) {
    return custom((value) {
      return value < min
          ? ValidationFailure('$fieldName must be at least $min')
          : ValidationSuccess(value);
    });
  }

  ValidationBuilder<int> max(int max) {
    return custom((value) {
      return value > max
          ? ValidationFailure('$fieldName must be no more than $max')
          : ValidationSuccess(value);
    });
  }

  ValidationBuilder<int> inRange(int min, int max) {
    return custom((value) {
      return value < min || value > max
          ? ValidationFailure('$fieldName must be between $min and $max')
          : ValidationSuccess(value);
    });
  }

  ValidationBuilder<int> positive() {
    return custom((value) {
      return value > 0
          ? ValidationSuccess(value)
          : ValidationFailure('$fieldName must be positive');
    });
  }

  ValidationBuilder<int> negative() {
    return custom((value) {
      return value < 0
          ? ValidationSuccess(value)
          : ValidationFailure('$fieldName must be negative');
    });
  }

  ValidationBuilder<int> nonNegative() {
    return custom((value) {
      return value >= 0
          ? ValidationSuccess(value)
          : ValidationFailure('$fieldName must be non-negative');
    });
  }
}

extension DoubleValidationExtension on ValidationBuilder<double> {
  ValidationBuilder<double> min(double min) {
    return custom((value) {
      return value < min
          ? ValidationFailure('$fieldName must be at least $min')
          : ValidationSuccess(value);
    });
  }

  ValidationBuilder<double> max(double max) {
    return custom((value) {
      return value > max
          ? ValidationFailure('$fieldName must be no more than $max')
          : ValidationSuccess(value);
    });
  }

  ValidationBuilder<double> inRange(double min, double max) {
    return custom((value) {
      return value < min || value > max
          ? ValidationFailure('$fieldName must be between $min and $max')
          : ValidationSuccess(value);
    });
  }

  ValidationBuilder<double> positive() {
    return custom((value) {
      return value > 0
          ? ValidationSuccess(value)
          : ValidationFailure('$fieldName must be positive');
    });
  }

  ValidationBuilder<double> negative() {
    return custom((value) {
      return value < 0
          ? ValidationSuccess(value)
          : ValidationFailure('$fieldName must be negative');
    });
  }

  ValidationBuilder<double> nonNegative() {
    return custom((value) {
      return value >= 0
          ? ValidationSuccess(value)
          : ValidationFailure('$fieldName must be non-negative');
    });
  }
}
 */
