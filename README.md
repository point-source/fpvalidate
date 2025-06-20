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
  fpvalidate: ^0.1.0
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
    .validateTaskEither()
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

#### String Validators

For even more convenient string validation, you can use the extension methods directly on `ValidationBuilder<String>`:

```dart
someString.field('Some String')
    .contains('required')     // Must contain substring
    .startsWith('https')      // Must start with prefix
    .endsWith('.com')         // Must end with suffix
    .alphanumeric()           // Only alphanumeric characters
    .lettersOnly()            // Only letters
    .digitsOnly()             // Only digits
    .uuid()                   // Valid UUID format
    .creditCard()             // Valid credit card number
    .postalCode()             // Valid postal code format
    .isoDate()                // Valid ISO date (YYYY-MM-DD)
    .time24Hour()             // Valid 24-hour time (HH:MM)
    .validate();
```

These extension methods provide the same functionality as the `StringValidators` class but with a more fluent, chainable API. They automatically use the field name in error messages for better user experience.

### Numeric Validators

```dart
age.field('Age')
    .min(0)               // Minimum value
    .max(120)             // Maximum value
    .inRange(13, 65)      // Value within range
    .positive()           // Must be positive
    .nonNegative()        // Must be non-negative
    .isInteger()          // Must be an integer
    .isEven()             // Must be even
    .isOdd()              // Must be odd
    .isPrime()            // Must be prime
    .isPowerOfTwo()       // Must be a power of 2
    .isPerfectSquare()    // Must be a perfect square
    .isPortNumber()       // Must be a valid port number (1-65535)
    .isYear()             // Must be a valid year (1900-2100)
    .isMonth()            // Must be a valid month (1-12)
    .isDayOfMonth()       // Must be a valid day (1-31)
    .isHour()             // Must be a valid hour (0-23)
    .isMinute()           // Must be a valid minute (0-59)
    .isSecond()           // Must be a valid second (0-59)
    .withinPercentage(target, 5.0) // Within 5% of target value
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

Available nullable validators:

- `ifPresent()` - Apply validator only if value is not null
- `optional()` - Alias for ifPresent
- `required()` - Ensure value is not null and apply validator
- `optionalNotEmpty()` - Ensure string is not empty if provided
- `optionalEmail()` - Ensure valid email format if provided
- `optionalUrl()` - Ensure valid URL format if provided
- `optionalPhone()` - Ensure valid phone format if provided
- `optionalInRange(min, max)` - Ensure value is in range if provided
- `optionalMinLength(length)` - Ensure minimum length if provided
- `optionalMaxLength(length)` - Ensure maximum length if provided

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
  ].validateTaskEither()
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

## Validation Methods

The library provides several validation methods to suit different use cases:

### Synchronous Validation

- `validate()` - Throws ValidationError on failure, returns value on success
- `validateEither()` - Returns Either<ValidationError, T>
- `validateTaskEither()` - Returns TaskEither<ValidationError, T>

### Asynchronous Validation

- `validateAsync()` - Throws ValidationError on failure, returns Future<T> on success
- `validateTaskEither()` - Returns TaskEither<ValidationError, T>

### Batch Validation

- `validate()` - Throws ValidationError on first failure, returns List<T> on success
- `validateAsync()` - Throws ValidationError on first failure, returns Future<List<T>> on success
- `validateEither()` - Returns Either<ValidationError, List<T>>
- `validateTaskEither()` - Returns TaskEither<ValidationError, List<T>>

## Examples

Check out the [example/example.dart](example/example.dart) file for more usage examples:

```dart
// Basic string validation
final result = 'https://example.com/api'
    .field('URL')
    .startsWith('https')
    .contains('api')
    .validate();

// Complex string validation
final result = 'user123'
    .field('Username')
    .alphanumeric()
    .minLength(4)
    .maxLength(20)
    .validate();

// Date and time validation
final dateResult = '2023-12-25'.field('Date').isoDate().validate();
final timeResult = '14:30'.field('Time').time24Hour().validate();

// Functional validation with Either
final functionalResult = '550e8400-e29b-41d4-a716-446655440000'
    .field('UUID')
    .uuid()
    .validateEither()
    .fold(
      (error) => '❌ UUID validation failed: ${error.message}',
      (value) => '✅ Valid UUID: $value',
    );
```

## Additional Information

- **Repository**: https://github.com/point-source/fpvalidate
- **Issue Tracker**: https://github.com/point-source/fpvalidate/issues
- **Dependencies**: Requires [fpdart](https://pub.dev/packages/fpdart) ^1.1.1 for functional programming utilities

For more examples and advanced usage patterns, check out the test files in the repository.
