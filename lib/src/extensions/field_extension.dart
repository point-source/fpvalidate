part of '../validation_step.dart';

extension FieldExtension<T> on T {
  ValidationStep<T> field(String fieldName) =>
      SyncValidationStep(value: Right(this), fieldName: fieldName);
}
