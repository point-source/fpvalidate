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
///     .trust('Email')
///     .isNotEmpty()
///     .isEmail()
///     .minLength(5)
///     .verify();
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
  /// final result = string.trust('String').isNotEmpty().verify();
  /// final result2 = string.trust('String').isNotEmpty(allowWhitespace: true).verify();
  /// ```
  SyncValidationStep<String> isNotEmpty({bool allowWhitespace = false}) => bind(
    (value) => value.isEmpty
        ? fail(
            EmptyStringValidationError.new,
            ValidationI18n.messages.emptyField(fieldName),
          )
        : !allowWhitespace && value.trim().isEmpty
        ? fail(
            EmptyStringValidationError.new,
            ValidationI18n.messages.emptyField(fieldName),
          )
        : pass(value),
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
  ///     .trust('Number String')
  ///     .toInt()              // Converts String to int
  ///     .min(100)             // Now we can use numeric validators
  ///     .max(200)
  ///     .verify();
  /// ```
  SyncValidationStep<int> toInt() => bind((value) {
    final parsed = int.tryParse(value);
    return parsed != null
        ? pass<int>(parsed)
        : fail<int>(
            InvalidNumberFormatValidationError.new,
            ValidationI18n.messages.invalidNumberFormat(fieldName, value),
          );
  });

  /// Validates that the string has a minimum length of [length].
  ///
  /// Returns a [ValidationError] if the string is shorter than [length].
  ///
  /// Example:
  /// ```dart
  /// final result = password.trust('Password').minLength(8).verify();
  /// ```
  SyncValidationStep<String> minLength(int length) => bind(
    (value) => value.length >= length
        ? pass(value)
        : fail(
            InvalidLengthValidationError.new,
            ValidationI18n.messages.minLength(fieldName, length),
          ),
  );

  /// Validates that the string has a maximum length of [length].
  ///
  /// Returns a [ValidationError] if the string is longer than [length].
  ///
  /// Example:
  /// ```dart
  /// final result = username.trust('Username').maxLength(20).verify();
  /// ```
  SyncValidationStep<String> maxLength(int length) => bind(
    (value) => value.length <= length
        ? pass(value)
        : fail(
            InvalidLengthValidationError.new,
            ValidationI18n.messages.maxLength(fieldName, length),
          ),
  );

  /// Validates that the string is a valid email address.
  ///
  /// If [allowTopLevelDomains] is `true`, then the validator will
  /// allow addresses with top-level domains like `email@example`.
  ///
  /// If [allowInternational] is `true`, then the validator
  /// will use the newer International Email standards for validating
  /// the email address.
  ///
  /// Uses [email_validator](https://pub.dev/packages/email_validator) to validate email format.
  /// Returns a [ValidationError] if the string is not a valid email address.
  ///
  /// Example:
  /// ```dart
  /// final result = email.trust('Email').isEmail().verify();
  /// ```
  SyncValidationStep<String> isEmail({
    bool allowTopLevelDomains = false,
    bool allowInternational = true,
  }) => bind((value) {
    return EmailValidator.validate(
          value,
          allowTopLevelDomains,
          allowInternational,
        )
        ? pass(value)
        : fail(
            InvalidEmailValidationError.new,
            ValidationI18n.messages.invalidEmail(fieldName),
          );
  });

  /// Validates that the string is a valid URL.
  ///
  /// Uses a comprehensive regex pattern to validate URL format.
  /// Returns a [ValidationError] if the string is not a valid URL.
  ///
  /// Example:
  /// ```dart
  /// final result = url.trust('URL').isUrl().verify();
  /// ```
  SyncValidationStep<String> isUrl() => bind((value) {
    return RegExp(kUrlRegex).hasMatch(value)
        ? pass(value)
        : fail(
            InvalidUrlValidationError.new,
            ValidationI18n.messages.invalidUrl(fieldName),
          );
  });

  /// Validates that the string is a valid phone number.
  ///
  /// Uses a regex pattern to validate common phone number formats.
  /// Returns a [ValidationError] if the string is not a valid phone number.
  ///
  /// Example:
  /// ```dart
  /// final result = phone.trust('Phone').isPhone().verify();
  /// ```
  SyncValidationStep<String> isPhone() => bind((value) {
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 10) {
      return fail(
        InvalidPhoneValidationError.new,
        ValidationI18n.messages.invalidPhone(fieldName),
      );
    }
    return RegExp(kPhoneRegex).hasMatch(value)
        ? pass(value)
        : fail(
            InvalidPhoneValidationError.new,
            ValidationI18n.messages.invalidPhone(fieldName),
          );
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
  ///     .trust('String')
  ///     .isPattern(RegExp(r'^[a-z]+$'), 'lowercase letters only')
  ///     .verify();
  /// ```
  SyncValidationStep<String> isPattern(RegExp regex, String description) =>
      bind(
        (value) => regex.hasMatch(value)
            ? pass(value)
            : fail(
                InvalidPatternValidationError.new,
                ValidationI18n.messages.invalidPattern(fieldName, description),
              ),
      );

  /// Validates that the string contains the specified [substring].
  ///
  /// Returns a [ValidationError] if the string doesn't contain [substring].
  ///
  /// Example:
  /// ```dart
  /// final result = text.trust('Text').contains('required').verify();
  /// ```
  SyncValidationStep<String> contains(String substring) => bind(
    (value) => value.contains(substring)
        ? pass(value)
        : fail(
            MissingSubstringValidationError.new,
            ValidationI18n.messages.missingSubstring(fieldName, substring),
          ),
  );

  /// Validates that the string starts with the specified [prefix].
  ///
  /// Returns a [ValidationError] if the string doesn't start with [prefix].
  ///
  /// Example:
  /// ```dart
  /// final result = url.trust('URL').startsWith('https').verify();
  /// ```
  SyncValidationStep<String> startsWith(String prefix) => bind(
    (value) => value.startsWith(prefix)
        ? pass(value)
        : fail(
            InvalidPrefixValidationError.new,
            ValidationI18n.messages.invalidPrefix(fieldName, prefix),
          ),
  );

  /// Validates that the string ends with the specified [suffix].
  ///
  /// Returns a [ValidationError] if the string doesn't end with [suffix].
  ///
  /// Example:
  /// ```dart
  /// final result = filename.trust('Filename').endsWith('.txt').verify();
  /// ```
  SyncValidationStep<String> endsWith(String suffix) => bind(
    (value) => value.endsWith(suffix)
        ? pass(value)
        : fail(
            InvalidSuffixValidationError.new,
            ValidationI18n.messages.invalidSuffix(fieldName, suffix),
          ),
  );

  /// Validates that the string contains only alphanumeric characters (letters and digits).
  ///
  /// Returns a [ValidationError] if the string contains any non-alphanumeric characters.
  ///
  /// Example:
  /// ```dart
  /// final result = username.trust('Username').alphanumeric().verify();
  /// ```
  SyncValidationStep<String> alphanumeric() => bind((value) {
    return RegExp(kAlphanumericRegex).hasMatch(value)
        ? pass(value)
        : fail(
            InvalidAlphanumericValidationError.new,
            ValidationI18n.messages.invalidAlphanumeric(fieldName),
          );
  });

  /// Validates that the string contains only letters (a-z, A-Z).
  ///
  /// Returns a [ValidationError] if the string contains any non-letter characters.
  ///
  /// Example:
  /// ```dart
  /// final result = name.trust('Name').lettersOnly().verify();
  /// ```
  SyncValidationStep<String> lettersOnly() => bind((value) {
    return RegExp(kLettersOnlyRegex).hasMatch(value)
        ? pass(value)
        : fail(
            InvalidLettersOnlyValidationError.new,
            ValidationI18n.messages.invalidLettersOnly(fieldName),
          );
  });

  /// Validates that the string contains only digits (0-9).
  ///
  /// Returns a [ValidationError] if the string contains any non-digit characters.
  ///
  /// Example:
  /// ```dart
  /// final result = number.trust('Number').digitsOnly().verify();
  /// ```
  SyncValidationStep<String> digitsOnly() => bind((value) {
    return RegExp(kDigitsOnlyRegex).hasMatch(value)
        ? pass(value)
        : fail(
            InvalidDigitsOnlyValidationError.new,
            ValidationI18n.messages.invalidDigitsOnly(fieldName),
          );
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
  /// final result = uuid.trust('UUID').isUuid().verify();
  /// ```
  SyncValidationStep<String> isUuid() => bind((value) {
    return RegExp(kUuidRegex, caseSensitive: false).hasMatch(value)
        ? pass(value)
        : fail(
            InvalidUuidValidationError.new,
            ValidationI18n.messages.invalidUuid(fieldName),
          );
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
  /// final result = cardNumber.trust('Card Number').isCreditCard().verify();
  /// ```
  SyncValidationStep<String> isCreditCard({bool validateLuhn = true}) =>
      bind((value) {
        final cleanValue = value.replaceAll(RegExp(r'\s+'), '');
        if (!RegExp(kCreditCardRegex).hasMatch(cleanValue)) {
          return fail(
            InvalidCreditCardValidationError.new,
            ValidationI18n.messages.invalidCreditCard(fieldName),
          );
        }
        if (validateLuhn && !_isValidLuhn(cleanValue)) {
          return fail(
            InvalidCreditCardValidationError.new,
            ValidationI18n.messages.invalidCreditCard(fieldName),
          );
        }
        return pass(value);
      });

  /// Validates Luhn algorithm for credit card numbers
  static bool _isValidLuhn(String cardNumber) {
    if (cardNumber.isEmpty) return false;

    int sum = 0;
    bool alternate = false;

    // Loop through values starting from the rightmost side
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int n = int.parse(cardNumber[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      sum += n;
      alternate = !alternate;
    }

    return (sum % 10 == 0);
  }

  /// Validates that the string is a valid postal code.
  ///
  /// Uses a regex pattern to validate common postal code formats.
  /// Returns a [ValidationError] if the string is not a valid postal code.
  ///
  /// Example:
  /// ```dart
  /// final result = postalCode.trust('Postal Code').isPostalCode().verify();
  /// ```
  SyncValidationStep<String> isPostalCode() => bind((value) {
    return RegExp(kPostalCodeRegex).hasMatch(value)
        ? pass(value)
        : fail(
            InvalidPostalCodeValidationError.new,
            ValidationI18n.messages.invalidPostalCode(fieldName),
          );
  });

  /// Validates that the string is a valid ISO date in YYYY-MM-DD format.
  ///
  /// This method validates both the format and the actual date validity.
  /// Returns a [ValidationError] if the string is not a valid ISO date.
  ///
  /// Example:
  /// ```dart
  /// final result = date.trust('Date').isIsoDate().verify();
  /// ```
  SyncValidationStep<String> isIsoDate() => bind((value) {
    if (!RegExp(kIsoDateRegex).hasMatch(value)) {
      return fail(
        InvalidIsoDateValidationError.new,
        ValidationI18n.messages.invalidIsoDate(fieldName),
      );
    }
    try {
      final date = DateTime.parse(value);
      final year = int.parse(value.substring(0, 4));
      final month = int.parse(value.substring(5, 7));
      final day = int.parse(value.substring(8, 10));
      return date.year == year && date.month == month && date.day == day
          ? pass(value)
          : fail(
              InvalidIsoDateValidationError.new,
              ValidationI18n.messages.invalidDate(fieldName),
            );
    } catch (e) {
      return fail(
        InvalidIsoDateValidationError.new,
        ValidationI18n.messages.invalidDate(fieldName),
      );
    }
  });

  /// Validates that the string is a valid 24-hour time in HH:MM format.
  ///
  /// Uses a regex pattern to validate 24-hour time format (00:00 to 23:59).
  /// [requireLeadingZero] determines whether hours and minutes must have leading zeros.
  /// Returns a [ValidationError] if the string is not a valid 24-hour time.
  ///
  /// Example:
  /// ```dart
  /// final result = time.trust('Time').isTime24Hour().verify();
  /// final result2 = time.trust('Time').isTime24Hour(requireLeadingZero: true).verify();
  /// ```
  SyncValidationStep<String> isTime24Hour({bool requireLeadingZero = false}) =>
      bind((value) {
        if (!RegExp(kTime24HourRegex).hasMatch(value)) {
          return fail(
            InvalidTime24HourValidationError.new,
            ValidationI18n.messages.invalidTime24Hour(fieldName),
          );
        }
        if (requireLeadingZero) {
          if (!RegExp(kTime24HourStrictRegex).hasMatch(value)) {
            return fail(
              InvalidTime24HourValidationError.new,
              ValidationI18n.messages.invalidTime24HourStrict(fieldName),
            );
          }
        }
        return pass(value);
      });

  /// Validates that the string is one of the specified allowed values.
  ///
  /// This method checks if the current value matches any of the values in [allowedValues].
  /// The comparison is case-sensitive by default. Use [caseInsensitive: true] for
  /// case-insensitive comparison.
  ///
  /// [allowedValues] is a list of strings that are considered valid.
  /// [caseInsensitive] determines whether the comparison should be case-insensitive.
  /// Defaults to false (case-sensitive).
  ///
  /// Returns a [ValidationError] if the string is not in the allowed values list.
  ///
  /// Example:
  /// ```dart
  /// final result = status
  ///     .trust('Status')
  ///     .isOneOf(['active', 'inactive', 'pending'])
  ///     .verify();
  ///
  /// // Case-insensitive comparison
  /// final result2 = status
  ///     .trust('Status')
  ///     .isOneOf(['ACTIVE', 'INACTIVE'], caseInsensitive: true)
  ///     .verify();
  /// ```
  SyncValidationStep<String> isOneOf(
    List<String> allowedValues, {
    bool caseInsensitive = false,
  }) => bind((value) {
    final normalizedValue = caseInsensitive ? value.toLowerCase() : value;
    final normalizedAllowed = caseInsensitive
        ? allowedValues.map((v) => v.toLowerCase()).toList()
        : allowedValues;
    return normalizedAllowed.contains(normalizedValue)
        ? pass(value)
        : fail(
            InvalidAllowedValueValidationError.new,
            ValidationI18n.messages.invalidAllowedValue(
              fieldName,
              allowedValues,
            ),
          );
  });

  /// Validates that the string is none of the specified forbidden values.
  ///
  /// This method checks if the current value does not match any of the values in [forbiddenValues].
  /// The comparison is case-sensitive by default. Use [caseInsensitive: true] for
  /// case-insensitive comparison.
  ///
  /// [forbiddenValues] is a list of strings that are considered forbidden.
  /// [caseInsensitive] determines whether the comparison should be case-insensitive.
  /// Defaults to false (case-sensitive).
  ///
  /// Returns a [ValidationError] if the string is in the forbidden values list.
  ///
  /// Example:
  /// ```dart
  /// final result = username.trust('Username').isNoneOf(['admin', 'root', 'system']).verify();
  ///
  /// // Case-insensitive comparison
  /// final result2 = username.trust('Username').isNoneOf(['ADMIN', 'ROOT'], caseInsensitive: true).verify();
  /// ```
  SyncValidationStep<String> isNoneOf(
    List<String> forbiddenValues, {
    bool caseInsensitive = false,
  }) => bind((value) {
    final normalizedValue = caseInsensitive ? value.toLowerCase() : value;
    final normalizedForbidden = caseInsensitive
        ? forbiddenValues.map((v) => v.toLowerCase()).toList()
        : forbiddenValues;
    return !normalizedForbidden.contains(normalizedValue)
        ? pass(value)
        : fail(
            InvalidForbiddenValueValidationError.new,
            ValidationI18n.messages.invalidForbiddenValue(
              fieldName,
              forbiddenValues,
            ),
          );
  });
}

extension NullableStringExtension on SyncValidationStep<String?> {
  /// Validates that the string is not null or empty.
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
  /// final result = string.trust('String').isNotEmpty().verify();
  /// final result2 = string.trust('String').isNotEmpty(allowWhitespace: true).verify();
  /// ```
  SyncValidationStep<String> isNotEmpty({bool allowWhitespace = false}) =>
      isNotNull().isNotEmpty(allowWhitespace: allowWhitespace);
}
