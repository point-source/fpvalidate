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

  /// The list of async validators to apply to the value.
  final List<AsyncValidator<T>> _asyncValidators = [];

  /// Validates that the field is not empty.
  ///
  /// For strings, checks if the string is not empty.
  /// For other types, checks if the value is not null and converts to string.
  ValidationBuilder<T> notEmpty() {
    _validators.add((value) {
      final stringValue = value.toString();

      return stringValue.isEmpty
          ? ValidationFailure('$fieldName not provided')
          : ValidationSuccess(value);
    });

    return this;
  }

  /// Validates that the field has a minimum length.
  ///
  /// Converts the value to string and checks if its length is at least [minLength].
  ValidationBuilder<T> minLength(int minLength) {
    _validators.add((value) {
      final stringValue = value.toString();

      return stringValue.length < minLength
          ? ValidationFailure(
              '$fieldName must be at least $minLength characters',
            )
          : ValidationSuccess(value);
    });

    return this;
  }

  /// Validates that the field has a maximum length.
  ///
  /// Converts the value to string and checks if its length is no more than [maxLength].
  ValidationBuilder<T> maxLength(int maxLength) {
    _validators.add((value) {
      final stringValue = value.toString();

      return stringValue.length > maxLength
          ? ValidationFailure(
              '$fieldName must be no more than $maxLength characters',
            )
          : ValidationSuccess(value);
    });

    return this;
  }

  /// Validates that the field matches a regular expression pattern.
  ///
  /// Converts the value to string and checks if it matches the given [pattern].
  /// [description] is used in the error message to describe what the pattern represents.
  ValidationBuilder<T> pattern(RegExp pattern, String description) {
    _validators.add((value) {
      final stringValue = value.toString();

      return !pattern.hasMatch(stringValue)
          ? ValidationFailure('$fieldName must match pattern: $description')
          : ValidationSuccess(value);
    });

    return this;
  }

  /// Validates that the field is a valid email address.
  ///
  /// Uses a basic email regex pattern to validate email format.
  ValidationBuilder<T> email() {
    return pattern(RegExp(r'^[^@]+@[^@]+\.[^@]+$'), 'valid email format');
  }

  /// Validates that the field is a valid URL.
  ///
  /// Uses a basic URL regex pattern to validate URL format.
  ValidationBuilder<T> url() {
    return pattern(RegExp(r'^https?://.*'), 'valid URL format');
  }

  /// Validates that the field is a valid phone number.
  ///
  /// Uses a basic phone regex pattern that accepts various formats.
  ValidationBuilder<T> phone() {
    return pattern(
      RegExp(r'^[\+]?[1-9][\d]{0,15}$'),
      'valid phone number format',
    );
  }

  /// Validates that the field is greater than a minimum value.
  ///
  /// Attempts to parse the value as a number and checks if it's greater than [min].
  ValidationBuilder<T> min(num min) {
    _validators.add((value) {
      final numValue = num.tryParse(value.toString());
      if (numValue == null) {
        return ValidationFailure('$fieldName must be a number');
      }

      return numValue < min
          ? ValidationFailure('$fieldName must be at least $min')
          : ValidationSuccess(value);
    });

    return this;
  }

  /// Validates that the field is less than a maximum value.
  ///
  /// Attempts to parse the value as a number and checks if it's less than [max].
  ValidationBuilder<T> max(num max) {
    _validators.add((value) {
      final numValue = num.tryParse(value.toString());
      if (numValue == null) {
        return ValidationFailure('$fieldName must be a number');
      }

      return numValue > max
          ? ValidationFailure('$fieldName must be no more than $max')
          : ValidationSuccess(value);
    });

    return this;
  }

  /// Validates that the field is within a range.
  ///
  /// Attempts to parse the value as a number and checks if it's between [min] and [max] (inclusive).
  ValidationBuilder<T> inRange(num min, num max) {
    _validators.add((value) {
      final numValue = num.tryParse(value.toString());
      if (numValue == null) {
        return ValidationFailure('$fieldName must be a number');
      }

      return numValue < min || numValue > max
          ? ValidationFailure('$fieldName must be between $min and $max')
          : ValidationSuccess(value);
    });

    return this;
  }

  /// Validates that the field is positive (greater than 0).
  ValidationBuilder<T> positive() => min(0.1);

  /// Validates that the field is negative (less than 0).
  ValidationBuilder<T> negative() => max(-0.1);

  /// Validates that the field is non-negative (greater than or equal to 0).
  ValidationBuilder<T> nonNegative() => min(0);

  /// Validates that the field is not null.
  ///
  /// This method is only available for nullable types.
  ValidationBuilder<T?> nonNull() {
    _validators.add(
      (value) => value == null
          ? ValidationFailure('$fieldName cannot be null')
          : ValidationSuccess(value),
    );

    return this as ValidationBuilder<T?>;
  }

  /// Validates that the field is not null and not empty.
  ///
  /// This method is only available for nullable types.
  ValidationBuilder<T?> nonNullOrEmpty() {
    _validators.add((value) {
      if (value == null) return ValidationFailure('$fieldName cannot be null');
      if (value is String && value.isEmpty) {
        return ValidationFailure('$fieldName cannot be empty');
      }

      return ValidationSuccess(value);
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
  /// This allows you to create custom async validation logic that integrates with the fluent API.
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
  ValidationBuilder<T> customAsync(AsyncValidator<T> validator) {
    _asyncValidators.add(validator);

    return this;
  }

  /// Executes all validators and throws a [ValidationError] if validation fails.
  ///
  /// Throws a [ValidationError] if any validation fails,
  /// or returns the original value if all validations pass.
  ///
  /// This method is useful for users who prefer traditional exception handling.
  ///
  /// Note: This method only executes synchronous validators. Use [validateAsync]
  /// if you have async validators.
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

  /// Executes all validators and returns the result as an [Either].
  ///
  /// Returns [Either.left] with a [ValidationError] if any validation fails,
  /// or [Either.right] with the original value if all validations pass.
  ///
  /// This is useful for synchronous validation scenarios with fpdart.
  ///
  /// Note: This method only executes synchronous validators. Use [validateTask]
  /// if you have async validators.
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
  /// This is useful for asynchronous validation scenarios with fpdart.
  TaskEither<ValidationError, T> validateTask() => TaskEither.tryCatch(
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
