import 'package:fpdart/fpdart.dart';
import 'package:fpvalidate/fpvalidate.dart';

/// Extension that provides batch validation capabilities for lists of validation steps.
///
/// This extension allows you to validate multiple fields at once, supporting both
/// synchronous and asynchronous validation steps. It provides methods that handle
/// mixed lists of sync and async validation steps automatically.
///
/// Example:
/// ```dart
/// final result = [
///   email.field('Email').isNotEmpty().isEmail(),
///   password.field('Password').isNotEmpty().minLength(8),
///   age.field('Age').min(13).max(120),
/// ].validateEither();
/// ```
extension BatchValidationExtension<T> on List<ValidationStep<T>> {
  /// Validates all validation steps asynchronously and returns a list of validated values.
  ///
  /// This method handles both synchronous and asynchronous validation steps.
  /// Synchronous steps are wrapped in a Future, while asynchronous steps are
  /// executed as-is. All validations run concurrently.
  ///
  /// Returns a [Future<List<T>>] containing all validated values if successful,
  /// or throws the first [ValidationError] encountered.
  ///
  /// Example:
  /// ```dart
  /// final values = await [
  ///   email.field('Email').isNotEmpty().isEmail(),
  ///   password.field('Password').isNotEmpty().minLength(8),
  /// ].validateAsync();
  /// ```
  Future<List<T>> validateAsync() => Future.wait(
    map(
      (step) => switch (step) {
        SyncValidationStep<T> _ => Future.value(step.validate()),
        AsyncValidationStep<T> _ => step.validate().then((value) => value),
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
  /// - [Right] contains a list of all validated values
  ///
  /// Example:
  /// ```dart
  /// final result = await [
  ///   email.field('Email').isNotEmpty().isEmail(),
  ///   password.field('Password').isNotEmpty().minLength(8),
  /// ].validateTaskEither().run();
  /// ```
  TaskEither<ValidationError, List<T>> validateTaskEither() => map(
    (step) => switch (step) {
      SyncValidationStep<T> _ => step.validateEither().toTaskEither(),
      AsyncValidationStep<T> _ => step.validateTaskEither(),
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
/// final result = [
///   email.field('Email').isNotEmpty().isEmail(),
///   password.field('Password').isNotEmpty().minLength(8),
/// ].validateEither();
/// ```
extension BatchSyncValidationExtension<T> on List<SyncValidationStep<T>> {
  /// Validates all synchronous validation steps and returns a list of validated values.
  ///
  /// This method executes all validations synchronously and returns the results
  /// immediately. If any validation fails, a [ValidationError] is thrown.
  ///
  /// Returns a [List<T>] containing all validated values if successful.
  ///
  /// Example:
  /// ```dart
  /// final values = [
  ///   email.field('Email').isNotEmpty().isEmail(),
  ///   password.field('Password').isNotEmpty().minLength(8),
  /// ].validate();
  /// ```
  List<T> validate() => map((step) => step.validate()).toList();

  /// Validates all synchronous validation steps and returns an [Either] containing the results.
  ///
  /// This method executes all validations synchronously and returns the results
  /// wrapped in an [Either] for functional error handling.
  ///
  /// Returns an [Either<ValidationError, List<T>>] where:
  /// - [Left] contains the first [ValidationError] encountered
  /// - [Right] contains a list of all validated values
  ///
  /// Example:
  /// ```dart
  /// final result = [
  ///   email.field('Email').isNotEmpty().isEmail(),
  ///   password.field('Password').isNotEmpty().minLength(8),
  /// ].validateEither();
  /// ```
  Either<ValidationError, List<T>> validateEither() =>
      map((step) => step.validateEither()).sequenceEither();
}

/// Extension that provides batch validation capabilities for lists of asynchronous validation steps.
///
/// This extension is optimized for lists containing only asynchronous validation steps,
/// providing more efficient validation methods.
///
/// Example:
/// ```dart
/// final result = await [
///   email.field('Email').toAsync().isNotEmpty().isEmail(),
///   password.field('Password').toAsync().isNotEmpty().minLength(8),
/// ].validateTaskEither().run();
/// ```
extension BatchAsyncValidationExtension<T> on List<AsyncValidationStep<T>> {
  /// Validates all asynchronous validation steps and returns a list of validated values.
  ///
  /// This method executes all validations asynchronously and returns the results
  /// when all validations complete. If any validation fails, a [ValidationError] is thrown.
  ///
  /// Returns a [Future<List<T>>] containing all validated values if successful.
  ///
  /// Example:
  /// ```dart
  /// final values = await [
  ///   email.field('Email').toAsync().isNotEmpty().isEmail(),
  ///   password.field('Password').toAsync().isNotEmpty().minLength(8),
  /// ].validateAsync();
  /// ```
  Future<List<T>> validateAsync() =>
      BatchValidationExtension(this).validateAsync();

  /// Validates all asynchronous validation steps and returns a [TaskEither] containing the results.
  ///
  /// This method executes all validations asynchronously and returns the results
  /// wrapped in a [TaskEither] for functional error handling.
  ///
  /// Returns a [TaskEither<ValidationError, List<T>>] where:
  /// - [Left] contains the first [ValidationError] encountered
  /// - [Right] contains a list of all validated values
  ///
  /// Example:
  /// ```dart
  /// final result = await [
  ///   email.field('Email').toAsync().isNotEmpty().isEmail(),
  ///   password.field('Password').toAsync().isNotEmpty().minLength(8),
  /// ].validateTaskEither().run();
  /// ```
  TaskEither<ValidationError, List<T>> validateTaskEither() =>
      BatchValidationExtension(this).validateTaskEither();
}
