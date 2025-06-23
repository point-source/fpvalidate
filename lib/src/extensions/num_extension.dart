part of '../validation_step.dart';

extension NumExtension<T extends num> on ValidationStep<T> {
  ValidationStep<T> min(num min) => bind(
    (value) => value >= min
        ? _success(value)
        : _fail(
            'Value $value of field $fieldName must be greater than or equal to $min',
          ),
  );

  ValidationStep<T> max(num max) => bind(
    (value) => value <= max
        ? _success(value)
        : _fail(
            'Value $value of field $fieldName must be less than or equal to $max',
          ),
  );

  ValidationStep<T> isEven() => bind(
    (value) => value % 2 == 0
        ? _success(value)
        : _fail('Value $value of field $fieldName must be even'),
  );

  ValidationStep<T> isOdd() => bind(
    (value) => value % 2 == 1
        ? _success(value)
        : _fail('Value $value of field $fieldName must be odd'),
  );
}
