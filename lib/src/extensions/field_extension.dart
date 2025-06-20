part of '../validation_step.dart';

extension FieldExtension<T> on T {
  ValidationStep<T> field(String fieldName) => Success(fieldName, this);
}
