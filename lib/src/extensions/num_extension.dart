part of '../validation_step.dart';

extension NumExtension<T extends num> on ValidationStep<T> {
  ValidationStep<T> min(num min) => next(
    (value) => value >= min
        ? _success(value)
        : _fail(
            'Value $value of field $fieldName must be greater than or equal to $min',
          ),
  );

  ValidationStep<T> max(num max) => next(
    (value) => value <= max
        ? _success(value)
        : _fail(
            'Value $value of field $fieldName must be less than or equal to $max',
          ),
  );

  ValidationStep<T> isEven() => next(
    (value) => value % 2 == 0
        ? _success(value)
        : _fail('Value $value of field $fieldName must be even'),
  );

  ValidationStep<T> isOdd() => next(
    (value) => value % 2 == 1
        ? _success(value)
        : _fail('Value $value of field $fieldName must be odd'),
  );
}
