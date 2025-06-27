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
}
