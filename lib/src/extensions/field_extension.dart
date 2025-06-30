part of '../validation_step.dart';

/// Extension that provides the [field] method for creating validation steps from values.
///
/// This extension allows you to start a validation chain by calling [field] on any value.
/// The [field] method creates a [SyncValidationStep] that can be chained with various
/// validation methods.
///
/// Example:
/// ```dart
/// final result = 'test@example.com'
///     .field('Email')
///     .notEmpty()
///     .isEmail()
///     .validateEither();
/// ```
extension FieldExtension<T> on T {
  /// Creates a synchronous validation step for this value.
  ///
  /// This method is the entry point for creating validation chains. It wraps the
  /// current value in a [SyncValidationStep] that can be chained with various
  /// validation methods.
  ///
  /// [fieldName] is used in error messages to identify which field failed validation.
  /// It should be descriptive and user-friendly (e.g., 'Email', 'Password', 'Age').
  ///
  /// Returns a [SyncValidationStep<T>] that can be chained with validation methods.
  ///
  /// Example:
  /// ```dart
  /// final step = 'test@example.com'.field('Email');
  /// final result = step.notEmpty().isEmail().validateEither();
  /// ```
  SyncValidationStep<T> field(String fieldName) =>
      SyncValidationStep._(value: Right(this), fieldName: fieldName);
}

/// Extension that provides the [field] method for creating validation steps from [Future] values.
///
/// This extension allows you to start an asynchronous validation chain by calling [field]
/// on a [Future]. The [field] method creates an [AsyncValidationStep] that can be chained
/// with various validation methods.
///
/// Example:
/// ```dart
/// final result = await Future.value('test@example.com')
///     .field('Email')
///     .notEmpty()
///     .isEmail()
///     .validateEither();
/// ```
extension FieldExtensionAsync<T> on Future<T> {
  /// Creates an asynchronous validation step for this [Future] value.
  ///
  /// This method is the entry point for creating asynchronous validation chains.
  /// It wraps the current [Future] in an [AsyncValidationStep] that can be chained
  /// with various validation methods.
  ///
  /// [fieldName] is used in error messages to identify which field failed validation.
  /// It should be descriptive and user-friendly (e.g., 'Email', 'Password', 'Age').
  ///
  /// Returns an [AsyncValidationStep<T>] that can be chained with validation methods.
  ///
  /// Example:
  /// ```dart
  /// final step = Future.value('test@example.com').field('Email');
  /// final result = await step.notEmpty().isEmail().validateEither();
  /// ```
  AsyncValidationStep<T> field(String fieldName) => AsyncValidationStep._(
    value: TaskEither.tryCatch(
      () async => await this,
      (error, stackTrace) =>
          ValidationError(fieldName, error.toString(), stackTrace),
    ),
    fieldName: fieldName,
  );
}
