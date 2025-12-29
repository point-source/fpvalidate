import '../validation_messages.dart';

/// Default English implementation of [ValidationMessages].
///
/// This class provides the standard English validation messages used by the package.
/// It serves as the fallback implementation and can be used as a reference for
/// creating custom message implementations.
///
/// When [fieldName] is empty, messages use "Value" as a generic placeholder.
class EnglishValidationMessages implements ValidationMessages {
  const EnglishValidationMessages();

  /// Helper to get display name - uses "Value" when fieldName is empty.
  String _displayName(String fieldName) =>
      fieldName.isEmpty ? 'Value' : fieldName;

  @override
  String emptyField(String fieldName) =>
      '${_displayName(fieldName)} cannot be empty';

  @override
  String minLength(String fieldName, int length) =>
      '${_displayName(fieldName)} must be at least $length characters long';

  @override
  String maxLength(String fieldName, int length) =>
      '${_displayName(fieldName)} must be no more than $length characters long';

  @override
  String invalidEmail(String fieldName) =>
      '${_displayName(fieldName)} must be a valid email address';

  @override
  String invalidUrl(String fieldName) =>
      '${_displayName(fieldName)} must be a valid URL';

  @override
  String invalidPhone(String fieldName) =>
      '${_displayName(fieldName)} must be a valid phone number';

  @override
  String invalidPattern(String fieldName, String description) =>
      '${_displayName(fieldName)} must match pattern: $description';

  @override
  String missingSubstring(String fieldName, String substring) =>
      '${_displayName(fieldName)} must contain "$substring"';

  @override
  String invalidPrefix(String fieldName, String prefix) =>
      '${_displayName(fieldName)} must start with "$prefix"';

  @override
  String invalidSuffix(String fieldName, String suffix) =>
      '${_displayName(fieldName)} must end with "$suffix"';

  @override
  String invalidAlphanumeric(String fieldName) =>
      '${_displayName(fieldName)} must contain only alphanumeric characters';

  @override
  String invalidLettersOnly(String fieldName) =>
      '${_displayName(fieldName)} must contain only letters';

  @override
  String invalidDigitsOnly(String fieldName) =>
      '${_displayName(fieldName)} must contain only digits';

  @override
  String invalidUuid(String fieldName) =>
      '${_displayName(fieldName)} must be a valid UUID';

  @override
  String invalidCreditCard(String fieldName) =>
      '${_displayName(fieldName)} must be a valid credit card number';

  @override
  String invalidPostalCode(String fieldName) =>
      '${_displayName(fieldName)} must be a valid postal code';

  @override
  String invalidIsoDate(String fieldName) =>
      '${_displayName(fieldName)} must be in ISO date format (YYYY-MM-DD)';

  @override
  String invalidDate(String fieldName) =>
      '${_displayName(fieldName)} must be a valid date';

  @override
  String invalidTime24Hour(String fieldName) =>
      '${_displayName(fieldName)} must be in 24-hour format (HH:MM)';

  @override
  String invalidTime24HourStrict(String fieldName) =>
      '${_displayName(fieldName)} must be in 24-hour format (HH:MM) with leading zeros';

  @override
  String invalidAllowedValue(String fieldName, List<String> allowedValues) =>
      '${_displayName(fieldName)} must be one of: ${allowedValues.join(', ')}';

  @override
  String invalidForbiddenValue(
    String fieldName,
    List<String> forbiddenValues,
  ) =>
      '${_displayName(fieldName)} must not be one of: ${forbiddenValues.join(', ')}';

  @override
  String invalidNumberFormat(String fieldName, String value) =>
      '"$value" is not a valid number${fieldName.isEmpty ? '' : ' for ${_displayName(fieldName)}'}';

  @override
  String invalidMinValue(String fieldName, num value, num min) =>
      '${_displayName(fieldName)} must be at least $min (got $value)';

  @override
  String invalidMaxValue(String fieldName, num value, num max) =>
      '${_displayName(fieldName)} must be at most $max (got $value)';

  @override
  String invalidEvenNumber(String fieldName, num value) =>
      '${_displayName(fieldName)} must be even (got $value)';

  @override
  String invalidOddNumber(String fieldName, num value) =>
      '${_displayName(fieldName)} must be odd (got $value)';

  @override
  String invalidPositiveNumber(String fieldName) =>
      '${_displayName(fieldName)} must be positive';

  @override
  String invalidNonNegativeNumber(String fieldName) =>
      '${_displayName(fieldName)} must be non-negative';

  @override
  String invalidNegativeNumber(String fieldName) =>
      '${_displayName(fieldName)} must be negative';

  @override
  String invalidNonPositiveNumber(String fieldName) =>
      '${_displayName(fieldName)} must be non-positive';

  @override
  String invalidInteger(String fieldName) =>
      '${_displayName(fieldName)} must be an integer';

  @override
  String invalidPowerOfTwo(String fieldName) =>
      '${_displayName(fieldName)} must be a power of 2';

  @override
  String invalidPortNumber(String fieldName) =>
      '${_displayName(fieldName)} must be a valid port number (1-65535)';

  @override
  String invalidPercentageRange(
    String fieldName,
    double percentage,
    num target,
  ) => '${_displayName(fieldName)} must be within $percentage% of $target';

  @override
  String invalidRange(String fieldName, num value, num min, num max) =>
      '${_displayName(fieldName)} must be between $min and $max (got $value)';

  @override
  String invalidAllowedNumericValue(
    String fieldName,
    List<num> allowedValues,
  ) => '${_displayName(fieldName)} must be one of: ${allowedValues.join(', ')}';

  @override
  String invalidForbiddenNumericValue(
    String fieldName,
    List<num> forbiddenValues,
  ) =>
      '${_displayName(fieldName)} must not be one of: ${forbiddenValues.join(', ')}';

  @override
  String nullField(String fieldName) =>
      '${_displayName(fieldName)} cannot be null';

  @override
  String typeMismatch(String fieldName, Type expectedType) =>
      '${_displayName(fieldName)} must be of type $expectedType';
}
