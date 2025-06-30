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
      .isEmail()
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
    .isEmail()
    .validateEither()
    .mapLeft((error) => 'Validation failed: ${error.message}');
```

### Multiple Field Validation

```dart
final validationResult = [
  email.field('Email').notEmpty().isEmail(),
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
    .isEmail()
    .toAsync()
    .tryMap((email) async {
      // Check if email exists in database
      final exists = await userService.emailExists(email);
      if (exists) {
        throw Exception('Email already registered');
      }
      return email;
    }, (fieldName) => '$fieldName already registered')
    .validateTaskEither()
    .run();

// Async validation with Either
final asyncResult = await email
    .field('Email')
    .notEmpty()
    .isEmail()
    .toAsync()
    .validateEither();
```

### Nullable Field Validation

```dart
// Optional field that must be valid if provided
final result = optionalEmail
    .field('Optional Email')
    .isNotNull()
    .validateEither();

// Required nullable field
final result = requiredField
    .field('Required Field')
    .isNotNull()
    .notEmpty()
    .validateEither();
```

## Built-in Validators

### String Validators

```dart
email.field('Email')
    .notEmpty()           // Ensures field is not empty
    .notEmpty(allowWhitespace: true)  // Allows whitespace-only strings
    .isEmail()            // Validates email format
    .minLength(5)         // Minimum length
    .maxLength(100)       // Maximum length
    .isPattern(RegExp(r'^[a-z]+$'), 'lowercase letters only') // Custom regex
    .isUrl()              // Validates URL format
    .isPhone()            // Validates phone number format
    .contains('required') // Must contain substring
    .startsWith('https')  // Must start with prefix
    .endsWith('.com')     // Must end with suffix
    .alphanumeric()       // Only alphanumeric characters
    .lettersOnly()        // Only letters
    .digitsOnly()         // Only digits
    .isUuid()             // Valid UUID format
    .isCreditCard()       // Valid credit card number
    .isPostalCode()       // Valid postal code format
    .isIsoDate()          // Valid ISO date (YYYY-MM-DD)
    .isTime24Hour()       // Valid 24-hour time (HH:MM)
    .validate();
```

These validators provide a fluent, chainable API and automatically use the field name in error messages for better user experience.

### Numeric Validators

```dart
age.field('Age')
    .min(0)               // Minimum value
    .max(120)             // Maximum value
    .inRange(13, 65)      // Value within range
    .isPositive()         // Must be positive
    .isNonNegative()      // Must be non-negative
    .isInt()              // Must be an integer
    .isEven()             // Must be even
    .isOdd()              // Must be odd
    .isPowerOfTwo()       // Must be a power of 2
    .isPortNumber()       // Must be a valid port number (1-65535)
    .isWithinPercentage(target, 5.0) // Within 5% of target value
    .validate();
```

### Nullable Validators

```dart
optionalField.field('Optional Field')
    .isNotNull()
    .validate();
```

### Type Casting and Transformation Validators

Some validators not only validate but also transform the value type, enabling different validation chains:

```dart
// String to Integer transformation
final result = '123'
    .field('Number String')
    .toInt()              // Converts String to int, enables numeric validators
    .min(100)             // Now we can use numeric validators
    .max(200)
    .isEven()
    .validateEither();

// Nullable to Non-nullable transformation
final result = (someNullableString as String?)
    .field('Optional String')
    .isNotNull()          // Converts String? to String, enables string validators
    .notEmpty()           // Now we can use string validators
    .isEmail()
    .validateEither();

// Custom transformation with tryMap
final result = '2023-12-25'
    .field('Date String')
    .tryMap(
      (value) => DateTime.parse(value),  // Converts String to DateTime
      (fieldName) => '$fieldName must be a valid date',
    )
    .validateEither();
```

These transformation validators are powerful because they allow you to:

- Convert between types while validating
- Chain different types of validators
- Handle nullable to non-nullable conversions
- Create custom type transformations with `tryMap()`

## Advanced Features

### Custom Validation

```dart
// Custom validation with check()
final result = 'hello world'
    .field('Custom String')
    .check(
      (value) => value.contains('world'),
      (fieldName) => '$fieldName must contain "world"',
    )
    .validateEither();

// Custom transformation with tryMap()
final result = '123'
    .field('Number String')
    .tryMap(
      (value) => int.tryParse(value) ?? throw Exception('Invalid number'),
      (fieldName) => '$fieldName must be a valid number',
    )
    .validateEither();

// Type conversion with toInt()
final result = '123'
    .field('Number String')
    .toInt()
    .validateEither();
```

### Error Handling

```dart
// Get error message or null (useful for Flutter forms)
final error = email
    .field('Email')
    .notEmpty()
    .isEmail()
    .errorOrNull();

if (error != null) {
  // Display error in UI
  print('Error: $error');
}

// Convenience method for Flutter forms
final formValidator = email
    .field('Email')
    .notEmpty()
    .isEmail()
    .asFormValidator(); // Same as errorOrNull()
```

### Async Validation

```dart
// Convert sync validation to async
final asyncResult = await email
    .field('Email')
    .notEmpty()
    .isEmail()
    .toAsync()
    .tryMap((email) async {
      // Simulate async validation
      await Future.delayed(Duration(milliseconds: 100));
      if (email.contains('async')) {
        return email;
      }
      throw Exception('Email must contain "async"');
    }, (fieldName) => '$fieldName must contain "async"')
    .validateTaskEither()
    .run();
```

## Examples

### Form Validation

```dart
class UserRegistrationForm {
  final String email;
  final String password;
  final int age;
  final String? phone;

  UserRegistrationForm({
    required this.email,
    required this.password,
    required this.age,
    this.phone,
  });

  Either<ValidationError, UserRegistrationForm> validate() {
    return [
      email.field('Email').notEmpty().isEmail(),
      password.field('Password').notEmpty().minLength(8),
      age.field('Age').min(13).max(120),
      if (phone != null) phone!.field('Phone').isPhone(),
    ].validateEither().map((_) => this);
  }
}
```

### API Response Validation

```dart
Future<Either<ValidationError, User>> validateUserResponse(Map<String, dynamic> json) async {
  return await json['email']
      .toString()
      .field('Email')
      .notEmpty()
      .isEmail()
      .toAsync()
      .tryMap((email) async {
        // Additional async validation
        final userExists = await userService.exists(email);
        if (!userExists) {
          throw Exception('User not found');
        }
        return User(email: email);
      }, (fieldName) => '$fieldName not found')
      .validateTaskEither()
      .run();
}
```

### Flutter Form Integration

```dart
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null) return null;
    return value
        .field('Email')
        .notEmpty()
        .isEmail()
        .asFormValidator();
  }

  String? _validatePassword(String? value) {
    if (value == null) return null;
    return value
        .field('Password')
        .notEmpty()
        .minLength(8)
        .asFormValidator();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            validator: _validateEmail,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            controller: _passwordController,
            validator: _validatePassword,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
```

## Error Messages

The library provides descriptive error messages that include the field name:

- `"Email must be a valid email address"`
- `"Password must be at least 8 characters long"`
- `"Age must be between 13 and 120"`
- `"Phone must be a valid phone number"`

## Localization

Currently, all error messages in fpvalidate are provided in English only and are not localizable. However, I recognize the importance of internationalization for a validation library and are actively interested in community contributions to implement localization support.

I'd welcome contributions in the following areas:

- **Design Discussion**: Help us design the best approach for implementing localization in the validation library
- **Implementation**: Contribute code to add localization infrastructure and support
- **Translations**: Provide translations for error messages once localization is implemented

If you're interested in contributing to localization efforts, please:

1. Open an issue to discuss the design approach
2. Share your thoughts on the best way to integrate localization with the existing API
3. Contribute translations for your target languages

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.
