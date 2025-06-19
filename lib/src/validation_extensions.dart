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
extension ValidationBuilderListExtension on List<ValidationBuilder> {
  /// Validates all validation builders in this list.
  ///
  /// Returns [TaskEither.left] with the first [ValidationError] encountered,
  /// or [TaskEither.right] with a list of all validated values if all validations pass.
  ///
  /// This method stops at the first validation failure and returns that error.
  TaskEither<ValidationError, List<dynamic>> validate() {
    return TaskEither(() async {
      final results = <dynamic>[];

      for (final builder in this) {
        final result = await builder.validate().run();
        if (result.isLeft()) {
          return Either.left(result.getLeft().toNullable()!);
        }
        results.add(result.getRight().toNullable());
      }

      return Either.right(results);
    });
  }

  /// Validates all validation builders in this list synchronously.
  ///
  /// Returns [Either.left] with the first [ValidationError] encountered,
  /// or [Either.right] with a list of all validated values if all validations pass.
  ///
  /// This method stops at the first validation failure and returns that error.
  Either<ValidationError, List<dynamic>> validateSync() {
    final results = <dynamic>[];

    for (final builder in this) {
      final result = builder.validateSync();
      if (result.isLeft()) {
        return Either.left(result.getLeft().toNullable()!);
      }
      results.add(result.getRight().toNullable());
    }

    return Either.right(results);
  }
}
