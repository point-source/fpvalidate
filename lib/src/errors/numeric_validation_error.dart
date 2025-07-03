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
}

class InvalidMaxValueValidationError extends NumericValidationError {
  const InvalidMaxValueValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidEvenNumberValidationError extends NumericValidationError {
  const InvalidEvenNumberValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidOddNumberValidationError extends NumericValidationError {
  const InvalidOddNumberValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidPositiveNumberValidationError extends NumericValidationError {
  const InvalidPositiveNumberValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidNonNegativeNumberValidationError extends NumericValidationError {
  const InvalidNonNegativeNumberValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidNegativeNumberValidationError extends NumericValidationError {
  const InvalidNegativeNumberValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidNonPositiveNumberValidationError extends NumericValidationError {
  const InvalidNonPositiveNumberValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidIntegerValidationError extends NumericValidationError {
  const InvalidIntegerValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidPowerOfTwoValidationError extends NumericValidationError {
  const InvalidPowerOfTwoValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidPortNumberValidationError extends NumericValidationError {
  const InvalidPortNumberValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidPercentageRangeValidationError extends NumericValidationError {
  const InvalidPercentageRangeValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidRangeValidationError extends NumericValidationError {
  const InvalidRangeValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidAllowedNumericValueValidationError extends NumericValidationError {
  const InvalidAllowedNumericValueValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidForbiddenNumericValueValidationError
    extends NumericValidationError {
  const InvalidForbiddenNumericValueValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}
