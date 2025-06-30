part of '../validation_step.dart';

/// Extension that provides validation methods for nullable values.
///
/// This extension adds validation capabilities to nullable types, allowing you to
/// validate optional fields and convert them to non-nullable types when needed.
///
/// Example:
/// ```dart
/// final result = (someNullableString as String?)
///     .field('Optional String')
///     .isNotNull()
///     .notEmpty()
///     .validateEither();
/// ```
extension NullableExtension<T> on SyncValidationStep<T?> {
  /// Validates that the value is not null and converts it to a non-nullable type.
  ///
  /// This method checks if the current value is null. If it is null, it returns
  /// a [ValidationError]. If it is not null, it returns a new [SyncValidationStep]
  /// with the non-nullable value, enabling further validation with non-nullable
  /// validators.
  ///
  /// This is a type transformation validator that changes the validator type from
  /// [SyncValidationStep<T?>] to [SyncValidationStep<T>], allowing you to chain
  /// validators that expect non-nullable values.
  ///
  /// Returns a [SyncValidationStep<T>] that can be chained with non-nullable validators.
  ///
  /// Example:
  /// ```dart
  /// final result = (optionalEmail as String?)
  ///     .field('Optional Email')
  ///     .isNotNull()          // Converts String? to String
  ///     .notEmpty()           // Now we can use string validators
  ///     .isEmail()
  ///     .validateEither();
  /// ```
  SyncValidationStep<T> isNotNull() => bind(
    (value) =>
        value == null ? fail<T>('Field $fieldName is null') : pass<T>(value),
  );
}
