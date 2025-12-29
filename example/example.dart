import 'package:trust_but_verify/trust_but_verify.dart';

void main() async {
  print('=== trust_but_verify Examples ===\n');

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
  try {
    // ignore: avoid-unnecessary-type-casts
    final optionalEmail = ('optional@example.com' as String?)
        .trust('Optional Email')
        .isNotNull()
        .verify();
    print('✅ Valid optional email: $optionalEmail');
  } catch (e) {
    if (e is ValidationError) {
      print('❌ Optional email validation failed: ${e.message}');
    }
  }

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

  // Async validation with Future
  try {
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
        .verify();
    print('✅ Async validation passed: $asyncResult');
  } catch (e) {
    if (e is ValidationError) {
      print('❌ Async validation failed: ${e.message}');
    }
  }

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
  try {
    final date = '2023-12-25'.trust('Date').isIsoDate().verify();
    print('✅ Valid date: $date');

    final time = '14:30'.trust('Time').isTime24Hour().verify();
    print('✅ Valid time: $time');
  } catch (e) {
    if (e is ValidationError) {
      print('❌ Date/Time validation failed: ${e.message}');
    }
  }

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

  // Additional validators with verify()
  try {
    final whitespace = '   '
        .trust('Whitespace String')
        .isNotEmpty(allowWhitespace: true)
        .verify();
    print('✅ Whitespace validation passed: $whitespace');

    final intVal = '123'.trust('Number String').toInt().verify();
    print('✅ Int conversion passed: $intVal');

    final role = 'admin'.trust('Role').isNotEmpty().isOneOf([
      'admin',
      'user',
      'moderator',
    ]).verify();
    print('✅ Valid role: $role');
  } catch (e) {
    if (e is ValidationError) {
      print('❌ Validation failed: ${e.message}');
    }
  }
}
