import 'package:test/test.dart';
import 'package:fpvalidate/src/nullable_validators.dart';
import 'package:fpvalidate/src/validation_result.dart';

void main() {
  group('NullableValidators', () {
    group('ifPresent', () {
      test('should pass for null value', () {
        final validator = NullableValidators.ifPresent(
          (value) => ValidationFailure('Should not be called'),
        );
        final result = validator(null);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, isNull);
      });

      test(
        'should apply validator for non-null value when validator succeeds',
        () {
          final validator = NullableValidators.ifPresent(
            (value) => ValidationSuccess(value),
          );
          final result = validator('test');
          expect(result, isA<ValidationSuccess>());
          expect((result as ValidationSuccess).value, equals('test'));
        },
      );

      test(
        'should apply validator for non-null value when validator fails',
        () {
          final validator = NullableValidators.ifPresent(
            (value) => ValidationFailure('Validation failed'),
          );
          final result = validator('test');
          expect(result, isA<ValidationFailure>());
          expect(
            (result as ValidationFailure).message,
            equals('Validation failed'),
          );
        },
      );
    });

    group('optional', () {
      test('should pass for null value', () {
        final validator = NullableValidators.optional(
          (value) => ValidationFailure('Should not be called'),
        );
        final result = validator(null);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, isNull);
      });

      test('should apply validator for non-null value', () {
        final validator = NullableValidators.optional(
          (value) => ValidationSuccess(value),
        );
        final result = validator('test');
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals('test'));
      });
    });

    group('required', () {
      test('should fail for null value', () {
        final validator = NullableValidators.required(
          (value) => ValidationSuccess(value),
        );
        final result = validator(null);
        expect(result, isA<ValidationFailure>());
        expect((result as ValidationFailure).message, equals('cannot be null'));
      });

      test(
        'should apply validator for non-null value when validator succeeds',
        () {
          final validator = NullableValidators.required(
            (value) => ValidationSuccess(value),
          );
          final result = validator('test');
          expect(result, isA<ValidationSuccess>());
          expect((result as ValidationSuccess).value, equals('test'));
        },
      );

      test(
        'should apply validator for non-null value when validator fails',
        () {
          final validator = NullableValidators.required(
            (value) => ValidationFailure('Validation failed'),
          );
          final result = validator('test');
          expect(result, isA<ValidationFailure>());
          expect(
            (result as ValidationFailure).message,
            equals('Validation failed'),
          );
        },
      );
    });

    group('optionalNotEmpty', () {
      test('should pass for null value', () {
        final validator = NullableValidators.optionalNotEmpty();
        final result = validator(null);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, isNull);
      });

      test('should pass for non-empty string', () {
        final validator = NullableValidators.optionalNotEmpty();
        final result = validator('test');
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals('test'));
      });

      test('should fail for empty string', () {
        final validator = NullableValidators.optionalNotEmpty();
        final result = validator('');
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('cannot be empty if provided'),
        );
      });
    });

    group('optionalEmail', () {
      test('should pass for null value', () {
        final validator = NullableValidators.optionalEmail();
        final result = validator(null);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, isNull);
      });

      test('should pass for valid email', () {
        final validator = NullableValidators.optionalEmail();
        final result = validator('test@example.com');
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals('test@example.com'));
      });

      test('should fail for invalid email', () {
        final validator = NullableValidators.optionalEmail();
        final result = validator('invalid-email');
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be a valid email format if provided'),
        );
      });
    });

    group('optionalUrl', () {
      test('should pass for null value', () {
        final validator = NullableValidators.optionalUrl();
        final result = validator(null);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, isNull);
      });

      test('should pass for valid URL', () {
        final validator = NullableValidators.optionalUrl();
        final result = validator('https://example.com');
        expect(result, isA<ValidationSuccess>());
        expect(
          (result as ValidationSuccess).value,
          equals('https://example.com'),
        );
      });

      test('should fail for invalid URL', () {
        final validator = NullableValidators.optionalUrl();
        final result = validator('not-a-url');
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be a valid URL format if provided'),
        );
      });
    });

    group('optionalPhone', () {
      test('should pass for null value', () {
        final validator = NullableValidators.optionalPhone();
        final result = validator(null);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, isNull);
      });

      test('should pass for valid phone number', () {
        final validator = NullableValidators.optionalPhone();
        final result = validator('+1234567890');
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals('+1234567890'));
      });

      test('should fail for invalid phone number', () {
        final validator = NullableValidators.optionalPhone();
        final result = validator('abc123');
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be a valid phone number format if provided'),
        );
      });
    });

    group('optionalInRange', () {
      test('should pass for null value', () {
        final validator = NullableValidators.optionalInRange(1, 10);
        final result = validator(null);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, isNull);
      });

      test('should pass for value within range', () {
        final validator = NullableValidators.optionalInRange(1, 10);
        final result = validator(5);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals(5));
      });

      test('should pass for value at range boundaries', () {
        final validator = NullableValidators.optionalInRange(1, 10);
        final result1 = validator(1);
        final result2 = validator(10);
        expect(result1, isA<ValidationSuccess>());
        expect(result2, isA<ValidationSuccess>());
      });

      test('should fail for value below range', () {
        final validator = NullableValidators.optionalInRange(1, 10);
        final result = validator(0);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be between 1 and 10 if provided'),
        );
      });

      test('should fail for value above range', () {
        final validator = NullableValidators.optionalInRange(1, 10);
        final result = validator(11);
        expect(result, isA<ValidationFailure>());
      });
    });

    group('optionalMinLength', () {
      test('should pass for null value', () {
        final validator = NullableValidators.optionalMinLength(5);
        final result = validator(null);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, isNull);
      });

      test('should pass for string with sufficient length', () {
        final validator = NullableValidators.optionalMinLength(5);
        final result = validator('test123');
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals('test123'));
      });

      test('should pass for string with exact length', () {
        final validator = NullableValidators.optionalMinLength(5);
        final result = validator('test1');
        expect(result, isA<ValidationSuccess>());
      });

      test('should fail for string that is too short', () {
        final validator = NullableValidators.optionalMinLength(5);
        final result = validator('test');
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be at least 5 characters if provided'),
        );
      });
    });

    group('optionalMaxLength', () {
      test('should pass for null value', () {
        final validator = NullableValidators.optionalMaxLength(10);
        final result = validator(null);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, isNull);
      });

      test('should pass for string within length limit', () {
        final validator = NullableValidators.optionalMaxLength(10);
        final result = validator('test');
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals('test'));
      });

      test('should pass for string with exact length', () {
        final validator = NullableValidators.optionalMaxLength(10);
        final result = validator('test123456');
        expect(result, isA<ValidationSuccess>());
      });

      test('should fail for string that is too long', () {
        final validator = NullableValidators.optionalMaxLength(10);
        final result = validator('very long string');
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be no more than 10 characters if provided'),
        );
      });
    });
  });
}
