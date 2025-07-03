part of 'validation_error.dart';

sealed class StringValidationError extends ValidationError {
  const StringValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class EmptyStringValidationError extends StringValidationError {
  const EmptyStringValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidEmailValidationError extends StringValidationError {
  const InvalidEmailValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidUrlValidationError extends StringValidationError {
  const InvalidUrlValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidPhoneValidationError extends StringValidationError {
  const InvalidPhoneValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidPatternValidationError extends StringValidationError {
  const InvalidPatternValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class MissingSubstringValidationError extends StringValidationError {
  const MissingSubstringValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidPrefixValidationError extends StringValidationError {
  const InvalidPrefixValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidSuffixValidationError extends StringValidationError {
  const InvalidSuffixValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidAlphanumericValidationError extends StringValidationError {
  const InvalidAlphanumericValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidLettersOnlyValidationError extends StringValidationError {
  const InvalidLettersOnlyValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidDigitsOnlyValidationError extends StringValidationError {
  const InvalidDigitsOnlyValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidUuidValidationError extends StringValidationError {
  const InvalidUuidValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidCreditCardValidationError extends StringValidationError {
  const InvalidCreditCardValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidPostalCodeValidationError extends StringValidationError {
  const InvalidPostalCodeValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidIsoDateValidationError extends StringValidationError {
  const InvalidIsoDateValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidTime24HourValidationError extends StringValidationError {
  const InvalidTime24HourValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidAllowedValueValidationError extends StringValidationError {
  const InvalidAllowedValueValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidForbiddenValueValidationError extends StringValidationError {
  const InvalidForbiddenValueValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidLengthValidationError extends StringValidationError {
  const InvalidLengthValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class InvalidNumberFormatValidationError extends StringValidationError {
  const InvalidNumberFormatValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}
