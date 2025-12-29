import 'package:fpdart/fpdart.dart';
import 'package:trust_but_verify/trust_but_verify.dart';

/// Extension that provides batch validation capabilities for lists of validation steps.
///
/// This extension allows you to validate multiple fields at once, supporting both
/// synchronous and asynchronous validation steps. It provides methods that handle
/// mixed lists of sync and async validation steps automatically.
///
/// Example:
/// ```dart
/// final values = [
///   email.trust('Email').isNotEmpty().isEmail(),
///   password.trust('Password').isNotEmpty().minLength(8),
///   age.trust('Age').min(13).max(120),
/// ].verifyAsync();
/// ```
extension BatchValidationExtension<T> on List<ValidationStep<T>> {
  /// Validates all validation steps asynchronously and returns a list of verified values.
  ///
  /// This method handles both synchronous and asynchronous validation steps.
  /// Synchronous steps are wrapped in a Future, while asynchronous steps are
  /// executed as-is. All validations run concurrently.
  ///
  /// Returns a [Future<List<T>>] containing all verified values if successful,
  /// or throws the first [ValidationError] encountered.
  ///
  /// Example:
  /// ```dart
  /// final values = await [
  ///   email.trust('Email').isNotEmpty().isEmail(),
  ///   password.trust('Password').isNotEmpty().minLength(8),
  /// ].verifyAsync();
  /// ```
  Future<List<T>> verifyAsync([
    String Function(String fieldName)? customMessage,
  ]) => Future.wait(
    map(
      (step) => switch (step) {
        SyncValidationStep<T>() => Future.value(step.verify(customMessage)),
        AsyncValidationStep<T>() =>
          step.verify(customMessage).then((value) => value),
      },
    ),
  );

  /// Validates all validation steps and returns a [TaskEither] containing the results.
  ///
  /// This method handles both synchronous and asynchronous validation steps.
  /// Synchronous steps are converted to [TaskEither], while asynchronous steps
  /// are executed as-is. All validations run concurrently.
  ///
  /// Returns a [TaskEither<ValidationError, List<T>>] where:
  /// - [Left] contains the first [ValidationError] encountered
  /// - [Right] contains a list of all verified values
  ///
  /// Example:
  /// ```dart
  /// final result = await [
  ///   email.trust('Email').isNotEmpty().isEmail(),
  ///   password.trust('Password').isNotEmpty().minLength(8),
  /// ].verifyTaskEither().run();
  /// ```
  TaskEither<ValidationError, List<T>> verifyTaskEither([
    String Function(String fieldName)? customMessage,
  ]) => map(
    (step) => switch (step) {
      SyncValidationStep<T>() =>
        step.verifyEither(customMessage).toTaskEither(),
      AsyncValidationStep<T>() => step.verifyTaskEither(customMessage),
    },
  ).sequenceTaskEither();
}

/// Extension that provides batch validation capabilities for lists of synchronous validation steps.
///
/// This extension is optimized for lists containing only synchronous validation steps,
/// providing more efficient validation methods.
///
/// Example:
/// ```dart
/// final values = [
///   email.trust('Email').isNotEmpty().isEmail(),
///   password.trust('Password').isNotEmpty().minLength(8),
/// ].verify();
/// ```
extension BatchSyncValidationExtension<T> on List<SyncValidationStep<T>> {
  /// Verifies all synchronous validation steps and returns a list of verified values.
  ///
  /// This method executes all validations synchronously and returns the results
  /// immediately. If any validation fails, a [ValidationError] is thrown.
  ///
  /// Returns a [List<T>] containing all verified values if successful.
  ///
  /// Example:
  /// ```dart
  /// final values = [
  ///   email.trust('Email').isNotEmpty().isEmail(),
  ///   password.trust('Password').isNotEmpty().minLength(8),
  /// ].verify();
  /// ```
  List<T> verify([String Function(String fieldName)? customMessage]) =>
      map((step) => step.verify(customMessage)).toList();

  /// Verifies all synchronous validation steps and returns an [Either] containing the results.
  ///
  /// This method executes all validations synchronously and returns the results
  /// wrapped in an [Either] for functional error handling.
  ///
  /// Returns an [Either<ValidationError, List<T>>] where:
  /// - [Left] contains the first [ValidationError] encountered
  /// - [Right] contains a list of all verified values
  ///
  /// Example:
  /// ```dart
  /// final result = [
  ///   email.trust('Email').isNotEmpty().isEmail(),
  ///   password.trust('Password').isNotEmpty().minLength(8),
  /// ].verifyEither();
  /// ```
  Either<ValidationError, List<T>> verifyEither([
    String Function(String fieldName)? customMessage,
  ]) => map((step) => step.verifyEither(customMessage)).sequenceEither();
}

/// Extension that provides batch validation capabilities for lists of asynchronous validation steps.
///
/// This extension is optimized for lists containing only asynchronous validation steps,
/// providing more efficient validation methods.
///
/// Example:
/// ```dart
/// final result = await [
///   email.trust('Email').toAsync().isNotEmpty().isEmail(),
///   password.trust('Password').toAsync().isNotEmpty().minLength(8),
/// ].verifyTaskEither().run();
/// ```
extension BatchAsyncValidationExtension<T> on List<AsyncValidationStep<T>> {
  /// Verifies all asynchronous validation steps and returns a list of verified values.
  ///
  /// This method executes all validations asynchronously and returns the results
  /// when all validations complete. If any validation fails, a [ValidationError] is thrown.
  ///
  /// Returns a [Future<List<T>>] containing all verified values if successful.
  ///
  /// Example:
  /// ```dart
  /// final values = await [
  ///   email.trust('Email').toAsync().isNotEmpty().isEmail(),
  ///   password.trust('Password').toAsync().isNotEmpty().minLength(8),
  /// ].verifyAsync();
  /// ```
  Future<List<T>> verifyAsync([
    String Function(String fieldName)? customMessage,
  ]) => BatchValidationExtension(this).verifyAsync(customMessage);

  /// Verifies all asynchronous validation steps and returns a [TaskEither] containing the results.
  ///
  /// [customMessage] is an optional function to override the error message.
  ///
  /// Example:
  /// ```dart
  /// final result = await [
  ///   email.trust('Email').toAsync().isNotEmpty().isEmail(),
  ///   password.trust('Password').toAsync().isNotEmpty().minLength(8),
  /// ].verifyTaskEither().run();
  /// ```
  TaskEither<ValidationError, List<T>> verifyTaskEither([
    String Function(String fieldName)? customMessage,
  ]) => BatchValidationExtension(this).verifyTaskEither(customMessage);
}
