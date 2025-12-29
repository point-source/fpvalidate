part of 'validation_error.dart';

sealed class NumericValidationError extends ValidationError {
  const NumericValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidMinValueValidationError extends NumericValidationError {
  const InvalidMinValueValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidMinValueValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidMaxValueValidationError extends NumericValidationError {
  const InvalidMaxValueValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidMaxValueValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidEvenNumberValidationError extends NumericValidationError {
  const InvalidEvenNumberValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidEvenNumberValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidOddNumberValidationError extends NumericValidationError {
  const InvalidOddNumberValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidOddNumberValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidPositiveNumberValidationError extends NumericValidationError {
  const InvalidPositiveNumberValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidPositiveNumberValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidNonNegativeNumberValidationError extends NumericValidationError {
  const InvalidNonNegativeNumberValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidNonNegativeNumberValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidNegativeNumberValidationError extends NumericValidationError {
  const InvalidNegativeNumberValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidNegativeNumberValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidNonPositiveNumberValidationError extends NumericValidationError {
  const InvalidNonPositiveNumberValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidNonPositiveNumberValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidIntegerValidationError extends NumericValidationError {
  const InvalidIntegerValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidIntegerValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidPowerOfTwoValidationError extends NumericValidationError {
  const InvalidPowerOfTwoValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidPowerOfTwoValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidPortNumberValidationError extends NumericValidationError {
  const InvalidPortNumberValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidPortNumberValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidPercentageRangeValidationError extends NumericValidationError {
  const InvalidPercentageRangeValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidPercentageRangeValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidRangeValidationError extends NumericValidationError {
  const InvalidRangeValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidRangeValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidAllowedNumericValueValidationError extends NumericValidationError {
  const InvalidAllowedNumericValueValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidAllowedNumericValueValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidForbiddenNumericValueValidationError
    extends NumericValidationError {
  const InvalidForbiddenNumericValueValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidForbiddenNumericValueValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}
