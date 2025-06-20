import 'package:fpdart/fpdart.dart';
import 'package:fpvalidate/src/validation_result.dart';
import 'validation_error.dart';

/// A function type that validates a value and returns a validation result.
typedef Validator<T> = ValidationResult<T> Function(T value);

/// A function type that validates a value asynchronously and returns a validation result.
typedef AsyncValidator<T> = Future<ValidationResult<T>> Function(T value);

/// A builder class that provides a fluent API for creating validation chains.
///
/// This class allows you to build validation rules for a single field and then
/// execute them to get either a success result or a validation error.
///
/// Example:
/// ```dart
/// final result = email
///     .field('Email')
///     .notEmpty()
///     .email()
///     .validate();
/// ```
class ValidationBuilder<T> {
  /// Creates a new validation builder for the given value and field name.
  ValidationBuilder(this.value, this.fieldName);

  /// The value being validated.
  final T value;

  /// The name of the field being validated (used in error messages).
  final String fieldName;

  /// The list of validators to apply to the value.
  final List<Validator<T>> _validators = [];

  /// Validates that the field is not null.
  ///
  /// This method is only available for nullable types.
  ValidationBuilder<T?> nonNull() {
    _validators.add(
      (val) => val == null
          ? ValidationFailure('$fieldName cannot be null')
          : ValidationSuccess(val),
    );

    return this as ValidationBuilder<T?>;
  }

  /// Validates that the field is not null and not empty.
  ///
  /// This method is only available for nullable types.
  ValidationBuilder<T?> nonNullOrEmpty() {
    _validators.add((val) {
      if (val == null) return ValidationFailure('$fieldName cannot be null');
      if (val is String && val.isEmpty) {
        return ValidationFailure('$fieldName cannot be empty');
      }

      return ValidationSuccess(val);
    });

    return this as ValidationBuilder<T?>;
  }

  /// Adds a custom validator function.
  ///
  /// [validator] is a function that takes a value and returns a [ValidationResult].
  /// This allows you to create custom validation logic that integrates with the fluent API.
  ValidationBuilder<T> custom(Validator<T> validator) {
    _validators.add(validator);

    return this;
  }

  /// Adds a custom async validator function.
  ///
  /// [validator] is a function that takes a value and returns a [Future<ValidationResult>].
  /// This method converts the current builder to an [AsyncValidationBuilder] to ensure
  /// proper async validation handling.
  ///
  /// Example:
  /// ```dart
  /// final result = await email
  ///     .field('Email')
  ///     .notEmpty()
  ///     .email()
  ///     .customAsync((email) async {
  ///       // Check if email exists in database
  ///       final exists = await userService.emailExists(email);
  ///       return exists
  ///           ? ValidationFailure('Email already registered')
  ///           : ValidationSuccess(email);
  ///     })
  ///     .validateAsync();
  /// ```
  AsyncValidationBuilder<T> customAsync(AsyncValidator<T> validator) {
    return AsyncValidationBuilder._fromSync(this, validator);
  }

  /// Executes all validators and throws a [ValidationError] if validation fails.
  ///
  /// Throws a [ValidationError] if any validation fails,
  /// or returns the original value if all validations pass.
  ///
  /// This method is useful for users who prefer traditional exception handling.
  T validate() {
    for (final validator in _validators) {
      final result = validator(value);
      switch (result) {
        case ValidationFailure(message: final msg):
          throw ValidationError(fieldName, msg);
        case ValidationSuccess():
          continue;
      }
    }

    return value;
  }

  /// Executes all validators and returns the result as an [Either].
  ///
  /// Returns [Either.left] with a [ValidationError] if any validation fails,
  /// or [Either.right] with the original value if all validations pass.
  ///
  /// This is useful for synchronous validation scenarios with fpdart.
  Either<ValidationError, T> validateEither() => Either.tryCatch(
    () => validate(),
    (e, stackTrace) => e is ValidationError
        ? e
        : ValidationError(
            fieldName,
            'Validation failed: ${e.toString()}',
            stackTrace,
          ),
  );

  /// Executes all validators and returns the result as a [TaskEither].
  ///
  /// Returns [TaskEither.left] with a [ValidationError] if any validation fails,
  /// or [TaskEither.right] with the original value if all validations pass.
  ///
  /// This is useful for synchronous validation scenarios with fpdart that need
  /// to be wrapped in a TaskEither for consistency with async validation.
  TaskEither<ValidationError, T> validateTaskEither() => TaskEither.tryCatch(
    () async => validate(),
    (e, stackTrace) => e is ValidationError
        ? e
        : ValidationError(
            fieldName,
            'Validation failed: ${e.toString()}',
            stackTrace,
          ),
  );
}

/// An async version of [ValidationBuilder] that handles asynchronous validation.
///
/// This class is automatically created when you add an async validator to a regular
/// [ValidationBuilder]. It provides the same fluent API but with async validation methods.
///
/// Example:
/// ```dart
/// final result = await email
///     .field('Email')
///     .notEmpty()
///     .email()
///     .customAsync((email) async {
///       // Check if email exists in database
///       final exists = await userService.emailExists(email);
///       return exists
///           ? ValidationFailure('Email already registered')
///           : ValidationSuccess(email);
///     })
///     .validateAsync();
/// ```
class AsyncValidationBuilder<T> extends ValidationBuilder<T> {
  /// Creates a new async validation builder from a sync builder and an async validator.
  AsyncValidationBuilder._fromSync(
    ValidationBuilder<T> syncBuilder,
    AsyncValidator<T> validator,
  ) : super(syncBuilder.value, syncBuilder.fieldName) {
    // Copy all validators from the sync builder
    _validators.addAll(syncBuilder._validators);
    _asyncValidators.add(validator);
  }

  /// The list of async validators to apply to the value.
  final List<AsyncValidator<T>> _asyncValidators = [];

  /// Adds a custom async validator function.
  ///
  /// [validator] is a function that takes a value and returns a [Future<ValidationResult>].
  /// This allows you to create custom async validation logic that integrates with the fluent API.
  @override
  AsyncValidationBuilder<T> customAsync(AsyncValidator<T> validator) {
    _asyncValidators.add(validator);

    return this;
  }

  /// Executes all validators (including async ones) and throws a [ValidationError] if validation fails.
  ///
  /// Throws a [ValidationError] if any validation fails,
  /// or returns the original value if all validations pass.
  ///
  /// This method is useful for users who prefer traditional exception handling.
  Future<T> validateAsync() async {
    // Execute sync validators first
    for (final validator in _validators) {
      final result = validator(value);
      switch (result) {
        case ValidationFailure(message: final msg):
          throw ValidationError(fieldName, msg);
        case ValidationSuccess():
          continue;
      }
    }

    // Execute async validators
    for (final validator in _asyncValidators) {
      final result = await validator(value);
      switch (result) {
        case ValidationFailure(message: final msg):
          throw ValidationError(fieldName, msg);
        case ValidationSuccess():
          continue;
      }
    }

    return value;
  }

  /// Executes all validators and returns the result as a [TaskEither].
  ///
  /// Returns [TaskEither.left] with a [ValidationError] if any validation fails,
  /// or [TaskEither.right] with the original value if all validations pass.
  ///
  /// This is useful for asynchronous validation scenarios with fpdart.
  @override
  TaskEither<ValidationError, T> validateTaskEither() => TaskEither.tryCatch(
    () async => await validateAsync(),
    (e, stackTrace) => e is ValidationError
        ? e
        : ValidationError(
            fieldName,
            'Validation failed: ${e.toString()}',
            stackTrace,
          ),
  );
}
