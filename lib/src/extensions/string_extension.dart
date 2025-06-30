// ignore_for_file: newline-before-return

part of '../validation_step.dart';

/// Extension that provides validation methods for string values.
///
/// This extension adds comprehensive validation capabilities to strings, including
/// format validation (email, URL, phone, etc.), content validation, length validation,
/// and type conversion methods.
///
/// Example:
/// ```dart
/// final result = 'test@example.com'
///     .field('Email')
///     .notEmpty()
///     .isEmail()
///     .minLength(5)
///     .validateEither();
/// ```
extension StringExtension on SyncValidationStep<String> {
  /// Validates that the string is not empty.
  ///
  /// By default, this method considers strings containing only whitespace as empty.
  /// Use [allowWhitespace: true] to allow whitespace-only strings.
  ///
  /// [allowWhitespace] determines whether strings containing only whitespace are
  /// considered valid. Defaults to false.
  ///
  /// Returns a [ValidationError] if the string is empty or contains only whitespace
  /// (when [allowWhitespace] is false).
  ///
  /// Example:
  /// ```dart
  /// final result = string.field('String').notEmpty().validateEither();
  /// final result2 = string.field('String').notEmpty(allowWhitespace: true).validateEither();
  /// ```
  SyncValidationStep<String> notEmpty({bool allowWhitespace = false}) => bind(
    (value) => value.isEmpty
        ? _fail('Field $fieldName is empty')
        : !allowWhitespace && value.trim().isEmpty
        ? _fail('Field $fieldName is empty')
        : _success(value),
  );

  /// Converts the string to an integer and returns a new validation step.
  ///
  /// This method attempts to parse the string as an integer using [int.tryParse].
  /// If parsing fails, it returns a [ValidationError]. If successful, it returns
  /// a new [SyncValidationStep<int>] that can be chained with numeric validators.
  ///
  /// This is a type transformation validator that changes the validator type from
  /// [SyncValidationStep<String>] to [SyncValidationStep<int>].
  ///
  /// Returns a [SyncValidationStep<int>] if the string can be parsed as an integer.
  ///
  /// Example:
  /// ```dart
  /// final result = '123'
  ///     .field('Number String')
  ///     .toInt()              // Converts String to int
  ///     .min(100)             // Now we can use numeric validators
  ///     .max(200)
  ///     .validateEither();
  /// ```
  SyncValidationStep<int> toInt() => bind((value) {
    final parsed = int.tryParse(value);

    return parsed != null
        ? _success<int>(parsed)
        : _fail<int>('Value $value for field $fieldName is not a number');
  });

  /// Validates that the string has a minimum length of [length].
  ///
  /// Returns a [ValidationError] if the string is shorter than [length].
  ///
  /// Example:
  /// ```dart
  /// final result = password.field('Password').minLength(8).validateEither();
  /// ```
  SyncValidationStep<String> minLength(int length) => bind(
    (value) => value.length >= length
        ? _success(value)
        : _fail('$fieldName must be at least $length characters long'),
  );

  /// Validates that the string has a maximum length of [length].
  ///
  /// Returns a [ValidationError] if the string is longer than [length].
  ///
  /// Example:
  /// ```dart
  /// final result = username.field('Username').maxLength(20).validateEither();
  /// ```
  SyncValidationStep<String> maxLength(int length) => bind(
    (value) => value.length <= length
        ? _success(value)
        : _fail('$fieldName must be no more than $length characters long'),
  );

  /// Validates that the string is a valid email address.
  ///
  /// Uses a comprehensive regex pattern to validate email format.
  /// Returns a [ValidationError] if the string is not a valid email address.
  ///
  /// Example:
  /// ```dart
  /// final result = email.field('Email').isEmail().validateEither();
  /// ```
  SyncValidationStep<String> isEmail() => bind((value) {
    return RegExp(kEmailRegex).hasMatch(value)
        ? _success(value)
        : _fail('$fieldName must be a valid email address');
  });

  /// Validates that the string is a valid URL.
  ///
  /// Uses a comprehensive regex pattern to validate URL format.
  /// Returns a [ValidationError] if the string is not a valid URL.
  ///
  /// Example:
  /// ```dart
  /// final result = url.field('URL').isUrl().validateEither();
  /// ```
  SyncValidationStep<String> isUrl() => bind((value) {
    return RegExp(kUrlRegex).hasMatch(value)
        ? _success(value)
        : _fail('$fieldName must be a valid URL');
  });

  /// Validates that the string is a valid phone number.
  ///
  /// Uses a regex pattern to validate common phone number formats.
  /// Returns a [ValidationError] if the string is not a valid phone number.
  ///
  /// Example:
  /// ```dart
  /// final result = phone.field('Phone').isPhone().validateEither();
  /// ```
  SyncValidationStep<String> isPhone() => bind((value) {
    return RegExp(kPhoneRegex).hasMatch(value)
        ? _success(value)
        : _fail('$fieldName must be a valid phone number');
  });

  /// Validates that the string matches a custom regex pattern.
  ///
  /// [regex] is the regular expression pattern to match against.
  /// [description] is a human-readable description of the pattern for error messages.
  ///
  /// Returns a [ValidationError] if the string doesn't match the pattern.
  ///
  /// Example:
  /// ```dart
  /// final result = string
  ///     .field('String')
  ///     .isPattern(RegExp(r'^[a-z]+$'), 'lowercase letters only')
  ///     .validateEither();
  /// ```
  SyncValidationStep<String> isPattern(RegExp regex, String description) =>
      bind(
        (value) => regex.hasMatch(value)
            ? _success(value)
            : _fail('$fieldName must match pattern: $description'),
      );

  /// Validates that the string contains the specified [substring].
  ///
  /// Returns a [ValidationError] if the string doesn't contain [substring].
  ///
  /// Example:
  /// ```dart
  /// final result = text.field('Text').contains('required').validateEither();
  /// ```
  SyncValidationStep<String> contains(String substring) => bind(
    (value) => value.contains(substring)
        ? _success(value)
        : _fail('$fieldName must contain "$substring"'),
  );

  /// Validates that the string starts with the specified [prefix].
  ///
  /// Returns a [ValidationError] if the string doesn't start with [prefix].
  ///
  /// Example:
  /// ```dart
  /// final result = url.field('URL').startsWith('https').validateEither();
  /// ```
  SyncValidationStep<String> startsWith(String prefix) => bind(
    (value) => value.startsWith(prefix)
        ? _success(value)
        : _fail('$fieldName must start with "$prefix"'),
  );

  /// Validates that the string ends with the specified [suffix].
  ///
  /// Returns a [ValidationError] if the string doesn't end with [suffix].
  ///
  /// Example:
  /// ```dart
  /// final result = filename.field('Filename').endsWith('.txt').validateEither();
  /// ```
  SyncValidationStep<String> endsWith(String suffix) => bind(
    (value) => value.endsWith(suffix)
        ? _success(value)
        : _fail('$fieldName must end with "$suffix"'),
  );

  /// Validates that the string contains only alphanumeric characters (letters and digits).
  ///
  /// Returns a [ValidationError] if the string contains any non-alphanumeric characters.
  ///
  /// Example:
  /// ```dart
  /// final result = username.field('Username').alphanumeric().validateEither();
  /// ```
  SyncValidationStep<String> alphanumeric() => bind((value) {
    return RegExp(kAlphanumericRegex).hasMatch(value)
        ? _success(value)
        : _fail('$fieldName must contain only alphanumeric characters');
  });

  /// Validates that the string contains only letters (a-z, A-Z).
  ///
  /// Returns a [ValidationError] if the string contains any non-letter characters.
  ///
  /// Example:
  /// ```dart
  /// final result = name.field('Name').lettersOnly().validateEither();
  /// ```
  SyncValidationStep<String> lettersOnly() => bind((value) {
    return RegExp(kLettersOnlyRegex).hasMatch(value)
        ? _success(value)
        : _fail('$fieldName must contain only letters');
  });

  /// Validates that the string contains only digits (0-9).
  ///
  /// Returns a [ValidationError] if the string contains any non-digit characters.
  ///
  /// Example:
  /// ```dart
  /// final result = number.field('Number').digitsOnly().validateEither();
  /// ```
  SyncValidationStep<String> digitsOnly() => bind((value) {
    return RegExp(kDigitsOnlyRegex).hasMatch(value)
        ? _success(value)
        : _fail('$fieldName must contain only digits');
  });

  /// Validates that the string is a valid UUID (Universally Unique Identifier).
  ///
  /// Uses a regex pattern to validate UUID format (e.g., 550e8400-e29b-41d4-a716-446655440000).
  /// Case-insensitive validation.
  ///
  /// Returns a [ValidationError] if the string is not a valid UUID.
  ///
  /// Example:
  /// ```dart
  /// final result = uuid.field('UUID').isUuid().validateEither();
  /// ```
  SyncValidationStep<String> isUuid() => bind((value) {
    return RegExp(kUuidRegex, caseSensitive: false).hasMatch(value)
        ? _success(value)
        : _fail('$fieldName must be a valid UUID');
  });

  /// Validates that the string is a valid credit card number.
  ///
  /// Uses a regex pattern to validate common credit card number formats.
  /// Automatically removes whitespace before validation.
  ///
  /// Returns a [ValidationError] if the string is not a valid credit card number.
  ///
  /// Example:
  /// ```dart
  /// final result = cardNumber.field('Card Number').isCreditCard().validateEither();
  /// ```
  SyncValidationStep<String> isCreditCard() => bind((value) {
    final cleanValue = value.replaceAll(RegExp(r'\s+'), '');
    return RegExp(kCreditCardRegex).hasMatch(cleanValue)
        ? _success(value)
        : _fail('$fieldName must be a valid credit card number');
  });

  /// Validates that the string is a valid postal code.
  ///
  /// Uses a regex pattern to validate common postal code formats.
  /// Returns a [ValidationError] if the string is not a valid postal code.
  ///
  /// Example:
  /// ```dart
  /// final result = postalCode.field('Postal Code').isPostalCode().validateEither();
  /// ```
  SyncValidationStep<String> isPostalCode() => bind((value) {
    return RegExp(kPostalCodeRegex).hasMatch(value)
        ? _success(value)
        : _fail('$fieldName must be a valid postal code');
  });

  /// Validates that the string is a valid ISO date in YYYY-MM-DD format.
  ///
  /// This method validates both the format and the actual date validity.
  /// Returns a [ValidationError] if the string is not a valid ISO date.
  ///
  /// Example:
  /// ```dart
  /// final result = date.field('Date').isIsoDate().validateEither();
  /// ```
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

  /// Validates that the string is a valid 24-hour time in HH:MM format.
  ///
  /// Uses a regex pattern to validate 24-hour time format (00:00 to 23:59).
  /// Returns a [ValidationError] if the string is not a valid 24-hour time.
  ///
  /// Example:
  /// ```dart
  /// final result = time.field('Time').isTime24Hour().validateEither();
  /// ```
  SyncValidationStep<String> isTime24Hour() => bind((value) {
    return RegExp(kTime24HourRegex).hasMatch(value)
        ? _success(value)
        : _fail('$fieldName must be in 24-hour format (HH:MM)');
  });
}
