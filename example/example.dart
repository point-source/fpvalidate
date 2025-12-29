import 'package:trust_but_verify/trust_but_verify.dart';

void main() async {
  print('=== fpvalidate Examples ===\n');

  // Basic string validation
  try {
    final email = 'test@example.com'
        .trust('Email')
        .isNotEmpty()
        .isEmail()
        .verify();
    print('✅ Valid email: $email');
  } catch (e) {
    if (e is ValidationError) {
      print('❌ Email validation failed: ${e.message}');
    }
  }

  // Functional validation with Either
  final uuidResult = '550e8400-e29b-41d4-a716-446655440000'
      .trust('UUID')
      .isUuid()
      .verifyEither()
      .fold(
        (error) => '❌ UUID validation failed: ${error.message}',
        (value) => '✅ Valid UUID: $value',
      );
  print(uuidResult);

  // Numeric validation
  final ageResult = 25
      .trust('Age')
      .min(18)
      .max(65)
      .isEven()
      .verifyEither()
      .fold(
        (error) => '❌ Age validation failed: ${error.message}',
        (value) => '✅ Valid age: $value',
      );
  print(ageResult);

  // String validators
  final urlResult = 'https://example.com/api'
      .trust('URL')
      .startsWith('https')
      .contains('api')
      .isUrl()
      .verifyEither()
      .fold(
        (error) => '❌ URL validation failed: ${error.message}',
        (value) => '✅ Valid URL: $value',
      );
  print(urlResult);

  // Nullable validation
  // ignore: avoid-unnecessary-type-casts
  final optionalEmail = ('optional@example.com' as String?)
      .trust('Optional Email')
      .isNotNull()
      .verifyEither()
      .fold(
        (error) => '❌ Optional email validation failed: ${error.message}',
        (value) => '✅ Valid optional email: $value',
      );
  print(optionalEmail);

  // Batch validation
  final batchResult =
      [
        'user@example.com'.trust('Email').isNotEmpty().isEmail(),
        'password123'.trust('Password').isNotEmpty().minLength(8),
        30.trust('Age').min(18).max(65),
      ].verifyEither().fold(
        (error) => '❌ Batch validation failed: ${error.message}',
        (values) =>
            // ignore: avoid-unsafe-collection-methods
            '✅ All fields valid: Email=${values[0]}, Password=${values[1]}, Age=${values[2]}',
      );
  print(batchResult);

  // Custom validation with check()
  final customResult = 'hello world'
      .trust('Custom String')
      .ensure(
        (value) => value.contains('world'),
        (fieldName) => '$fieldName must contain "world"',
      )
      .verifyEither()
      .fold(
        (error) => '❌ Custom validation failed: ${error.message}',
        (value) => '✅ Custom validation passed: $value',
      );
  print(customResult);

  // Async validation with TaskEither
  final asyncResult = await 'async@example.com'
      .trust('Async Email')
      .isNotEmpty()
      .isEmail()
      .toAsync()
      .ensure(
        (email) => Future.value(email.contains('async')),
        (fieldName) => '$fieldName must contain "async"',
      )
      .tryMap((email) async {
        // Simulate async validation
        await Future.delayed(Duration(milliseconds: 100));
        if (email.contains('async')) {
          return email;
        }
        throw Exception('Email must contain "async"');
      }, (fieldName) => '$fieldName must contain "async"')
      .verifyTaskEither()
      .run()
      .then(
        (either) => either.fold(
          (error) => '❌ Async validation failed: ${error.message}',
          (value) => '✅ Async validation passed: $value',
        ),
      );
  print(asyncResult);

  // Async validation with Either
  final asyncEitherResult = await 'async@example.com'
      .trust('Async Email Either')
      .isNotEmpty()
      .isEmail()
      .toAsync()
      .verifyEither()
      .then(
        (either) => either.fold(
          (error) => '❌ Async Either validation failed: ${error.message}',
          (value) => '✅ Async Either validation passed: $value',
        ),
      );
  print(asyncEitherResult);

  // Date and time validation
  final dateResult = '2023-12-25'
      .trust('Date')
      .isIsoDate()
      .verifyEither()
      .fold(
        (error) => '❌ Date validation failed: ${error.message}',
        (value) => '✅ Valid date: $value',
      );
  print(dateResult);

  final timeResult = '14:30'
      .trust('Time')
      .isTime24Hour()
      .verifyEither()
      .fold(
        (error) => '❌ Time validation failed: ${error.message}',
        (value) => '✅ Valid time: $value',
      );
  print(timeResult);

  // Error handling with errorOrNull
  final errorOrNullResult = ''.trust('Empty String').isNotEmpty().errorOrNull();
  print('Error or null result: ${errorOrNullResult ?? 'No error'}');

  // Form validator convenience method
  final formValidatorResult = 'test@example.com'
      .trust('Form Email')
      .isNotEmpty()
      .isEmail()
      .asFormValidator();
  print('Form validator result: ${formValidatorResult ?? 'No error'}');

  // notEmpty with allowWhitespace parameter
  final whitespaceResult = '   '
      .trust('Whitespace String')
      .isNotEmpty(allowWhitespace: true)
      .verifyEither()
      .fold(
        (error) => '❌ Whitespace validation failed: ${error.message}',
        (value) => '✅ Whitespace validation passed: $value',
      );
  print(whitespaceResult);

  // Type conversion with toInt()
  final intConversionResult = '123'
      .trust('Number String')
      .toInt()
      .verifyEither()
      .fold(
        (error) => '❌ Int conversion failed: ${error.message}',
        (value) =>
            '✅ Int conversion passed: $value (type: ${value.runtimeType})',
      );
  print(intConversionResult);

  // String isOneOf validation
  final statusResult = 'active'
      .trust('Status')
      .isOneOf(['active', 'inactive', 'pending'])
      .verifyEither()
      .fold(
        (error) => '❌ Status validation failed: ${error.message}',
        (value) => '✅ Valid status: $value',
      );
  print(statusResult);

  // Case-insensitive string isOneOf validation
  final countryResult = 'USA'
      .trust('Country')
      .isOneOf(['USA', 'UK', 'CANADA'], caseInsensitive: true)
      .verifyEither()
      .fold(
        (error) => '❌ Country validation failed: ${error.message}',
        (value) => '✅ Valid country: $value',
      );
  print(countryResult);

  // Numeric isOneOf validation
  final priorityResult = 3
      .trust('Priority')
      .isOneOf([1, 2, 3, 4, 5])
      .verifyEither()
      .fold(
        (error) => '❌ Priority validation failed: ${error.message}',
        (value) => '✅ Valid priority: $value',
      );
  print(priorityResult);

  // Combined validation with isOneOf
  final userRoleResult = 'admin'
      .trust('Role')
      .isNotEmpty()
      .isOneOf(['admin', 'user', 'moderator'])
      .verifyEither()
      .fold(
        (error) => '❌ Role validation failed: ${error.message}',
        (value) => '✅ Valid role: $value',
      );
  print(userRoleResult);
}
