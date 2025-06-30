part of '../validation_step.dart';

extension NumExtension<T extends num> on SyncValidationStep<T> {
  SyncValidationStep<T> min(num min) => bind(
    (value) => value >= min
        ? _success(value)
        : _fail(
            'Value $value of field $fieldName must be greater than or equal to $min',
          ),
  );

  SyncValidationStep<T> max(num max) => bind(
    (value) => value <= max
        ? _success(value)
        : _fail(
            'Value $value of field $fieldName must be less than or equal to $max',
          ),
  );

  SyncValidationStep<T> isEven() => bind(
    (value) => value % 2 == 0
        ? _success(value)
        : _fail('Value $value of field $fieldName must be even'),
  );

  SyncValidationStep<T> isOdd() => bind(
    (value) => value % 2 == 1
        ? _success(value)
        : _fail('Value $value of field $fieldName must be odd'),
  );

  SyncValidationStep<T> isPositive() => bind(
    (value) =>
        value > 0 ? _success(value) : _fail('$fieldName must be positive'),
  );

  SyncValidationStep<T> isNonNegative() => bind(
    (value) =>
        value >= 0 ? _success(value) : _fail('$fieldName must be non-negative'),
  );

  SyncValidationStep<T> isNegative() => bind(
    (value) =>
        value < 0 ? _success(value) : _fail('$fieldName must be negative'),
  );

  SyncValidationStep<T> isNonPositive() => bind(
    (value) =>
        value <= 0 ? _success(value) : _fail('$fieldName must be non-positive'),
  );

  SyncValidationStep<int> isInteger() => bind((value) {
    if (value is int) {
      return _success<int>(value);
    }
    if (value is double && value == value.toInt()) {
      return _success<int>(value.toInt());
    }

    return _fail<int>('$fieldName must be an integer');
  });

  SyncValidationStep<T> isPowerOfTwo() => bind((value) {
    if (value <= 0) return _fail('$fieldName must be a power of 2');
    if (value is int) {
      return (value & (value - 1)) == 0
          ? _success(value)
          : _fail('$fieldName must be a power of 2');
    }
    // For doubles, check if it's a power of 2
    double v = value.toDouble();
    while (v > 1) {
      if (v % 2 != 0) return _fail('$fieldName must be a power of 2');
      v /= 2;
    }

    return v == 1 ? _success(value) : _fail('$fieldName must be a power of 2');
  });

  SyncValidationStep<T> isPerfectSquare() => bind((value) {
    if (value < 0) return _fail('$fieldName must be a perfect square');
    final sqrt = math.sqrt(value);

    return sqrt * sqrt == value
        ? _success(value)
        : _fail('$fieldName must be a perfect square');
  });

  SyncValidationStep<T> isPortNumber() => bind(
    (value) => value >= 1 && value <= 65535
        ? _success(value)
        : _fail('$fieldName must be a valid port number (1-65535)'),
  );

  SyncValidationStep<T> isWithinPercentage(num target, double percentage) =>
      bind((value) {
        final tolerance = target * (percentage / 100);
        final min = target - tolerance;
        final max = target + tolerance;

        return value >= min && value <= max
            ? _success(value)
            : _fail('$fieldName must be within $percentage% of $target');
      });

  SyncValidationStep<T> inRange(num min, num max) => bind(
    (value) => value >= min && value <= max
        ? _success(value)
        : _fail(
            'Value $value of field $fieldName must be between $min and $max',
          ),
  );
}
