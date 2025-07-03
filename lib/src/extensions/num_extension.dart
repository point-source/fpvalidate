part of '../validation_step.dart';

/// Extension that provides validation methods for numeric values.
///
/// This extension adds comprehensive validation capabilities to numeric types
/// (int and double), including range validation, mathematical properties,
/// and type-specific validations.
///
/// Example:
/// ```dart
/// final result = 25
///     .field('Age')
///     .min(18)
///     .max(65)
///     .isEven()
///     .validateEither();
/// ```
extension NumExtension<T extends num> on SyncValidationStep<T> {
  /// Validates that the value is greater than or equal to [min].
  ///
  /// Returns a [ValidationError] if the value is less than [min].
  ///
  /// Example:
  /// ```dart
  /// final result = age.field('Age').min(18).validateEither();
  /// ```
  SyncValidationStep<T> min(num min) => bind(
    (value) => value >= min
        ? pass(value)
        : fail(
            InvalidMinValueValidationError.new,
            'Value $value of field $fieldName must be greater than or equal to $min',
          ),
  );

  /// Validates that the value is less than or equal to [max].
  ///
  /// Returns a [ValidationError] if the value is greater than [max].
  ///
  /// Example:
  /// ```dart
  /// final result = age.field('Age').max(65).validateEither();
  /// ```
  SyncValidationStep<T> max(num max) => bind(
    (value) => value <= max
        ? pass(value)
        : fail(
            InvalidMaxValueValidationError.new,
            'Value $value of field $fieldName must be less than or equal to $max',
          ),
  );

  /// Validates that the value is even (divisible by 2).
  ///
  /// Returns a [ValidationError] if the value is odd.
  ///
  /// Example:
  /// ```dart
  /// final result = number.field('Number').isEven().validateEither();
  /// ```
  SyncValidationStep<T> isEven() => bind(
    (value) => value % 2 == 0
        ? pass(value)
        : fail(
            InvalidEvenNumberValidationError.new,
            'Value $value of field $fieldName must be even',
          ),
  );

  /// Validates that the value is odd (not divisible by 2).
  ///
  /// Returns a [ValidationError] if the value is even.
  ///
  /// Example:
  /// ```dart
  /// final result = number.field('Number').isOdd().validateEither();
  /// ```
  SyncValidationStep<T> isOdd() => bind(
    (value) => value % 2 == 1
        ? pass(value)
        : fail(
            InvalidOddNumberValidationError.new,
            'Value $value of field $fieldName must be odd',
          ),
  );

  /// Validates that the value is positive (greater than 0).
  ///
  /// Returns a [ValidationError] if the value is zero or negative.
  ///
  /// Example:
  /// ```dart
  /// final result = number.field('Number').isPositive().validateEither();
  /// ```
  SyncValidationStep<T> isPositive() => bind(
    (value) => value > 0
        ? pass(value)
        : fail(
            InvalidPositiveNumberValidationError.new,
            '$fieldName must be positive',
          ),
  );

  /// Validates that the value is non-negative (greater than or equal to 0).
  ///
  /// Returns a [ValidationError] if the value is negative.
  ///
  /// Example:
  /// ```dart
  /// final result = number.field('Number').isNonNegative().validateEither();
  /// ```
  SyncValidationStep<T> isNonNegative() => bind(
    (value) => value >= 0
        ? pass(value)
        : fail(
            InvalidNonNegativeNumberValidationError.new,
            '$fieldName must be non-negative',
          ),
  );

  /// Validates that the value is negative (less than 0).
  ///
  /// Returns a [ValidationError] if the value is zero or positive.
  ///
  /// Example:
  /// ```dart
  /// final result = number.field('Number').isNegative().validateEither();
  /// ```
  SyncValidationStep<T> isNegative() => bind(
    (value) => value < 0
        ? pass(value)
        : fail(
            InvalidNegativeNumberValidationError.new,
            '$fieldName must be negative',
          ),
  );

  /// Validates that the value is non-positive (less than or equal to 0).
  ///
  /// Returns a [ValidationError] if the value is positive.
  ///
  /// Example:
  /// ```dart
  /// final result = number.field('Number').isNonPositive().validateEither();
  /// ```
  SyncValidationStep<T> isNonPositive() => bind(
    (value) => value <= 0
        ? pass(value)
        : fail(
            InvalidNonPositiveNumberValidationError.new,
            '$fieldName must be non-positive',
          ),
  );

  /// Validates that the value is an integer and converts it to [int] type.
  ///
  /// This method checks if the value is an integer (either already an [int] or
  /// a [double] that equals its integer part). If valid, it returns a new
  /// [SyncValidationStep<int>] that can be chained with integer-specific validators.
  ///
  /// This is a type transformation validator that changes the validator type from
  /// [SyncValidationStep<T>] to [SyncValidationStep<int>].
  ///
  /// Returns a [SyncValidationStep<int>] if the value is an integer.
  ///
  /// Example:
  /// ```dart
  /// final result = 25.0
  ///     .field('Age')
  ///     .isInt()              // Converts num to int
  ///     .min(18)              // Now we can use int validators
  ///     .max(65)
  ///     .validateEither();
  /// ```
  SyncValidationStep<int> isInt() => bind((value) {
    if (value is int) {
      return pass<InvalidIntegerValidationError, int>(value);
    }
    if (value is double && value == value.toInt()) {
      return pass<InvalidIntegerValidationError, int>(value.toInt());
    }

    return fail<InvalidIntegerValidationError, int>(
      InvalidIntegerValidationError.new,
      '$fieldName must be an integer',
    );
  });

  /// Validates that the value is a power of 2.
  ///
  /// A power of 2 is a number that can be written as 2^n where n is a non-negative integer.
  /// Examples: 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, etc.
  ///
  /// Returns a [ValidationError] if the value is not a power of 2.
  ///
  /// Example:
  /// ```dart
  /// final result = number.field('Number').isPowerOfTwo().validateEither();
  /// ```
  SyncValidationStep<T> isPowerOfTwo() => bind((value) {
    if (value <= 0) {
      return fail(
        InvalidPowerOfTwoValidationError.new,
        '$fieldName must be a power of 2',
      );
    }
    if (value == 1) return pass(value); // 2^0 = 1
    if (value is int) {
      return (value & (value - 1)) == 0
          ? pass(value)
          : fail(
              InvalidPowerOfTwoValidationError.new,
              '$fieldName must be a power of 2',
            );
    }
    double v = value.toDouble();
    while (v > 1) {
      if (v % 2 != 0) {
        return fail(
          InvalidPowerOfTwoValidationError.new,
          '$fieldName must be a power of 2',
        );
      }
      v /= 2;
    }

    return v == 1
        ? pass(value)
        : fail(
            InvalidPowerOfTwoValidationError.new,
            '$fieldName must be a power of 2',
          );
  });

  /// Validates that the value is a valid port number (1-65535).
  ///
  /// Port numbers are used in networking to identify specific processes or services.
  /// Valid port numbers range from 1 to 65535.
  ///
  /// Returns a [ValidationError] if the value is not a valid port number.
  ///
  /// Example:
  /// ```dart
  /// final result = port.field('Port').isPortNumber().validateEither();
  /// ```
  SyncValidationStep<T> isPortNumber() => bind(
    (value) => value >= 1 && value <= 65535
        ? pass(value)
        : fail(
            InvalidPortNumberValidationError.new,
            '$fieldName must be a valid port number (1-65535)',
          ),
  );

  /// Validates that the value is within a specified percentage of a target value.
  ///
  /// This method checks if the value falls within a tolerance range around the target.
  /// The tolerance is calculated as [target] * [percentage] / 100.
  ///
  /// [target] is the reference value to compare against.
  /// [percentage] is the tolerance percentage (e.g., 5.0 for 5%).
  ///
  /// Returns a [ValidationError] if the value is outside the tolerance range.
  ///
  /// Example:
  /// ```dart
  /// final result = measurement
  ///     .field('Measurement')
  ///     .isWithinPercentage(100.0, 5.0)  // Within 5% of 100
  ///     .validateEither();
  /// ```
  SyncValidationStep<T> isWithinPercentage(num target, double percentage) =>
      bind((value) {
        final tolerance = target * (percentage / 100);
        final min = target - tolerance;
        final max = target + tolerance;

        return value >= min && value <= max
            ? pass(value)
            : fail(
                InvalidPercentageRangeValidationError.new,
                '$fieldName must be within $percentage% of $target',
              );
      });

  /// Validates that the value is within the specified range [min] to [max] (inclusive).
  ///
  /// This method checks if the value is greater than or equal to [min] and
  /// less than or equal to [max].
  ///
  /// Returns a [ValidationError] if the value is outside the range.
  ///
  /// Example:
  /// ```dart
  /// final result = age.field('Age').inRange(18, 65).validateEither();
  /// ```
  SyncValidationStep<T> inRange(num min, num max) => bind(
    (value) => value >= min && value <= max
        ? pass(value)
        : fail(
            InvalidRangeValidationError.new,
            'Value $value of field $fieldName must be between $min and $max',
          ),
  );

  /// Validates that the numeric value is one of the specified allowed values.
  ///
  /// This method checks if the current value matches any of the values in [allowedValues].
  ///
  /// [allowedValues] is a list of numbers that are considered valid.
  ///
  /// Returns a [ValidationError] if the value is not in the allowed values list.
  ///
  /// Example:
  /// ```dart
  /// final result = priority
  ///     .field('Priority')
  ///     .isOneOf([1, 2, 3, 4, 5])
  ///     .validateEither();
  ///
  /// final result2 = rating
  ///     .field('Rating')
  ///     .isOneOf([1.0, 2.0, 3.0, 4.0, 5.0])
  ///     .validateEither();
  /// ```
  SyncValidationStep<T> isOneOf(List<T> allowedValues) => bind(
    (value) => allowedValues.contains(value)
        ? pass(value)
        : fail(
            InvalidAllowedNumericValueValidationError.new,
            '$fieldName must be one of: ${allowedValues.join(', ')}',
          ),
  );

  /// Validates that the numeric value is not one of the specified forbidden values.
  ///
  /// This method checks if the current value does not match any of the values in [forbiddenValues].
  ///
  /// [forbiddenValues] is a list of numbers that are considered invalid.
  ///
  /// Returns a [ValidationError] if the value is in the forbidden values list.
  ///
  /// Example:
  /// ```dart
  /// final result = port
  ///     .field('Port')
  ///     .isNoneOf([80, 443, 8080])
  ///     .validateEither();
  ///
  /// final result2 = rating
  ///     .field('Rating')
  ///     .isNoneOf([0.0, 1.0, 2.0])
  ///     .validateEither();
  /// ```
  SyncValidationStep<T> isNoneOf(List<T> forbiddenValues) => bind(
    (value) => !forbiddenValues.contains(value)
        ? pass(value)
        : fail(
            InvalidForbiddenNumericValueValidationError.new,
            '$fieldName must not be one of: \\${forbiddenValues.join(', ')}',
          ),
  );
}
