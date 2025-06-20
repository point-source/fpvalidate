<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# fpvalidate

A functional validation library for Dart with support for TaskEither and Either types from the [fpdart](https://pub.dev/packages/fpdart) package.

## Features

- **Fluent API**: Chain validation rules with a clean, readable syntax
- **Functional Programming**: Built on [fpdart](https://pub.dev/packages/fpdart)'s Either and TaskEither for type-safe error handling
- **Multiple Validation Modes**: Support for both synchronous and asynchronous validation
- **Comprehensive Validators**: Built-in validators for strings, numbers, and nullable types
- **Custom Validators**: Easy creation of custom validation logic
- **Batch Validation**: Validate multiple fields at once
- **Nullable Support**: Specialized validators for handling optional fields
- **Error Handling**: Detailed error messages with field names and descriptions

## Getting Started

Add fpvalidate to your `pubspec.yaml`:

```yaml
dependencies:
  fpvalidate: ^1.0.0
  fpdart: ^1.1.1
```

Import the library:

```dart
import 'package:fpvalidate/fpvalidate.dart';
```

## Usage

### Basic Single Field Validation

```dart
// Simple validation with exception handling
try {
  final validatedEmail = email
      .field('Email')
      .notEmpty()
      .email()
      .validate();
  print('Valid email: $validatedEmail');
} catch (e) {
  if (e is ValidationError) {
    print('Validation failed: ${e.message}');
  }
}

// Functional validation with Either
final result = email
    .field('Email')
    .notEmpty()
    .email()
    .validateEither()
    .mapLeft((error) => 'Validation failed: ${error.message}');
```

### Multiple Field Validation

```dart
final validationResult = [
  email.field('Email').notEmpty().email(),
  password.field('Password').notEmpty().minLength(8),
  age.field('Age').min(13).max(120),
].validateEither()
.mapLeft((error) => 'Validation failed: ${error.message}');
```

### Asynchronous Validation

```dart
// Async validation with TaskEither
final result = await email
    .field('Email')
    .notEmpty()
    .email()
    .customAsync((email) async {
      // Check if email exists in database
      final exists = await userService.emailExists(email);
      return exists
          ? ValidationFailure('Email already registered')
          : ValidationSuccess(email);
    })
    .validateTask()
    .run();
```

### Nullable Field Validation

```dart
// Optional field that must be valid if provided
final result = optionalEmail
    .field('Optional Email')
    .custom(NullableValidators.optionalEmail())
    .validateEither();

// Required nullable field
final result = requiredField
    .field('Required Field')
    .nonNull()
    .notEmpty()
    .validateEither();
```

## Built-in Validators

### String Validators

```dart
email.field('Email')
    .notEmpty()           // Ensures field is not empty
    .email()              // Validates email format
    .minLength(5)         // Minimum length
    .maxLength(100)       // Maximum length
    .pattern(RegExp(r'^[a-z]+$'), 'lowercase letters only') // Custom regex
    .url()                // Validates URL format
    .phone()              // Validates phone number format
    .validate();
```

### Numeric Validators

```dart
age.field('Age')
    .min(0)               // Minimum value
    .max(120)             // Maximum value
    .inRange(13, 65)      // Value within range
    .positive()           // Must be positive
    .nonNegative()        // Must be non-negative
    .validate();
```

### Nullable Validators

```dart
optionalField.field('Optional Field')
    .custom(NullableValidators.ifPresent(StringValidators.notEmpty()))
    .custom(NullableValidators.optionalEmail())
    .custom(NullableValidators.optionalInRange(0, 100))
    .validate();
```

## Custom Validators

### Creating Custom Validators

```dart
// Simple custom validator
Validator<String> customValidator = (value) {
  if (value.contains('forbidden')) {
    return ValidationFailure('contains forbidden word');
  }
  return ValidationSuccess(value);
};

// Using custom validator
final result = someString
    .field('Some String')
    .custom(customValidator)
    .validate();
```

### Async Custom Validators

```dart
AsyncValidator<String> asyncValidator = (value) async {
  final isValid = await checkDatabase(value);
  return isValid
      ? ValidationSuccess(value)
      : ValidationFailure('not found in database');
};

final result = await someString
    .field('Some String')
    .customAsync(asyncValidator)
    .validateAsync();
```

### Reusable Validator Functions

```dart
// Create reusable validators
class CustomValidators {
  static Validator<String> containsWord(String word) => (value) {
    if (!value.contains(word)) {
      return ValidationFailure('must contain "$word"');
    }
    return ValidationSuccess(value);
  };

  static Validator<num> isEven() => (value) {
    if (value % 2 != 0) {
      return ValidationFailure('must be even');
    }
    return ValidationSuccess(value);
  };
}

// Use them in validation chains
final result = someString
    .field('Some String')
    .custom(CustomValidators.containsWord('required'))
    .validate();
```

## Advanced Usage

### Complex Form Validation

```dart
class UserRegistration {
  final String email;
  final String password;
  final String? phone;
  final int age;

  UserRegistration({
    required this.email,
    required this.password,
    this.phone,
    required this.age,
  });
}

Future<Either<String, UserRegistration>> validateRegistration({
  required String email,
  required String password,
  String? phone,
  required int age,
}) async {
  final result = await [
    email.field('Email').notEmpty().email(),
    password.field('Password').notEmpty().minLength(8),
    phone?.field('Phone').custom(NullableValidators.optionalPhone()) ??
        ValidationBuilder(null, 'Phone').custom((_) => ValidationSuccess(null)),
    age.field('Age').min(13).max(120),
  ].validateTask()
  .map((values) => UserRegistration(
    email: values[0],
    password: values[1],
    phone: values[2],
    age: values[3],
  ))
  .mapLeft((error) => 'Validation failed: ${error.message}')
  .run();

  return result;
}
```

### Conditional Validation

```dart
final result = userType
    .field('User Type')
    .custom((type) {
      if (type == 'business') {
        return businessEmail
            .field('Business Email')
            .notEmpty()
            .email()
            .validateEither()
            .fold(
              (error) => ValidationFailure(error.message),
              (value) => ValidationSuccess(type),
            );
      }
      return ValidationSuccess(type);
    })
    .validate();
```

## Error Handling

The library provides multiple ways to handle validation errors:

### Exception-based (Traditional)

```dart
try {
  final result = email.field('Email').notEmpty().email().validate();
} catch (e) {
  if (e is ValidationError) {
    print('${e.fieldName}: ${e.message}');
  }
}
```

### Functional (Either/TaskEither)

```dart
final result = email
    .field('Email')
    .notEmpty()
    .email()
    .validateEither()
    .fold(
      (error) => 'Error: ${error.message}',
      (value) => 'Success: $value',
    );
```

## Available Validator Classes

- **StringValidators**: Contains, startsWith, endsWith, alphanumeric, lettersOnly, digitsOnly, uuid, creditCard, postalCode, isoDate, time24Hour
- **NumericValidators**: isInteger, isEven, isOdd, isPerfectSquare, isPrime, isPowerOfTwo, withinPercentage, isPortNumber, isYear, isMonth, isDayOfMonth, isHour, isMinute
- **NullableValidators**: ifPresent, optional, required, optionalNotEmpty, optionalEmail, optionalUrl, optionalPhone, optionalInRange, optionalMinLength, optionalMaxLength

## Additional Information

- **Repository**: https://github.com/point-source/fpvalidate
- **Issue Tracker**: https://github.com/point-source/fpvalidate/issues
- **Dependencies**: Requires [fpdart](https://pub.dev/packages/fpdart) ^1.1.1 for functional programming utilities

For more examples and advanced usage patterns, check out the test files in the repository.
