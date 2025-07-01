import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:fpvalidate/src/constants/regex/regex.dart';
import 'package:fpvalidate/src/validation_error.dart';

part 'extensions/field_extension.dart';
part 'extensions/nullable_extension.dart';
part 'extensions/num_extension.dart';
part 'extensions/string_extension.dart';

/// A sealed class representing a validation step that can be either synchronous or asynchronous.
///
/// This class serves as the base for both [SyncValidationStep] and [AsyncValidationStep],
/// providing a common interface for validation operations.
///
/// The validation step contains a field name and can be chained with other validation steps
/// to create complex validation pipelines.
sealed class ValidationStep<T> {
  /// The name of the field being validated.
  ///
  /// This is used in error messages to identify which field failed validation.
  final String fieldName;

  /// Creates a new validation step with the specified field name.
  const ValidationStep({required this.fieldName});

  /// Prevents calling .field() on a ValidationStep by shadowing the extension method.
  // ignore: avoid-shadowing
  Never field(String fieldName) => throw UnsupportedError(
    'Calling .field() on a ValidationStep is not allowed. '
    'You should only call .field() on raw values, not on validation steps.',
  );
}

/// A synchronous validation step that performs validation operations immediately.
///
/// This class provides methods for transforming and validating values synchronously.
/// It uses [Either] from the fpdart package to handle success and error cases.
///
/// Example:
/// ```dart
/// final step = "test@example.com".field("email").check(
///     (email) => email.contains('@'),
///     (fieldName) => '$fieldName must be a valid email',
///   );
/// ```
class SyncValidationStep<T> extends ValidationStep<T> {
  /// The value being validated, wrapped in an [Either] to handle success/error cases.
  final Either<ValidationError, T> _value;

  /// Creates a new synchronous validation step.
  ///
  /// [fieldName] identifies the field being validated.
  /// [value] should be an [Either] containing either a [ValidationError] (Left)
  /// or the value to validate (Right).
  const SyncValidationStep._({
    required super.fieldName,
    required Either<ValidationError, T> value,
  }) : _value = value;

  /// Creates a copy of this validation step with a new value type.
  ///
  /// This is an internal method used by other methods to create new validation steps
  /// with different value types while preserving the field name.
  SyncValidationStep<R> _copy<R>(Either<ValidationError, R> value) =>
      SyncValidationStep._(value: value, fieldName: fieldName);

  /// Attempts to transform the value using the provided function.
  ///
  /// If the transformation function throws an error, it returns a [ValidationError]
  /// with the message provided by [onFail].
  ///
  /// [f] is the transformation function that takes the current value and returns a new value.
  /// [onFail] is a function that takes the field name and returns an error message.
  ///
  /// Returns a new [SyncValidationStep] with the transformed value or an error.
  SyncValidationStep<R> tryMap<R>(
    R Function(T) f,
    String Function(String fieldName) onFail,
  ) => _copy(
    _value.flatMap(
      (v) => Either.tryCatch(
        () => f(v),
        (error, stackTrace) =>
            ValidationError(fieldName, onFail(fieldName), stackTrace),
      ),
    ),
  );

  /// Check if the value satisfies the condition.
  /// If the condition is not satisfied, return a [ValidationError]
  /// containing the error message returned by the [onFalse] function.
  SyncValidationStep<T> check(
    bool Function(T) f,
    String Function(String fieldName) onFalse,
  ) => _copy(
    _value.flatMap(
      (value) => Either.tryCatch(
        () => f(value),
        (error, stackTrace) =>
            ValidationError(fieldName, error.toString(), stackTrace),
      ).flatMap((success) => success ? pass(value) : fail(onFalse(fieldName))),
    ),
  );

  /// Binds this validation step to another validation step that returns an [Either].
  ///
  /// This method allows chaining validation steps by passing the current value
  /// to a function that returns an [Either].
  ///
  /// [f] is a function that takes the current value and returns an [Either].
  ///
  /// Returns a new [SyncValidationStep] with the result of the binding.
  SyncValidationStep<R> bind<R>(Either<ValidationError, R> Function(T) f) =>
      _copy(_value.bind(f));

  /// Creates a successful result with the given value.
  ///
  /// This is a helper method for use with custom validation logic.
  /// It wraps a value in a [Either.right].
  Either<ValidationError, R> pass<R>(R value) => Right(value);

  /// Creates a failed result with the given error message.
  ///
  /// This is a helper method for use with custom validation logic.
  /// It creates a [ValidationError] and wraps it in a [Either.left].
  Either<ValidationError, R> fail<R>(String message) =>
      Left(ValidationError(fieldName, message));

  /// Converts this synchronous validation step to an asynchronous validation step.
  ///
  /// Returns a new [AsyncValidationStep] with the same value so that
  /// asynchronous validation steps can be chained with synchronous validation steps.
  ///
  /// Example:
  /// ```dart
  /// final step = "test@example.com".field("email").toAsync();
  /// ```
  AsyncValidationStep<T> toAsync() =>
      AsyncValidationStep._(value: _value.toTaskEither(), fieldName: fieldName);

  /// Validates the value and returns it if successful, or throws a [ValidationError] if failed.
  T validate() => _value.fold((l) => throw l, (r) => r);

  Either<ValidationError, T> validateEither() => _value;

  /// Returns the error message if the validation fails, otherwise returns null.
  ///
  /// This method is useful for use with Flutter's Form widgets since they expect
  /// a [String?] to display the error message or [null] to signal success.
  ///
  /// Example:
  /// ```dart
  /// final step = "test@example.com".field("email").notEmpty();
  ///
  /// final error = step.errorOrNull();
  /// ```
  String? errorOrNull() => _value.fold((l) => l.message, (r) => null);

  /// Returns the error message if the validation fails, otherwise returns null.
  ///
  /// This method is useful for use with Flutter's Form widgets since they expect
  /// a [String?] to display the error message or [null] to signal success.
  ///
  /// This method is a shortcut for [errorOrNull] and is useful for use with Flutter's Form widgets.
  String? asFormValidator() => errorOrNull();
}

/// An asynchronous validation step that performs validation operations asynchronously.
///
/// This class provides methods for transforming and validating values asynchronously.
/// It uses [TaskEither] from the fpdart package to handle success and error cases.
///
/// Example:
/// ```dart
/// final step = "test@example.com".field("email").toAsync();
///
/// final validated = await step
///   .check(
///     (email) => email.contains('@'),
///     (fieldName) => '$fieldName must be a valid email',
///   )
///   .validate();
/// ```
class AsyncValidationStep<T> extends ValidationStep<T> {
  /// The value being validated, wrapped in a [TaskEither] to handle success/error cases asynchronously.
  final TaskEither<ValidationError, T> _value;

  /// Creates a new asynchronous validation step.
  ///
  /// [value] should be a [TaskEither] containing either a [ValidationError] (Left)
  /// or the value to validate (Right).
  /// [fieldName] identifies the field being validated.
  const AsyncValidationStep._({
    required super.fieldName,
    required TaskEither<ValidationError, T> value,
  }) : _value = value;

  /// Creates a copy of this validation step with a new value type.
  ///
  /// This is an internal method used by other methods to create new validation steps
  /// with different value types while preserving the field name.
  AsyncValidationStep<R> _copy<R>(TaskEither<ValidationError, R> value) =>
      AsyncValidationStep._(value: value, fieldName: fieldName);

  /// Attempts to transform the value using the provided asynchronous function.
  ///
  /// If the transformation function throws an error, it returns a [ValidationError]
  /// with the message provided by [onFail].
  ///
  /// [f] is the asynchronous transformation function that takes the current value and returns a [Future].
  /// [onFail] is a function that takes the field name and returns an error message.
  ///
  /// Returns a new [AsyncValidationStep] with the transformed value or an error.
  AsyncValidationStep<R> tryMap<R>(
    FutureOr<R> Function(T) f,
    String Function(String fieldName) onFail,
  ) => _copy(
    _value.flatMap(
      (v) => TaskEither.tryCatch(
        () async => await f(v),
        (error, stackTrace) =>
            ValidationError(fieldName, onFail(fieldName), stackTrace),
      ),
    ),
  );

  /// Validates that the value satisfies the given condition.
  ///
  /// If the condition returns false, it returns a [ValidationError] with the message
  /// provided by [onFalse].
  ///
  /// [f] is the validation function that takes the current value and returns a boolean.
  /// [onFalse] is a function that takes the field name and returns an error message.
  ///
  /// Returns a new [AsyncValidationStep] with the same value or an error.
  AsyncValidationStep<T> check(
    FutureOr<bool> Function(T) f,
    String Function(String fieldName) onFalse,
  ) => _copy(
    _value.flatMap(
      (value) =>
          TaskEither.tryCatch(
            () async => await f(value),
            (error, stackTrace) =>
                ValidationError(fieldName, error.toString(), stackTrace),
          ).flatMap(
            (success) => success ? _success(value) : _fail(onFalse(fieldName)),
          ),
    ),
  );

  /// Chains this asynchronous validation step with a synchronous validation step.
  ///
  /// This method allows you to use synchronous validation logic within an asynchronous pipeline.
  ///
  /// [f] is a function that takes a [SyncValidationStep] and returns another [SyncValidationStep].
  ///
  /// Returns a new [AsyncValidationStep] with the result of the chained validation.
  AsyncValidationStep<R> then<R>(
    SyncValidationStep<R> Function(SyncValidationStep<T>) f,
  ) => _copy(
    _value.chainEither(
      (value) => f(
        SyncValidationStep._(value: Right(value), fieldName: fieldName),
      )._value,
    ),
  );

  /// Binds this validation step to another validation step that returns an [Either].
  ///
  /// This method allows chaining validation steps by passing the current value
  /// to a function that returns an [Either].
  ///
  /// [f] is a function that takes the current value and returns an [Either].
  ///
  /// Returns a new [AsyncValidationStep] with the result of the binding.
  AsyncValidationStep<R> bind<R>(Either<ValidationError, R> Function(T) f) =>
      _copy(_value.chainEither(f));

  /// Binds this validation step to another validation step that returns a [TaskEither].
  ///
  /// This method allows chaining asynchronous validation steps by passing the current value
  /// to a function that returns a [TaskEither].
  ///
  /// [f] is a function that takes the current value and returns a [TaskEither].
  ///
  /// Returns a new [AsyncValidationStep] with the result of the binding.
  AsyncValidationStep<R> bindAsync<R>(
    TaskEither<ValidationError, R> Function(T) f,
  ) => _copy(_value.flatMap(f));

  /// Creates a successful result with the given value.
  ///
  /// This is an internal helper method that wraps a value in a [TaskEither.right].
  TaskEither<ValidationError, R> _success<R>(R value) =>
      TaskEither.right(value);

  /// Creates a failed result with the given error message.
  ///
  /// This is an internal helper method that creates a [ValidationError] and wraps it in a [TaskEither.left].
  TaskEither<ValidationError, R> _fail<R>(String message) =>
      TaskEither.left(ValidationError(fieldName, message));

  /// Validates the value and returns it if successful, or throws a [ValidationError] if failed.
  ///
  /// Returns a [Future] that completes with the validated value.
  ///
  /// Throws a [ValidationError] if validation fails.
  Future<T> validate() =>
      _value.run().then((value) => value.fold((l) => throw l, (r) => r));

  /// Runs the underlying [TaskEither] and returns the result as a [Future<Either<ValidationError, T>>]
  ///
  /// Returns a [Future] that completes with the validation result.
  ///
  /// Example:
  /// ```dart
  /// final result = await step.validateEither();
  /// ```
  Future<Either<ValidationError, T>> validateEither() => _value.run();

  /// Returns the underlying [TaskEither] containing the validation result.
  ///
  /// This method allows you to handle the success/error cases manually without throwing.
  ///
  /// Returns a [TaskEither] containing either a [ValidationError] or the validated value.
  TaskEither<ValidationError, T> validateTaskEither() => _value;

  /// Returns the error message if the validation fails, otherwise returns null.
  ///
  /// This method is useful for use with Flutter's Form widgets since they expect
  /// a [String?] to display the error message or [null] to signal success.
  ///
  /// Example:
  /// ```dart
  /// final step = "test@example.com".field("email").toAsync();
  ///
  /// final error = await step.errorOrNull();
  /// ```
  Future<String?> errorOrNull() =>
      _value.run().then((value) => value.fold((l) => l.message, (r) => null));

  /// Returns the error message if the validation fails, otherwise returns null.
  ///
  /// This method is useful for use with Flutter's Form widgets since they expect
  /// a [String?] to display the error message or [null] to signal success.
  ///
  /// This method is a shortcut for [errorOrNull] and is useful for use with Flutter's Form widgets.
  Future<String?> asFormValidator() => errorOrNull();
}
