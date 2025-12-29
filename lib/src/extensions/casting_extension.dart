part of '../validation_step.dart';

/// Extension methods for validating and casting values
///
/// This extension provides type validation and casting capabilities for
/// `SyncValidationStep<dynamic>` values, allowing you to safely convert
/// dynamic values to specific types while maintaining the validation chain.
///
/// Example:
/// ```dart
/// // Validate and cast a dynamic value to a specific type
/// final Object? value = 42;
/// final result = value
///     .trust('Number')
///     .isType<int>()
///     .min(0)
///     .max(100)
///     .verify();
///
/// // Handle type mismatch
/// final Object? stringValue = 'not a number';
/// final error = stringValue
///     .trust('Value')
///     .isType<int>()
///     .verify();
/// // Throws: TypeMismatchValidationError('Value', 'Value must be of type int')
/// ```
extension CastingExtension on SyncValidationStep {
  /// Validates that the value is of type [T] and casts it to that type.
  ///
  /// This method performs a runtime type check and casts the value to the
  /// specified type [T]. If the value is not of type [T], it returns a
  /// [TypeMismatchValidationError].
  ///
  /// After successful type validation, the returned `SyncValidationStep<T>`
  /// allows you to chain type-specific validators (e.g., numeric validators
  /// for `int` or `double`, string validators for `String`).
  ///
  /// Example:
  /// ```dart
  /// // Cast dynamic to int and apply numeric validators
  /// final Object? value = 42;
  /// final result = value
  ///     .trust('Age')
  ///     .isType<int>()
  ///     .min(18)
  ///     .max(65)
  ///     .verify();
  ///
  /// // Cast dynamic to String and apply string validators
  /// final Object? email = 'user@example.com';
  /// final emailResult = email
  ///     .trust('Email')
  ///     .isType<String>()
  ///     .isNotEmpty()
  ///     .isEmail()
  ///     .verify();
  /// ```
  ///
  /// Returns a [SyncValidationStep<T>] that can be used to chain additional
  /// type-specific validators.
  SyncValidationStep<T> isType<T>() => bind(
    (value) => value is T
        ? pass<T>(value)
        : fail<T>(
            TypeMismatchValidationError.new,
            ValidationI18n.messages.typeMismatch(fieldName, T),
          ),
  );
}
