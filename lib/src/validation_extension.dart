import 'package:fpdart/fpdart.dart';
import 'validation_builder.dart';
import 'validation_error.dart';

/// Extension that provides the fluent API for starting validation chains.
///
/// This extension adds the [field] method to any type, allowing you to start
/// a validation chain by specifying the field name for error messages.
///
/// Example:
/// ```dart
/// final result = email
///     .field('Email')
///     .notEmpty()
///     .email()
///     .validate();
/// ```
extension ValidationExtension<T> on T {
  /// Starts a validation chain for this value.
  ///
  /// [fieldName] is the name of the field that will be used in error messages.
  /// Returns a [ValidationBuilder] that can be used to chain validation rules.
  ValidationBuilder<T> field(String fieldName) =>
      ValidationBuilder(this, fieldName);
}

/// Extension that provides the fluent API for starting validation chains on nullable types.
///
/// This extension adds the [field] method to nullable types, allowing you to start
/// a validation chain by specifying the field name for error messages.
///
/// Example:
/// ```dart
/// final result = optionalField
///     .field('Optional Field')
///     .nonNull()
///     .notEmpty()
///     .validate();
/// ```
extension NullableValidationExtension<T> on T? {
  /// Starts a validation chain for this nullable value.
  ///
  /// [fieldName] is the name of the field that will be used in error messages.
  /// Returns a [ValidationBuilder] that can be used to chain validation rules.
  ValidationBuilder<T?> field(String fieldName) =>
      ValidationBuilder(this, fieldName);
}

/// Extension that provides validation for lists of ValidationBuilder objects.
///
/// This extension allows you to validate multiple fields at once by collecting
/// them in a list and calling [validate] on the list.
///
/// Example:
/// ```dart
/// final result = [
///   email.field('Email').notEmpty().email(),
///   password.field('Password').notEmpty().minLength(8),
///   age.field('Age').min(13).max(120),
/// ].validate()
/// .mapLeft((error) => CustomError(error.message));
/// ```
extension ValidationBuilderListExtension<T> on List<ValidationBuilder<T>> {
  /// Validates all validation builders in this list synchronously.
  ///
  /// Throws a [ValidationError] if any validation fails,
  /// or returns a list of all validated values if all validations pass.
  ///
  /// This method stops at the first validation failure and throws that error.
  ///
  /// Note: This method only works with synchronous validators. If any builder
  /// contains async validators, use [validateAsync] instead.
  List<T> validate() {
    final results = <T>[];

    for (final builder in this) {
      try {
        final result = builder.validate();
        results.add(result);
      } catch (e, stackTrace) {
        if (e is ValidationError) {
          rethrow;
        }
        throw ValidationError(
          'Unknown validation error',
          e.toString(),
          stackTrace,
        );
      }
    }

    return results;
  }

  /// Validates all validation builders in this list asynchronously.
  ///
  /// Throws a [ValidationError] if any validation fails,
  /// or returns a list of all validated values if all validations pass.
  ///
  /// This method stops at the first validation failure and throws that error.
  Future<List<T>> validateAsync() async {
    final results = <T>[];

    for (final builder in this) {
      try {
        final result = await builder.validateAsync();
        results.add(result);
      } catch (e, stackTrace) {
        if (e is ValidationError) {
          rethrow;
        }
        throw ValidationError(
          'Unknown validation error',
          e.toString(),
          stackTrace,
        );
      }
    }

    return results;
  }

  /// Validates all validation builders in this list synchronously.
  ///
  /// Returns [Either.left] with the first [ValidationError] encountered,
  /// or [Either.right] with a list of all validated values if all validations pass.
  ///
  /// This method stops at the first validation failure and returns that error.
  ///
  /// Note: This method only works with synchronous validators. If any builder
  /// contains async validators, use [validateTask] instead.
  Either<ValidationError, List<T>> validateEither() => Either.tryCatch(
    () => validate(),
    (e, stackTrace) => e is ValidationError
        ? e
        : ValidationError('Unknown validation error', e.toString(), stackTrace),
  );

  /// Validates all validation builders in this list asynchronously.
  ///
  /// Returns [TaskEither.left] with the first [ValidationError] encountered,
  /// or [TaskEither.right] with a list of all validated values if all validations pass.
  ///
  /// This method stops at the first validation failure and returns that error.
  TaskEither<ValidationError, List<T>> validateTask() => TaskEither.tryCatch(
    () async => await validateAsync(),
    (e, stackTrace) => e is ValidationError
        ? e
        : ValidationError('Unknown validation error', e.toString(), stackTrace),
  );
}
