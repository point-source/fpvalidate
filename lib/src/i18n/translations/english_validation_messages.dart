import '../validation_messages.dart';

/// Default English implementation of [ValidationMessages].
///
/// This class provides the standard English validation messages used by the package.
/// It serves as the fallback implementation and can be used as a reference for
/// creating custom message implementations.
class EnglishValidationMessages implements ValidationMessages {
  const EnglishValidationMessages();

  @override
  String emptyField(String fieldName) => 'Field $fieldName is empty';

  @override
  String minLength(String fieldName, int length) =>
      '$fieldName must be at least $length characters long';

  @override
  String maxLength(String fieldName, int length) =>
      '$fieldName must be no more than $length characters long';

  @override
  String invalidEmail(String fieldName) =>
      '$fieldName must be a valid email address';

  @override
  String invalidUrl(String fieldName) => '$fieldName must be a valid URL';

  @override
  String invalidPhone(String fieldName) =>
      '$fieldName must be a valid phone number';

  @override
  String invalidPattern(String fieldName, String description) =>
      '$fieldName must match pattern: $description';

  @override
  String missingSubstring(String fieldName, String substring) =>
      '$fieldName must contain "$substring"';

  @override
  String invalidPrefix(String fieldName, String prefix) =>
      '$fieldName must start with "$prefix"';

  @override
  String invalidSuffix(String fieldName, String suffix) =>
      '$fieldName must end with "$suffix"';

  @override
  String invalidAlphanumeric(String fieldName) =>
      '$fieldName must contain only alphanumeric characters';

  @override
  String invalidLettersOnly(String fieldName) =>
      '$fieldName must contain only letters';

  @override
  String invalidDigitsOnly(String fieldName) =>
      '$fieldName must contain only digits';

  @override
  String invalidUuid(String fieldName) => '$fieldName must be a valid UUID';

  @override
  String invalidCreditCard(String fieldName) =>
      '$fieldName must be a valid credit card number';

  @override
  String invalidPostalCode(String fieldName) =>
      '$fieldName must be a valid postal code';

  @override
  String invalidIsoDate(String fieldName) =>
      '$fieldName must be in ISO date format (YYYY-MM-DD)';

  @override
  String invalidDate(String fieldName) => '$fieldName must be a valid date';

  @override
  String invalidTime24Hour(String fieldName) =>
      '$fieldName must be in 24-hour format (HH:MM)';

  @override
  String invalidTime24HourStrict(String fieldName) =>
      '$fieldName must be in 24-hour format (HH:MM) with leading zeros';

  @override
  String invalidAllowedValue(String fieldName, List<String> allowedValues) =>
      '$fieldName must be one of: ${allowedValues.join(', ')}';

  @override
  String invalidForbiddenValue(
    String fieldName,
    List<String> forbiddenValues,
  ) => '$fieldName must not be one of: ${forbiddenValues.join(', ')}';

  @override
  String invalidNumberFormat(String fieldName, String value) =>
      'Value $value for field $fieldName is not a number';

  @override
  String invalidMinValue(String fieldName, num value, num min) =>
      'Value $value of field $fieldName must be greater than or equal to $min';

  @override
  String invalidMaxValue(String fieldName, num value, num max) =>
      'Value $value of field $fieldName must be less than or equal to $max';

  @override
  String invalidEvenNumber(String fieldName, num value) =>
      'Value $value of field $fieldName must be even';

  @override
  String invalidOddNumber(String fieldName, num value) =>
      'Value $value of field $fieldName must be odd';

  @override
  String invalidPositiveNumber(String fieldName) =>
      '$fieldName must be positive';

  @override
  String invalidNonNegativeNumber(String fieldName) =>
      '$fieldName must be non-negative';

  @override
  String invalidNegativeNumber(String fieldName) =>
      '$fieldName must be negative';

  @override
  String invalidNonPositiveNumber(String fieldName) =>
      '$fieldName must be non-positive';

  @override
  String invalidInteger(String fieldName) => '$fieldName must be an integer';

  @override
  String invalidPowerOfTwo(String fieldName) =>
      '$fieldName must be a power of 2';

  @override
  String invalidPortNumber(String fieldName) =>
      '$fieldName must be a valid port number (1-65535)';

  @override
  String invalidPercentageRange(
    String fieldName,
    double percentage,
    num target,
  ) => '$fieldName must be within $percentage% of $target';

  @override
  String invalidRange(String fieldName, num value, num min, num max) =>
      'Value $value of field $fieldName must be between $min and $max';

  @override
  String invalidAllowedNumericValue(
    String fieldName,
    List<num> allowedValues,
  ) => '$fieldName must be one of: ${allowedValues.join(', ')}';

  @override
  String invalidForbiddenNumericValue(
    String fieldName,
    List<num> forbiddenValues,
  ) => '$fieldName must not be one of: ${forbiddenValues.join(', ')}';

  @override
  String nullField(String fieldName) => 'Field $fieldName is null';
}
