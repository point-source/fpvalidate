part of '../validation_step.dart';

extension FieldExtension<T> on T {
  SyncValidationStep<T> field(String fieldName) =>
      SyncValidationStep._(value: Right(this), fieldName: fieldName);
}

extension FieldExtensionAsync<T> on Future<T> {
  AsyncValidationStep<T> field(String fieldName) => AsyncValidationStep._(
    value: TaskEither.tryCatch(
      () async => await this,
      (error, stackTrace) =>
          ValidationError(fieldName, error.toString(), stackTrace),
    ),
    fieldName: fieldName,
  );
}
