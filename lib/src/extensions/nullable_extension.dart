part of '../validation_step.dart';

extension NullableExtension<T> on SyncValidationStep<T?> {
  SyncValidationStep<T> notNull() => bind(
    (value) => value == null
        ? _fail<T>('Field $fieldName is null')
        : _success<T>(value),
  );
}
