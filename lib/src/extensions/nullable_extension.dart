part of '../validation_step.dart';

extension NullableExtension<T> on ValidationStep<T?> {
  ValidationStep<T> notNull() => map(
    (value) => value == null
        ? _fail<T>('Field $fieldName is null')
        : _success<T>(value),
  );
}
