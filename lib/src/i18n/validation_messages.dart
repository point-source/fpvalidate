/// Abstract interface for validation messages that can be implemented by users
/// to provide custom translations or message formatting.
///
/// This interface defines all the validation messages used throughout the package.
/// Users can implement this interface to provide custom messages, or use the
/// [ValidationMessagesMixin] to override only specific messages while keeping
/// the default English implementation for the rest.
///
/// Example:
/// ```dart
/// class CustomValidationMessages implements ValidationMessages {
///   @override
///   String emptyField(String fieldName) => 'The $fieldName field cannot be empty';
///
///   @override
///   String invalidEmail(String fieldName) => 'Please enter a valid email for $fieldName';
///
///   // ... implement all other methods
/// }
/// ```
abstract class ValidationMessages {
  // String validation messages
  String emptyField(String fieldName);
  String minLength(String fieldName, int length);
  String maxLength(String fieldName, int length);
  String invalidEmail(String fieldName);
  String invalidUrl(String fieldName);
  String invalidPhone(String fieldName);
  String invalidPattern(String fieldName, String description);
  String missingSubstring(String fieldName, String substring);
  String invalidPrefix(String fieldName, String prefix);
  String invalidSuffix(String fieldName, String suffix);
  String invalidAlphanumeric(String fieldName);
  String invalidLettersOnly(String fieldName);
  String invalidDigitsOnly(String fieldName);
  String invalidUuid(String fieldName);
  String invalidCreditCard(String fieldName);
  String invalidPostalCode(String fieldName);
  String invalidIsoDate(String fieldName);
  String invalidDate(String fieldName);
  String invalidTime24Hour(String fieldName);
  String invalidTime24HourStrict(String fieldName);
  String invalidAllowedValue(String fieldName, List<String> allowedValues);
  String invalidForbiddenValue(String fieldName, List<String> forbiddenValues);
  String invalidNumberFormat(String fieldName, String value);

  // Numeric validation messages
  String invalidMinValue(String fieldName, num value, num min);
  String invalidMaxValue(String fieldName, num value, num max);
  String invalidEvenNumber(String fieldName, num value);
  String invalidOddNumber(String fieldName, num value);
  String invalidPositiveNumber(String fieldName);
  String invalidNonNegativeNumber(String fieldName);
  String invalidNegativeNumber(String fieldName);
  String invalidNonPositiveNumber(String fieldName);
  String invalidInteger(String fieldName);
  String invalidPowerOfTwo(String fieldName);
  String invalidPortNumber(String fieldName);
  String invalidPercentageRange(
    String fieldName,
    double percentage,
    num target,
  );
  String invalidRange(String fieldName, num value, num min, num max);
  String invalidAllowedNumericValue(String fieldName, List<num> allowedValues);
  String invalidForbiddenNumericValue(
    String fieldName,
    List<num> forbiddenValues,
  );

  // Nullable validation messages
  String nullField(String fieldName);

  // Dynamic validation messages
  String typeMismatch(String fieldName, Type expectedType);
}
