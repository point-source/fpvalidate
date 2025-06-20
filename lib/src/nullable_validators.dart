import 'package:fpvalidate/src/validation_result.dart';

import 'validation_builder.dart';

/// Common nullable validation functions that can be used with the [custom] method.
///
/// These functions provide reusable validation logic that can be applied
/// to nullable fields using the fluent API.
///
/// Example:
/// ```dart
/// final result = optionalField
///     .field('Optional Field')
///     .custom(NullableValidators.ifPresent(StringValidators.notEmpty()))
///     .validate();
/// ```
class NullableValidators {
  /// Validates a nullable value only if it is present (not null).
  ///
  /// [validator] is the validator to apply if the value is not null.
  /// Returns a validator function that can be used with the [custom] method.
  ///
  /// If the value is null, validation passes. If the value is not null,
  /// the provided validator is applied to it.
  static Validator<T?> ifPresent<T>(Validator<T> validator) => (value) {
    if (value == null) {
      return ValidationSuccess(value);
    }

    return validator(value);
  };

  /// Validates that a nullable value is either null or passes the given validator.
  ///
  /// [validator] is the validator to apply if the value is not null.
  /// Returns a validator function that can be used with the [custom] method.
  ///
  /// This is similar to [ifPresent] but more explicit about the intent.
  static Validator<T?> optional<T>(Validator<T> validator) =>
      ifPresent(validator);

  /// Validates that a nullable value is not null and passes the given validator.
  ///
  /// [validator] is the validator to apply to the non-null value.
  /// Returns a validator function that can be used with the [custom] method.
  ///
  /// If the value is null, validation fails. If the value is not null,
  /// the provided validator is applied to it.
  static Validator<T?> required<T>(Validator<T> validator) => (value) {
    if (value == null) {
      return ValidationFailure('cannot be null');
    }

    return validator(value);
  };

  /// Validates that a nullable value is either null or not empty.
  ///
  /// Returns a validator function that can be used with the [custom] method.
  ///
  /// This is useful for optional string fields that should not be empty if provided.
  static Validator<String?> optionalNotEmpty() => (value) {
    if (value == null) {
      return ValidationSuccess(value);
    }
    if (value.isEmpty) {
      return ValidationFailure('cannot be empty if provided');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a nullable value is either null or a valid email.
  ///
  /// Returns a validator function that can be used with the [custom] method.
  ///
  /// This is useful for optional email fields.
  static Validator<String?> optionalEmail() => (value) {
    if (value == null) {
      return ValidationSuccess(value);
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
      return ValidationFailure('must be a valid email format if provided');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a nullable value is either null or a valid URL.
  ///
  /// Returns a validator function that can be used with the [custom] method.
  ///
  /// This is useful for optional URL fields.
  static Validator<String?> optionalUrl() => (value) {
    if (value == null) {
      return ValidationSuccess(value);
    }
    if (!RegExp(r'^https?://.*').hasMatch(value)) {
      return ValidationFailure('must be a valid URL format if provided');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a nullable value is either null or a valid phone number.
  ///
  /// Returns a validator function that can be used with the [custom] method.
  ///
  /// This is useful for optional phone number fields.
  static Validator<String?> optionalPhone() => (value) {
    if (value == null) {
      return ValidationSuccess(value);
    }
    if (!RegExp(r'^[\+]?[1-9][\d]{0,15}$').hasMatch(value)) {
      return ValidationFailure(
        'must be a valid phone number format if provided',
      );
    }

    return ValidationSuccess(value);
  };

  /// Validates that a nullable numeric value is either null or within a range.
  ///
  /// [min] is the minimum value (inclusive).
  /// [max] is the maximum value (inclusive).
  /// Returns a validator function that can be used with the [custom] method.
  ///
  /// This is useful for optional numeric fields that should be within a range if provided.
  static Validator<num?> optionalInRange(num min, num max) => (value) {
    if (value == null) {
      return ValidationSuccess(value);
    }
    if (value < min || value > max) {
      return ValidationFailure('must be between $min and $max if provided');
    }

    return ValidationSuccess(value);
  };

  /// Validates that a nullable value is either null or has a minimum length.
  ///
  /// [minLength] is the minimum length required.
  /// Returns a validator function that can be used with the [custom] method.
  ///
  /// This is useful for optional string fields that should have a minimum length if provided.
  static Validator<String?> optionalMinLength(int minLength) => (value) {
    if (value == null) {
      return ValidationSuccess(value);
    }
    if (value.length < minLength) {
      return ValidationFailure(
        'must be at least $minLength characters if provided',
      );
    }

    return ValidationSuccess(value);
  };

  /// Validates that a nullable value is either null or has a maximum length.
  ///
  /// [maxLength] is the maximum length allowed.
  /// Returns a validator function that can be used with the [custom] method.
  ///
  /// This is useful for optional string fields that should have a maximum length if provided.
  static Validator<String?> optionalMaxLength(int maxLength) => (value) {
    if (value == null) {
      return ValidationSuccess(value);
    }
    if (value.length > maxLength) {
      return ValidationFailure(
        'must be no more than $maxLength characters if provided',
      );
    }

    return ValidationSuccess(value);
  };
}
