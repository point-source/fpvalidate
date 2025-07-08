import 'translations/english_validation_messages.dart';
import 'validation_messages.dart';

/// A mixin that provides default implementations for all [ValidationMessages] methods.
///
/// This mixin allows users to override only the specific messages they want to customize
/// while keeping the default English implementation for all other messages.
///
/// Example:
/// ```dart
/// class CustomValidationMessages with ValidationMessagesMixin {
///   @override
///   String emptyField(String fieldName) => 'The $fieldName field cannot be empty';
///
///   @override
///   String invalidEmail(String fieldName) => 'Please enter a valid email for $fieldName';
///
///   // All other methods will use the default English implementation
/// }
/// ```
mixin ValidationMessagesMixin implements ValidationMessages {
  ValidationMessages get _defaultMessages => EnglishValidationMessages();

  // String validation messages
  @override
  String emptyField(String fieldName) => _defaultMessages.emptyField(fieldName);

  @override
  String minLength(String fieldName, int length) =>
      _defaultMessages.minLength(fieldName, length);

  @override
  String maxLength(String fieldName, int length) =>
      _defaultMessages.maxLength(fieldName, length);

  @override
  String invalidEmail(String fieldName) =>
      _defaultMessages.invalidEmail(fieldName);

  @override
  String invalidUrl(String fieldName) => _defaultMessages.invalidUrl(fieldName);

  @override
  String invalidPhone(String fieldName) =>
      _defaultMessages.invalidPhone(fieldName);

  @override
  String invalidPattern(String fieldName, String description) =>
      _defaultMessages.invalidPattern(fieldName, description);

  @override
  String missingSubstring(String fieldName, String substring) =>
      _defaultMessages.missingSubstring(fieldName, substring);

  @override
  String invalidPrefix(String fieldName, String prefix) =>
      _defaultMessages.invalidPrefix(fieldName, prefix);

  @override
  String invalidSuffix(String fieldName, String suffix) =>
      _defaultMessages.invalidSuffix(fieldName, suffix);

  @override
  String invalidAlphanumeric(String fieldName) =>
      _defaultMessages.invalidAlphanumeric(fieldName);

  @override
  String invalidLettersOnly(String fieldName) =>
      _defaultMessages.invalidLettersOnly(fieldName);

  @override
  String invalidDigitsOnly(String fieldName) =>
      _defaultMessages.invalidDigitsOnly(fieldName);

  @override
  String invalidUuid(String fieldName) =>
      _defaultMessages.invalidUuid(fieldName);

  @override
  String invalidCreditCard(String fieldName) =>
      _defaultMessages.invalidCreditCard(fieldName);

  @override
  String invalidPostalCode(String fieldName) =>
      _defaultMessages.invalidPostalCode(fieldName);

  @override
  String invalidIsoDate(String fieldName) =>
      _defaultMessages.invalidIsoDate(fieldName);

  @override
  String invalidDate(String fieldName) =>
      _defaultMessages.invalidDate(fieldName);

  @override
  String invalidTime24Hour(String fieldName) =>
      _defaultMessages.invalidTime24Hour(fieldName);

  @override
  String invalidTime24HourStrict(String fieldName) =>
      _defaultMessages.invalidTime24HourStrict(fieldName);

  @override
  String invalidAllowedValue(String fieldName, List<String> allowedValues) =>
      _defaultMessages.invalidAllowedValue(fieldName, allowedValues);

  @override
  String invalidForbiddenValue(
    String fieldName,
    List<String> forbiddenValues,
  ) => _defaultMessages.invalidForbiddenValue(fieldName, forbiddenValues);

  @override
  String invalidNumberFormat(String fieldName, String value) =>
      _defaultMessages.invalidNumberFormat(fieldName, value);

  // Numeric validation messages
  @override
  String invalidMinValue(String fieldName, num value, num min) =>
      _defaultMessages.invalidMinValue(fieldName, value, min);

  @override
  String invalidMaxValue(String fieldName, num value, num max) =>
      _defaultMessages.invalidMaxValue(fieldName, value, max);

  @override
  String invalidEvenNumber(String fieldName, num value) =>
      _defaultMessages.invalidEvenNumber(fieldName, value);

  @override
  String invalidOddNumber(String fieldName, num value) =>
      _defaultMessages.invalidOddNumber(fieldName, value);

  @override
  String invalidPositiveNumber(String fieldName) =>
      _defaultMessages.invalidPositiveNumber(fieldName);

  @override
  String invalidNonNegativeNumber(String fieldName) =>
      _defaultMessages.invalidNonNegativeNumber(fieldName);

  @override
  String invalidNegativeNumber(String fieldName) =>
      _defaultMessages.invalidNegativeNumber(fieldName);

  @override
  String invalidNonPositiveNumber(String fieldName) =>
      _defaultMessages.invalidNonPositiveNumber(fieldName);

  @override
  String invalidInteger(String fieldName) =>
      _defaultMessages.invalidInteger(fieldName);

  @override
  String invalidPowerOfTwo(String fieldName) =>
      _defaultMessages.invalidPowerOfTwo(fieldName);

  @override
  String invalidPortNumber(String fieldName) =>
      _defaultMessages.invalidPortNumber(fieldName);

  @override
  String invalidPercentageRange(
    String fieldName,
    double percentage,
    num target,
  ) => _defaultMessages.invalidPercentageRange(fieldName, percentage, target);

  @override
  String invalidRange(String fieldName, num value, num min, num max) =>
      _defaultMessages.invalidRange(fieldName, value, min, max);

  @override
  String invalidAllowedNumericValue(
    String fieldName,
    List<num> allowedValues,
  ) => _defaultMessages.invalidAllowedNumericValue(fieldName, allowedValues);

  @override
  String invalidForbiddenNumericValue(
    String fieldName,
    List<num> forbiddenValues,
  ) =>
      _defaultMessages.invalidForbiddenNumericValue(fieldName, forbiddenValues);

  // Nullable validation messages
  @override
  String nullField(String fieldName) => _defaultMessages.nullField(fieldName);
}
