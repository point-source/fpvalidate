// ignore_for_file: newline-before-return

part of '../validation_step.dart';

extension StringExtension on SyncValidationStep<String> {
  SyncValidationStep<String> notEmpty({bool allowWhitespace = false}) => bind(
    (value) => value.isEmpty
        ? _fail('Field $fieldName is empty')
        : !allowWhitespace && value.trim().isEmpty
        ? _fail('Field $fieldName is empty')
        : _success(value),
  );

  SyncValidationStep<int> toInt() => bind((value) {
    final parsed = int.tryParse(value);

    return parsed != null
        ? _success<int>(parsed)
        : _fail<int>('Value $value for field $fieldName is not a number');
  });

  SyncValidationStep<String> minLength(int length) => bind(
    (value) => value.length >= length
        ? _success(value)
        : _fail('$fieldName must be at least $length characters long'),
  );

  SyncValidationStep<String> maxLength(int length) => bind(
    (value) => value.length <= length
        ? _success(value)
        : _fail('$fieldName must be no more than $length characters long'),
  );

  SyncValidationStep<String> isEmail() => bind((value) {
    return RegExp(kEmailRegex).hasMatch(value)
        ? _success(value)
        : _fail('$fieldName must be a valid email address');
  });

  SyncValidationStep<String> isUrl() => bind((value) {
    return RegExp(kUrlRegex).hasMatch(value)
        ? _success(value)
        : _fail('$fieldName must be a valid URL');
  });

  SyncValidationStep<String> isPhone() => bind((value) {
    return RegExp(kPhoneRegex).hasMatch(value)
        ? _success(value)
        : _fail('$fieldName must be a valid phone number');
  });

  SyncValidationStep<String> isPattern(RegExp regex, String description) =>
      bind(
        (value) => regex.hasMatch(value)
            ? _success(value)
            : _fail('$fieldName must match pattern: $description'),
      );

  SyncValidationStep<String> contains(String substring) => bind(
    (value) => value.contains(substring)
        ? _success(value)
        : _fail('$fieldName must contain "$substring"'),
  );

  SyncValidationStep<String> startsWith(String prefix) => bind(
    (value) => value.startsWith(prefix)
        ? _success(value)
        : _fail('$fieldName must start with "$prefix"'),
  );

  SyncValidationStep<String> endsWith(String suffix) => bind(
    (value) => value.endsWith(suffix)
        ? _success(value)
        : _fail('$fieldName must end with "$suffix"'),
  );

  SyncValidationStep<String> alphanumeric() => bind((value) {
    return RegExp(kAlphanumericRegex).hasMatch(value)
        ? _success(value)
        : _fail('$fieldName must contain only alphanumeric characters');
  });

  SyncValidationStep<String> lettersOnly() => bind((value) {
    return RegExp(kLettersOnlyRegex).hasMatch(value)
        ? _success(value)
        : _fail('$fieldName must contain only letters');
  });

  SyncValidationStep<String> digitsOnly() => bind((value) {
    return RegExp(kDigitsOnlyRegex).hasMatch(value)
        ? _success(value)
        : _fail('$fieldName must contain only digits');
  });

  SyncValidationStep<String> isUuid() => bind((value) {
    return RegExp(kUuidRegex, caseSensitive: false).hasMatch(value)
        ? _success(value)
        : _fail('$fieldName must be a valid UUID');
  });

  SyncValidationStep<String> isCreditCard() => bind((value) {
    final cleanValue = value.replaceAll(RegExp(r'\s+'), '');
    return RegExp(kCreditCardRegex).hasMatch(cleanValue)
        ? _success(value)
        : _fail('$fieldName must be a valid credit card number');
  });

  SyncValidationStep<String> isPostalCode() => bind((value) {
    return RegExp(kPostalCodeRegex).hasMatch(value)
        ? _success(value)
        : _fail('$fieldName must be a valid postal code');
  });

  SyncValidationStep<String> isIsoDate() => bind((value) {
    if (!RegExp(kIsoDateRegex).hasMatch(value)) {
      return _fail('$fieldName must be in ISO date format (YYYY-MM-DD)');
    }

    try {
      final date = DateTime.parse(value);
      final year = int.parse(value.substring(0, 4));
      final month = int.parse(value.substring(5, 7));
      final day = int.parse(value.substring(8, 10));

      return date.year == year && date.month == month && date.day == day
          ? _success(value)
          : _fail('$fieldName must be a valid date');
    } catch (e) {
      return _fail('$fieldName must be a valid date');
    }
  });

  SyncValidationStep<String> isTime24Hour() => bind((value) {
    return RegExp(kTime24HourRegex).hasMatch(value)
        ? _success(value)
        : _fail('$fieldName must be in 24-hour format (HH:MM)');
  });
}
