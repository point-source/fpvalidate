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

  @override
  EmptyStringValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidEmailValidationError extends StringValidationError {
  const InvalidEmailValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidEmailValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidUrlValidationError extends StringValidationError {
  const InvalidUrlValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidUrlValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidPhoneValidationError extends StringValidationError {
  const InvalidPhoneValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidPhoneValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidPatternValidationError extends StringValidationError {
  const InvalidPatternValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidPatternValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class MissingSubstringValidationError extends StringValidationError {
  const MissingSubstringValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  MissingSubstringValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidPrefixValidationError extends StringValidationError {
  const InvalidPrefixValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidPrefixValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidSuffixValidationError extends StringValidationError {
  const InvalidSuffixValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidSuffixValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidAlphanumericValidationError extends StringValidationError {
  const InvalidAlphanumericValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidAlphanumericValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidLettersOnlyValidationError extends StringValidationError {
  const InvalidLettersOnlyValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidLettersOnlyValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidDigitsOnlyValidationError extends StringValidationError {
  const InvalidDigitsOnlyValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidDigitsOnlyValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidUuidValidationError extends StringValidationError {
  const InvalidUuidValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidUuidValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidCreditCardValidationError extends StringValidationError {
  const InvalidCreditCardValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidCreditCardValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidPostalCodeValidationError extends StringValidationError {
  const InvalidPostalCodeValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidPostalCodeValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidIsoDateValidationError extends StringValidationError {
  const InvalidIsoDateValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidIsoDateValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidTime24HourValidationError extends StringValidationError {
  const InvalidTime24HourValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidTime24HourValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidAllowedValueValidationError extends StringValidationError {
  const InvalidAllowedValueValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidAllowedValueValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidForbiddenValueValidationError extends StringValidationError {
  const InvalidForbiddenValueValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidForbiddenValueValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidLengthValidationError extends StringValidationError {
  const InvalidLengthValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidLengthValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}

class InvalidNumberFormatValidationError extends StringValidationError {
  const InvalidNumberFormatValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);

  @override
  InvalidNumberFormatValidationError copyWith({String? message}) =>
      .new(fieldName, message ?? this.message, stackTrace);
}
