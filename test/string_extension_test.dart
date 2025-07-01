import 'package:test/test.dart';
import 'package:fpvalidate/fpvalidate.dart';

void main() {
  group('StringExtension', () {
    group('notEmpty', () {
      test('should succeed with non-empty string', () {
        final result = 'test'.field('String').notEmpty().validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('test')),
        );
      });

      test('should fail with empty string', () {
        final result = ''.field('String').notEmpty().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(error.message, equals('Field String is empty'));
        }, (value) => fail('Should return error'));
      });

      test('should fail with whitespace-only string by default', () {
        final result = '   '.field('String').notEmpty().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(error.message, equals('Field String is empty'));
        }, (value) => fail('Should return error'));
      });

      test(
        'should succeed with whitespace-only string when allowWhitespace is true',
        () {
          final result = '   '
              .field('String')
              .notEmpty(allowWhitespace: true)
              .validateEither();
          expect(result.isRight(), isTrue);
          result.fold(
            (error) => fail('Should not return error'),
            (value) => expect(value, equals('   ')),
          );
        },
      );

      test('should succeed with string containing whitespace and content', () {
        final result = '  test  '.field('String').notEmpty().validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('  test  ')),
        );
      });
    });

    group('toInt', () {
      test('should succeed with valid integer string', () {
        final result = '123'.field('Number').toInt().validateEither();
        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (value) {
          expect(value, isA<int>());
          expect(value, equals(123));
        });
      });

      test('should succeed with negative integer string', () {
        final result = '-123'.field('Number').toInt().validateEither();
        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (value) {
          expect(value, isA<int>());
          expect(value, equals(-123));
        });
      });

      test('should fail with non-integer string', () {
        final result = 'abc'.field('Number').toInt().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(
            error.message,
            equals('Value abc for field Number is not a number'),
          );
        }, (value) => fail('Should return error'));
      });

      test('should fail with decimal string', () {
        final result = '123.45'.field('Number').toInt().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(
            error.message,
            equals('Value 123.45 for field Number is not a number'),
          );
        }, (value) => fail('Should return error'));
      });

      test('should transform type from String to int', () {
        final result = '100'.field('Number').toInt().min(50).validateEither();
        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (value) {
          expect(value, isA<int>());
          expect(value, equals(100));
        });
      });
    });

    group('minLength', () {
      test('should succeed when string length equals min', () {
        final result = 'test'.field('String').minLength(4).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('test')),
        );
      });

      test('should succeed when string length is greater than min', () {
        final result = 'testing'.field('String').minLength(4).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('testing')),
        );
      });

      test('should fail when string length is less than min', () {
        final result = 'abc'.field('String').minLength(4).validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(
            error.message,
            equals('String must be at least 4 characters long'),
          );
        }, (value) => fail('Should return error'));
      });

      test('should work with zero min length', () {
        final result = 'test'.field('String').minLength(0).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('test')),
        );
      });
    });

    group('maxLength', () {
      test('should succeed when string length equals max', () {
        final result = 'test'.field('String').maxLength(4).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('test')),
        );
      });

      test('should succeed when string length is less than max', () {
        final result = 'abc'.field('String').maxLength(4).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('abc')),
        );
      });

      test('should fail when string length is greater than max', () {
        final result = 'testing'.field('String').maxLength(4).validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(
            error.message,
            equals('String must be no more than 4 characters long'),
          );
        }, (value) => fail('Should return error'));
      });
    });

    group('isEmail', () {
      test('should succeed with valid email addresses', () {
        final validEmails = [
          'test@example.com',
          'user.name@domain.co.uk',
          'user+tag@example.org',
          '123@example.com',
          'user@subdomain.example.com',
        ];

        for (final email in validEmails) {
          final result = email.field('Email').isEmail().validateEither();
          expect(result.isRight(), isTrue, reason: '$email should be valid');
          result.fold(
            (error) => fail('$email should be valid'),
            (value) => expect(value, equals(email)),
          );
        }
      });

      test('should fail with invalid email addresses', () {
        final invalidEmails = [
          'invalid',
          '@example.com',
          'user@',
          'user..name@example.com',
          'user@.com',
          'user@example.',
          'user name@example.com',
        ];

        for (final email in invalidEmails) {
          final result = email.field('Email').isEmail().validateEither();
          expect(result.isLeft(), isTrue, reason: '$email should be invalid');
          result.fold((error) {
            expect(error.fieldName, equals('Email'));
            expect(
              error.message,
              equals('Email must be a valid email address'),
            );
          }, (value) => fail('$email should be invalid'));
        }
      });
    });

    group('isUrl', () {
      test('should succeed with valid URLs', () {
        final validUrls = [
          'https://example.com',
          'http://example.com',
          'https://www.example.com',
          'https://example.com/path',
          'https://example.com/path?param=value',
          'https://example.com:8080',
          'ftp://example.com',
        ];

        for (final url in validUrls) {
          final result = url.field('URL').isUrl().validateEither();
          expect(result.isRight(), isTrue, reason: '$url should be valid');
          result.fold(
            (error) => fail('$url should be valid'),
            (value) => expect(value, equals(url)),
          );
        }
      });

      test('should fail with invalid URLs', () {
        final invalidUrls = [
          'not-a-url',
          'example.com',
          'http://',
          'https://',
          'ftp://',
        ];

        for (final url in invalidUrls) {
          final result = url.field('URL').isUrl().validateEither();
          expect(result.isLeft(), isTrue, reason: '$url should be invalid');
          result.fold((error) {
            expect(error.fieldName, equals('URL'));
            expect(error.message, equals('URL must be a valid URL'));
          }, (value) => fail('$url should be invalid'));
        }
      });
    });

    group('isPhone', () {
      test('should succeed with valid phone numbers', () {
        final validPhones = [
          '+1-555-123-4567',
          '1-555-123-4567',
          '555-123-4567',
          '(555) 123-4567',
          '555.123.4567',
          '5551234567',
          '+44 20 7946 0958',
          '+1 (555) 123-4567',
        ];

        for (final phone in validPhones) {
          final result = phone.field('Phone').isPhone().validateEither();
          expect(result.isRight(), isTrue, reason: '$phone should be valid');
          result.fold(
            (error) => fail('$phone should be valid'),
            (value) => expect(value, equals(phone)),
          );
        }
      });

      test('should fail with invalid phone numbers', () {
        final invalidPhones = [
          'not-a-phone',
          '123',
          'abc-def-ghij',
          '555-123',
          '555-123-456',
        ];

        for (final phone in invalidPhones) {
          final result = phone.field('Phone').isPhone().validateEither();
          expect(result.isLeft(), isTrue, reason: '$phone should be invalid');
          result.fold((error) {
            expect(error.fieldName, equals('Phone'));
            expect(error.message, equals('Phone must be a valid phone number'));
          }, (value) => fail('$phone should be invalid'));
        }
      });
    });

    group('isPattern', () {
      test('should succeed when string matches pattern', () {
        final result = 'abc123'
            .field('String')
            .isPattern(
              RegExp(r'^[a-z0-9]+$'),
              'lowercase letters and digits only',
            )
            .validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('abc123')),
        );
      });

      test('should fail when string does not match pattern', () {
        final result = 'ABC123'
            .field('String')
            .isPattern(
              RegExp(r'^[a-z0-9]+$'),
              'lowercase letters and digits only',
            )
            .validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(
            error.message,
            equals(
              'String must match pattern: lowercase letters and digits only',
            ),
          );
        }, (value) => fail('Should return error'));
      });
    });

    group('contains', () {
      test('should succeed when string contains substring', () {
        final result = 'Hello World'
            .field('String')
            .contains('World')
            .validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('Hello World')),
        );
      });

      test('should fail when string does not contain substring', () {
        final result = 'Hello World'
            .field('String')
            .contains('Universe')
            .validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(error.message, equals('String must contain "Universe"'));
        }, (value) => fail('Should return error'));
      });

      test('should work with empty substring', () {
        final result = 'Hello World'
            .field('String')
            .contains('')
            .validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('Hello World')),
        );
      });
    });

    group('startsWith', () {
      test('should succeed when string starts with prefix', () {
        final result = 'Hello World'
            .field('String')
            .startsWith('Hello')
            .validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('Hello World')),
        );
      });

      test('should fail when string does not start with prefix', () {
        final result = 'Hello World'
            .field('String')
            .startsWith('World')
            .validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(error.message, equals('String must start with "World"'));
        }, (value) => fail('Should return error'));
      });
    });

    group('endsWith', () {
      test('should succeed when string ends with suffix', () {
        final result = 'Hello World'
            .field('String')
            .endsWith('World')
            .validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('Hello World')),
        );
      });

      test('should fail when string does not end with suffix', () {
        final result = 'Hello World'
            .field('String')
            .endsWith('Hello')
            .validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(error.message, equals('String must end with "Hello"'));
        }, (value) => fail('Should return error'));
      });
    });

    group('alphanumeric', () {
      test('should succeed with alphanumeric string', () {
        final result = 'abc123'.field('String').alphanumeric().validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('abc123')),
        );
      });

      test('should fail with non-alphanumeric string', () {
        final result = 'abc-123'
            .field('String')
            .alphanumeric()
            .validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(
            error.message,
            equals('String must contain only alphanumeric characters'),
          );
        }, (value) => fail('Should return error'));
      });

      test('should fail with empty string', () {
        final result = ''.field('String').alphanumeric().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(
            error.message,
            equals('String must contain only alphanumeric characters'),
          );
        }, (value) => fail('Should return error'));
      });
    });

    group('lettersOnly', () {
      test('should succeed with letters-only string', () {
        final result = 'abcdef'.field('String').lettersOnly().validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('abcdef')),
        );
      });

      test('should fail with string containing non-letters', () {
        final result = 'abc123'.field('String').lettersOnly().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(error.message, equals('String must contain only letters'));
        }, (value) => fail('Should return error'));
      });

      test('should fail with empty string', () {
        final result = ''.field('String').lettersOnly().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(error.message, equals('String must contain only letters'));
        }, (value) => fail('Should return error'));
      });
    });

    group('digitsOnly', () {
      test('should succeed with digits-only string', () {
        final result = '123456'.field('String').digitsOnly().validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('123456')),
        );
      });

      test('should fail with string containing non-digits', () {
        final result = '123abc'.field('String').digitsOnly().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(error.message, equals('String must contain only digits'));
        }, (value) => fail('Should return error'));
      });

      test('should fail with empty string', () {
        final result = ''.field('String').digitsOnly().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(error.message, equals('String must contain only digits'));
        }, (value) => fail('Should return error'));
      });
    });

    group('isUuid', () {
      test('should succeed with valid UUIDs', () {
        final validUuids = [
          '550e8400-e29b-41d4-a716-446655440000',
          '550E8400-E29B-41D4-A716-446655440000',
          '123e4567-e89b-12d3-a456-426614174000',
          'a1a2a3a4-b1b2-c1c2-d1d2-d3d4d5d6d7d8',
        ];

        for (final uuid in validUuids) {
          final result = uuid.field('UUID').isUuid().validateEither();
          expect(result.isRight(), isTrue, reason: '$uuid should be valid');
          result.fold(
            (error) => fail('$uuid should be valid'),
            (value) => expect(value, equals(uuid)),
          );
        }
      });

      test('should fail with invalid UUIDs', () {
        final invalidUuids = [
          'not-a-uuid',
          '550e8400-e29b-41d4-a716-44665544000', // too short
          '550e8400-e29b-41d4-a716-4466554400000', // too long
          '550e8400-e29b-41d4-a716-44665544000g', // invalid character
        ];

        for (final uuid in invalidUuids) {
          final result = uuid.field('UUID').isUuid().validateEither();
          expect(result.isLeft(), isTrue, reason: '$uuid should be invalid');
          result.fold((error) {
            expect(error.fieldName, equals('UUID'));
            expect(error.message, equals('UUID must be a valid UUID'));
          }, (value) => fail('$uuid should be invalid'));
        }
      });
    });

    group('isCreditCard', () {
      test('should succeed with valid credit card numbers', () {
        final validCards = [
          '4111111111111111', // Visa
          '5555555555554444', // MasterCard
          '378282246310005', // American Express
          '6011111111111117', // Discover
          '4111 1111 1111 1111', // Visa with spaces
          '5555 5555 5555 4444', // MasterCard with spaces
        ];

        for (final card in validCards) {
          final result = card.field('Card').isCreditCard().validateEither();
          expect(result.isRight(), isTrue, reason: '$card should be valid');
          result.fold(
            (error) => fail('$card should be valid'),
            (value) => expect(value, equals(card)),
          );
        }
      });

      test('should fail with invalid credit card numbers', () {
        final invalidCards = [
          'not-a-card',
          '1234567890123456',
          '4111111111111112', // invalid checksum
          '1234',
          '12345678901234567890',
        ];

        for (final card in invalidCards) {
          final result = card.field('Card').isCreditCard().validateEither();
          expect(result.isLeft(), isTrue, reason: '$card should be invalid');
          result.fold((error) {
            expect(error.fieldName, equals('Card'));
            expect(
              error.message,
              equals('Card must be a valid credit card number'),
            );
          }, (value) => fail('$card should be invalid'));
        }
      });
    });

    group('isPostalCode', () {
      test('should succeed with valid postal codes', () {
        final validCodes = [
          '12345', // US ZIP
          '12345-6789', // US ZIP+4
          'A1A 1A1', // Canadian
          'SW1A 1AA', // UK
          '123456', // Generic 6-digit
        ];

        for (final code in validCodes) {
          final result = code
              .field('PostalCode')
              .isPostalCode()
              .validateEither();
          expect(result.isRight(), isTrue, reason: '$code should be valid');
          result.fold(
            (error) => fail('$code should be valid'),
            (value) => expect(value, equals(code)),
          );
        }
      });

      test('should fail with invalid postal codes', () {
        final invalidCodes = [
          'not-a-code',
          '123',
          '123456789',
          'ABC',
          '12345-', // incomplete ZIP+4
        ];

        for (final code in invalidCodes) {
          final result = code
              .field('PostalCode')
              .isPostalCode()
              .validateEither();
          expect(result.isLeft(), isTrue, reason: '$code should be invalid');
          result.fold((error) {
            expect(error.fieldName, equals('PostalCode'));
            expect(
              error.message,
              equals('PostalCode must be a valid postal code'),
            );
          }, (value) => fail('$code should be invalid'));
        }
      });
    });

    group('isIsoDate', () {
      test('should succeed with valid ISO dates', () {
        final validDates = [
          '2023-01-01',
          '2023-12-31',
          '2020-02-29', // leap year
          '2000-01-01',
          '9999-12-31',
        ];

        for (final date in validDates) {
          final result = date.field('Date').isIsoDate().validateEither();
          expect(result.isRight(), isTrue, reason: '$date should be valid');
          result.fold(
            (error) => fail('$date should be valid'),
            (value) => expect(value, equals(date)),
          );
        }
      });

      test('should fail with invalid ISO dates', () {
        final invalidDates = [
          'not-a-date',
          '2023-13-01', // invalid month
          '2023-01-32', // invalid day
          '2023-02-30', // invalid day for February
          '2023/01/01', // wrong format
          '01-01-2023', // wrong format
          '2023-1-1', // missing leading zeros
          '2023-00-01', // invalid month
          '2023-01-00', // invalid day
        ];

        for (final date in invalidDates) {
          final result = date.field('Date').isIsoDate().validateEither();
          expect(result.isLeft(), isTrue, reason: '$date should be invalid');
          result.fold((error) {
            expect(error.fieldName, equals('Date'));
            expect(
              error.message,
              anyOf(
                equals('Date must be in ISO date format (YYYY-MM-DD)'),
                equals('Date must be a valid date'),
              ),
            );
          }, (value) => fail('$date should be invalid'));
        }
      });

      test('should fail with non-leap year February 29', () {
        final result = '2023-02-29'.field('Date').isIsoDate().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Date'));
          expect(error.message, equals('Date must be a valid date'));
        }, (value) => fail('Should return error'));
      });
    });

    group('isTime24Hour', () {
      test('should succeed with valid 24-hour times', () {
        final validTimes = [
          '00:00',
          '12:00',
          '23:59',
          '09:30',
          '15:45',
          '00:30',
          '23:00',
        ];

        for (final time in validTimes) {
          final result = time.field('Time').isTime24Hour().validateEither();
          expect(result.isRight(), isTrue, reason: '$time should be valid');
          result.fold(
            (error) => fail('$time should be valid'),
            (value) => expect(value, equals(time)),
          );
        }
      });

      test('should fail with invalid 24-hour times', () {
        final invalidTimes = [
          'not-a-time',
          '24:00', // invalid hour
          '12:60', // invalid minute
          '25:00', // invalid hour
          '12:99', // invalid minute
          '1:30', // missing leading zero
          '12:5', // missing leading zero
          '12:30 PM', // 12-hour format
          '12:30am', // 12-hour format
        ];

        for (final time in invalidTimes) {
          final result = time
              .field('Time')
              .isTime24Hour(requireLeadingZero: true)
              .validateEither();
          expect(result.isLeft(), isTrue, reason: '$time should be invalid');
          result.fold((error) {
            expect(error.fieldName, equals('Time'));
            if (time == '1:30') {
              expect(
                error.message,
                equals(
                  'Time must be in 24-hour format (HH:MM) with leading zeros',
                ),
              );
            } else {
              expect(
                error.message,
                equals('Time must be in 24-hour format (HH:MM)'),
              );
            }
          }, (value) => fail('$time should be invalid'));
        }
      });
    });

    group('chaining', () {
      test('should work with multiple validators', () {
        final result = 'test@example.com'
            .field('Email')
            .notEmpty()
            .isEmail()
            .minLength(10)
            .validateEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('test@example.com')),
        );
      });

      test('should fail on first validation failure', () {
        final result = 'test@example.com'
            .field('Email')
            .notEmpty()
            .isEmail()
            .minLength(20) // This will fail
            .validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Email'));
          expect(
            error.message,
            equals('Email must be at least 20 characters long'),
          );
        }, (value) => fail('Should return error'));
      });

      test('should work with type transformation', () {
        final result = '123'
            .field('Number')
            .notEmpty()
            .toInt()
            .min(100)
            .max(200)
            .validateEither();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (value) {
          expect(value, isA<int>());
          expect(value, equals(123));
        });
      });
    });

    group('isOneOf', () {
      test('should succeed when string is in allowed values list', () {
        final result = 'active'.field('Status').isOneOf([
          'active',
          'inactive',
          'pending',
        ]).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('active')),
        );
      });

      test('should fail when string is not in allowed values list', () {
        final result = 'invalid'.field('Status').isOneOf([
          'active',
          'inactive',
          'pending',
        ]).validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Status'));
          expect(
            error.message,
            equals('Status must be one of: active, inactive, pending'),
          );
        }, (value) => fail('Should return error'));
      });

      test('should succeed with case-insensitive comparison', () {
        final result = 'ACTIVE'.field('Status').isOneOf([
          'active',
          'inactive',
        ], caseInsensitive: true).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('ACTIVE')),
        );
      });

      test('should fail with case-sensitive comparison by default', () {
        final result = 'ACTIVE'.field('Status').isOneOf([
          'active',
          'inactive',
        ]).validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Status'));
          expect(
            error.message,
            equals('Status must be one of: active, inactive'),
          );
        }, (value) => fail('Should return error'));
      });

      test('should work with single allowed value', () {
        final result = 'test'.field('String').isOneOf([
          'test',
        ]).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('test')),
        );
      });

      test('should work with empty list (always fails)', () {
        final result = 'test'
            .field('String')
            .isOneOf(<String>[])
            .validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(error.message, equals('String must be one of: '));
        }, (value) => fail('Should return error'));
      });

      test('should work with mixed case values in case-insensitive mode', () {
        final result = 'MixedCase'.field('String').isOneOf([
          'mixedcase',
          'MIXEDCASE',
          'MixedCase',
        ], caseInsensitive: true).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('MixedCase')),
        );
      });
    });

    group('isNoneOf', () {
      test('should succeed when string is not in forbidden values list', () {
        final result = 'valid'.field('Username').isNoneOf([
          'admin',
          'root',
          'system',
        ]).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('valid')),
        );
      });

      test('should fail when string is in forbidden values list', () {
        final result = 'admin'.field('Username').isNoneOf([
          'admin',
          'root',
          'system',
        ]).validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Username'));
          expect(
            error.message,
            equals('Username must not be one of: admin, root, system'),
          );
        }, (value) => fail('Should return error'));
      });

      test('should succeed with case-insensitive comparison', () {
        final result = 'VALID'.field('Username').isNoneOf([
          'admin',
          'root',
        ], caseInsensitive: true).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('VALID')),
        );
      });

      test(
        'should fail with case-insensitive comparison when value matches',
        () {
          final result = 'ADMIN'.field('Username').isNoneOf([
            'admin',
            'root',
          ], caseInsensitive: true).validateEither();
          expect(result.isLeft(), isTrue);
          result.fold((error) {
            expect(error.fieldName, equals('Username'));
            expect(
              error.message,
              equals('Username must not be one of: admin, root'),
            );
          }, (value) => fail('Should return error'));
        },
      );

      test('should succeed with case-sensitive comparison by default', () {
        final result = 'ADMIN'.field('Username').isNoneOf([
          'admin',
          'root',
        ]).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('ADMIN')),
        );
      });

      test('should work with single forbidden value', () {
        final result = 'test'.field('String').isNoneOf([
          'forbidden',
        ]).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('test')),
        );
      });

      test('should work with empty list (always succeeds)', () {
        final result = 'test'
            .field('String')
            .isNoneOf(<String>[])
            .validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('test')),
        );
      });

      test('should work with mixed case values in case-insensitive mode', () {
        final result = 'ValidCase'.field('String').isNoneOf([
          'validcase',
          'VALIDCASE',
          'ValidCase',
        ], caseInsensitive: true).validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(
            error.message,
            equals(
              'String must not be one of: validcase, VALIDCASE, ValidCase',
            ),
          );
        }, (value) => fail('Should return error'));
      });

      test('should work with special characters in forbidden values', () {
        final result = 'user@domain.com'.field('Email').isNoneOf([
          'admin@domain.com',
          'root@domain.com',
        ]).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('user@domain.com')),
        );
      });

      test('should fail with special characters when value matches', () {
        final result = 'admin@domain.com'.field('Email').isNoneOf([
          'admin@domain.com',
          'root@domain.com',
        ]).validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Email'));
          expect(
            error.message,
            equals(
              'Email must not be one of: admin@domain.com, root@domain.com',
            ),
          );
        }, (value) => fail('Should return error'));
      });
    });
  });
}
