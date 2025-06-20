import 'package:test/test.dart';
import 'package:fpvalidate/src/string_validators.dart';
import 'package:fpvalidate/src/validation_result.dart';

void main() {
  group('StringValidators', () {
    group('contains', () {
      test('should pass when string contains substring', () {
        final validator = StringValidators.contains('test');
        final result = validator('this is a test string');
        expect(result, isA<ValidationSuccess>());
        expect(
          (result as ValidationSuccess).value,
          equals('this is a test string'),
        );
      });

      test('should fail when string does not contain substring', () {
        final validator = StringValidators.contains('missing');
        final result = validator('this is a test string');
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must contain "missing"'),
        );
      });

      test('should be case sensitive', () {
        final validator = StringValidators.contains('Test');
        final result = validator('this is a test string');
        expect(result, isA<ValidationFailure>());
      });
    });

    group('startsWith', () {
      test('should pass when string starts with prefix', () {
        final validator = StringValidators.startsWith('hello');
        final result = validator('hello world');
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals('hello world'));
      });

      test('should fail when string does not start with prefix', () {
        final validator = StringValidators.startsWith('hello');
        final result = validator('world hello');
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must start with "hello"'),
        );
      });
    });

    group('endsWith', () {
      test('should pass when string ends with suffix', () {
        final validator = StringValidators.endsWith('world');
        final result = validator('hello world');
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals('hello world'));
      });

      test('should fail when string does not end with suffix', () {
        final validator = StringValidators.endsWith('world');
        final result = validator('world hello');
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must end with "world"'),
        );
      });
    });

    group('alphanumeric', () {
      test('should pass for alphanumeric string', () {
        final validator = StringValidators.alphanumeric();
        final result = validator('abc123');
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals('abc123'));
      });

      test('should pass for only letters', () {
        final validator = StringValidators.alphanumeric();
        final result = validator('abcdef');
        expect(result, isA<ValidationSuccess>());
      });

      test('should pass for only numbers', () {
        final validator = StringValidators.alphanumeric();
        final result = validator('123456');
        expect(result, isA<ValidationSuccess>());
      });

      test('should fail for string with special characters', () {
        final validator = StringValidators.alphanumeric();
        final result = validator('abc@123');
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must contain only alphanumeric characters'),
        );
      });

      test('should fail for string with spaces', () {
        final validator = StringValidators.alphanumeric();
        final result = validator('abc 123');
        expect(result, isA<ValidationFailure>());
      });
    });

    group('lettersOnly', () {
      test('should pass for string with only letters', () {
        final validator = StringValidators.lettersOnly();
        final result = validator('abcdef');
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals('abcdef'));
      });

      test('should fail for string with numbers', () {
        final validator = StringValidators.lettersOnly();
        final result = validator('abc123');
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must contain only letters'),
        );
      });

      test('should fail for string with special characters', () {
        final validator = StringValidators.lettersOnly();
        final result = validator('abc@def');
        expect(result, isA<ValidationFailure>());
      });
    });

    group('digitsOnly', () {
      test('should pass for string with only digits', () {
        final validator = StringValidators.digitsOnly();
        final result = validator('123456');
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals('123456'));
      });

      test('should fail for string with letters', () {
        final validator = StringValidators.digitsOnly();
        final result = validator('123abc');
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must contain only digits'),
        );
      });

      test('should fail for string with special characters', () {
        final validator = StringValidators.digitsOnly();
        final result = validator('123@456');
        expect(result, isA<ValidationFailure>());
      });
    });

    group('uuid', () {
      test('should pass for valid UUID', () {
        final validator = StringValidators.uuid();
        final result = validator('123e4567-e89b-12d3-a456-426614174000');
        expect(result, isA<ValidationSuccess>());
        expect(
          (result as ValidationSuccess).value,
          equals('123e4567-e89b-12d3-a456-426614174000'),
        );
      });

      test('should pass for uppercase UUID', () {
        final validator = StringValidators.uuid();
        final result = validator('123E4567-E89B-12D3-A456-426614174000');
        expect(result, isA<ValidationSuccess>());
      });

      test('should fail for invalid UUID format', () {
        final validator = StringValidators.uuid();
        final result = validator('invalid-uuid');
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be a valid UUID'),
        );
      });

      test('should fail for UUID without hyphens', () {
        final validator = StringValidators.uuid();
        final result = validator('123e4567e89b12d3a456426614174000');
        expect(result, isA<ValidationFailure>());
      });
    });

    group('creditCard', () {
      test('should pass for valid credit card number', () {
        final validator = StringValidators.creditCard();
        final result = validator('4111111111111111');
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals('4111111111111111'));
      });

      test('should pass for credit card with spaces', () {
        final validator = StringValidators.creditCard();
        final result = validator('4111 1111 1111 1111');
        expect(result, isA<ValidationSuccess>());
      });

      test('should pass for credit card with dashes', () {
        final validator = StringValidators.creditCard();
        final result = validator('4111-1111-1111-1111');
        expect(result, isA<ValidationSuccess>());
      });

      test('should fail for invalid credit card number', () {
        final validator = StringValidators.creditCard();
        final result = validator('1234');
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be a valid credit card number'),
        );
      });

      test('should fail for credit card with letters', () {
        final validator = StringValidators.creditCard();
        final result = validator('4111abcd11111111');
        expect(result, isA<ValidationFailure>());
      });
    });

    group('postalCode', () {
      test('should pass for 5-digit postal code', () {
        final validator = StringValidators.postalCode();
        final result = validator('12345');
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals('12345'));
      });

      test('should pass for 9-digit postal code', () {
        final validator = StringValidators.postalCode();
        final result = validator('12345-6789');
        expect(result, isA<ValidationSuccess>());
      });

      test('should fail for invalid postal code format', () {
        final validator = StringValidators.postalCode();
        final result = validator('1234');
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be a valid postal code'),
        );
      });

      test('should fail for postal code with letters', () {
        final validator = StringValidators.postalCode();
        final result = validator('1234a');
        expect(result, isA<ValidationFailure>());
      });
    });

    group('isoDate', () {
      test('should pass for valid ISO date', () {
        final validator = StringValidators.isoDate();
        final result = validator('2023-12-25');
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals('2023-12-25'));
      });

      test('should fail for invalid date format', () {
        final validator = StringValidators.isoDate();
        final result = validator('12/25/2023');
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be a valid date in YYYY-MM-DD format'),
        );
      });

      test('should fail for invalid date', () {
        final validator = StringValidators.isoDate();
        final result = validator('2023-13-45');
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be a valid date'),
        );
      });

      test('should fail for date with wrong separators', () {
        final validator = StringValidators.isoDate();
        final result = validator('2023.12.25');
        expect(result, isA<ValidationFailure>());
      });
    });

    group('time24Hour', () {
      test('should pass for valid 24-hour time', () {
        final validator = StringValidators.time24Hour();
        final result = validator('14:30');
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals('14:30'));
      });

      test('should pass for midnight', () {
        final validator = StringValidators.time24Hour();
        final result = validator('00:00');
        expect(result, isA<ValidationSuccess>());
      });

      test('should pass for noon', () {
        final validator = StringValidators.time24Hour();
        final result = validator('12:00');
        expect(result, isA<ValidationSuccess>());
      });

      test('should fail for invalid time format', () {
        final validator = StringValidators.time24Hour();
        final result = validator('2:30 PM');
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be a valid time in HH:MM format'),
        );
      });

      test('should fail for invalid hour', () {
        final validator = StringValidators.time24Hour();
        final result = validator('25:30');
        expect(result, isA<ValidationFailure>());
      });

      test('should fail for invalid minute', () {
        final validator = StringValidators.time24Hour();
        final result = validator('14:60');
        expect(result, isA<ValidationFailure>());
      });
    });
  });
}
