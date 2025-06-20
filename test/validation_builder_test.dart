import 'package:test/test.dart';
import 'package:fpvalidate/src/validation_builder.dart';
import 'package:fpvalidate/src/validation_error.dart';
import 'package:fpvalidate/src/validation_result.dart';
import 'package:fpvalidate/src/validation_extension.dart';

void main() {
  group('ValidationBuilder', () {
    group('Constructor', () {
      test('should create a validation builder with value and field name', () {
        final builder = ValidationBuilder('test', 'Test Field');
        expect(builder.value, equals('test'));
        expect(builder.fieldName, equals('Test Field'));
      });
    });

    group('notEmpty', () {
      test('should pass for non-empty string', () {
        final result = 'test'.field('Test').notEmpty().validate();
        expect(result, equals('test'));
      });

      test('should fail for empty string', () {
        expect(
          () => ''.field('Test').notEmpty().validate(),
          throwsA(isA<ValidationError>()),
        );
      });

      test('should fail for whitespace-only string', () {
        expect(
          () => '   '.field('Test').notEmpty().validate(),
          throwsA(isA<ValidationError>()),
        );
      });

      test('should work with non-string types', () {
        final result = 42.field('Number').notEmpty().validate();
        expect(result, equals(42));
      });
    });

    group('minLength', () {
      test('should pass for string with sufficient length', () {
        final result = 'test123'.field('Test').minLength(5).validate();
        expect(result, equals('test123'));
      });

      test('should fail for string that is too short', () {
        expect(
          () => 'test'.field('Test').minLength(5).validate(),
          throwsA(isA<ValidationError>()),
        );
      });

      test('should work with non-string types', () {
        final result = 12345.field('Number').minLength(3).validate();
        expect(result, equals(12345));
      });
    });

    group('maxLength', () {
      test('should pass for string within length limit', () {
        final result = 'test'.field('Test').maxLength(10).validate();
        expect(result, equals('test'));
      });

      test('should fail for string that is too long', () {
        expect(
          () => 'very long string'.field('Test').maxLength(10).validate(),
          throwsA(isA<ValidationError>()),
        );
      });
    });

    group('pattern', () {
      test('should pass for string matching pattern', () {
        final result = 'abc123'
            .field('Test')
            .pattern(RegExp(r'^[a-z0-9]+$'), 'alphanumeric')
            .validate();
        expect(result, equals('abc123'));
      });

      test('should fail for string not matching pattern', () {
        expect(
          () => 'abc@123'
              .field('Test')
              .pattern(RegExp(r'^[a-z0-9]+$'), 'alphanumeric')
              .validate(),
          throwsA(isA<ValidationError>()),
        );
      });
    });

    group('email', () {
      test('should pass for valid email', () {
        final result = 'test@example.com'.field('Email').email().validate();
        expect(result, equals('test@example.com'));
      });

      test('should fail for invalid email', () {
        expect(
          () => 'invalid-email'.field('Email').email().validate(),
          throwsA(isA<ValidationError>()),
        );
      });

      test('should fail for email without @', () {
        expect(
          () => 'testexample.com'.field('Email').email().validate(),
          throwsA(isA<ValidationError>()),
        );
      });

      test('should fail for email without domain', () {
        expect(
          () => 'test@'.field('Email').email().validate(),
          throwsA(isA<ValidationError>()),
        );
      });
    });

    group('url', () {
      test('should pass for valid URL', () {
        final result = 'https://example.com'.field('URL').url().validate();
        expect(result, equals('https://example.com'));
      });

      test('should pass for HTTP URL', () {
        final result = 'http://example.com'.field('URL').url().validate();
        expect(result, equals('http://example.com'));
      });

      test('should fail for invalid URL', () {
        expect(
          () => 'not-a-url'.field('URL').url().validate(),
          throwsA(isA<ValidationError>()),
        );
      });
    });

    group('phone', () {
      test('should pass for valid phone number', () {
        final result = '+1234567890'.field('Phone').phone().validate();
        expect(result, equals('+1234567890'));
      });

      test('should pass for phone number without +', () {
        final result = '1234567890'.field('Phone').phone().validate();
        expect(result, equals('1234567890'));
      });

      test('should fail for invalid phone number', () {
        expect(
          () => 'abc123'.field('Phone').phone().validate(),
          throwsA(isA<ValidationError>()),
        );
      });
    });

    group('min', () {
      test('should pass for number greater than minimum', () {
        final result = '10'.field('Number').min(5).validate();
        expect(result, equals('10'));
      });

      test('should pass for number equal to minimum', () {
        final result = '5'.field('Number').min(5).validate();
        expect(result, equals('5'));
      });

      test('should fail for number less than minimum', () {
        expect(
          () => '3'.field('Number').min(5).validate(),
          throwsA(isA<ValidationError>()),
        );
      });

      test('should fail for non-numeric string', () {
        expect(
          () => 'abc'.field('Number').min(5).validate(),
          throwsA(isA<ValidationError>()),
        );
      });
    });

    group('max', () {
      test('should pass for number less than maximum', () {
        final result = '5'.field('Number').max(10).validate();
        expect(result, equals('5'));
      });

      test('should pass for number equal to maximum', () {
        final result = '10'.field('Number').max(10).validate();
        expect(result, equals('10'));
      });

      test('should fail for number greater than maximum', () {
        expect(
          () => '15'.field('Number').max(10).validate(),
          throwsA(isA<ValidationError>()),
        );
      });
    });

    group('inRange', () {
      test('should pass for number within range', () {
        final result = '5'.field('Number').inRange(1, 10).validate();
        expect(result, equals('5'));
      });

      test('should pass for number at range boundaries', () {
        final result1 = '1'.field('Number').inRange(1, 10).validate();
        final result2 = '10'.field('Number').inRange(1, 10).validate();
        expect(result1, equals('1'));
        expect(result2, equals('10'));
      });

      test('should fail for number below range', () {
        expect(
          () => '0'.field('Number').inRange(1, 10).validate(),
          throwsA(isA<ValidationError>()),
        );
      });

      test('should fail for number above range', () {
        expect(
          () => '11'.field('Number').inRange(1, 10).validate(),
          throwsA(isA<ValidationError>()),
        );
      });
    });

    group('positive', () {
      test('should pass for positive number', () {
        final result = '5'.field('Number').positive().validate();
        expect(result, equals('5'));
      });

      test('should fail for zero', () {
        expect(
          () => '0'.field('Number').positive().validate(),
          throwsA(isA<ValidationError>()),
        );
      });

      test('should fail for negative number', () {
        expect(
          () => '-5'.field('Number').positive().validate(),
          throwsA(isA<ValidationError>()),
        );
      });
    });

    group('negative', () {
      test('should pass for negative number', () {
        final result = '-5'.field('Number').negative().validate();
        expect(result, equals('-5'));
      });

      test('should fail for zero', () {
        expect(
          () => '0'.field('Number').negative().validate(),
          throwsA(isA<ValidationError>()),
        );
      });

      test('should fail for positive number', () {
        expect(
          () => '5'.field('Number').negative().validate(),
          throwsA(isA<ValidationError>()),
        );
      });
    });

    group('nonNegative', () {
      test('should pass for positive number', () {
        final result = '5'.field('Number').nonNegative().validate();
        expect(result, equals('5'));
      });

      test('should pass for zero', () {
        final result = '0'.field('Number').nonNegative().validate();
        expect(result, equals('0'));
      });

      test('should fail for negative number', () {
        expect(
          () => '-5'.field('Number').nonNegative().validate(),
          throwsA(isA<ValidationError>()),
        );
      });
    });

    group('nonNull', () {
      test('should pass for non-null value', () {
        final result = 'test'.field('Test').nonNull().validate();
        expect(result, equals('test'));
      });

      test('should fail for null value', () {
        expect(
          () => NullableValidationExtension(
            null,
          ).field('Test').nonNull().validate(),
          throwsA(isA<ValidationError>()),
        );
      });
    });

    group('nonNullOrEmpty', () {
      test('should pass for non-null non-empty string', () {
        final result = 'test'.field('Test').nonNullOrEmpty().validate();
        expect(result, equals('test'));
      });

      test('should fail for null value', () {
        expect(
          () => NullableValidationExtension(
            null,
          ).field('Test').nonNullOrEmpty().validate(),
          throwsA(isA<ValidationError>()),
        );
      });

      test('should fail for empty string', () {
        expect(
          () => ''.field('Test').nonNullOrEmpty().validate(),
          throwsA(isA<ValidationError>()),
        );
      });
    });

    group('custom', () {
      test('should pass with custom validator that succeeds', () {
        final result = 'test'
            .field('Test')
            .custom((value) => ValidationSuccess(value))
            .validate();
        expect(result, equals('test'));
      });

      test('should fail with custom validator that fails', () {
        expect(
          () => 'test'
              .field('Test')
              .custom((value) => ValidationFailure('Custom error'))
              .validate(),
          throwsA(isA<ValidationError>()),
        );
      });
    });

    group('validateEither', () {
      test('should return right for successful validation', () {
        final result = 'test'.field('Test').notEmpty().validateEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (left) => fail('Should not be left'),
          (right) => expect(right, equals('test')),
        );
      });

      test('should return left for failed validation', () {
        final result = ''.field('Test').notEmpty().validateEither();

        expect(result.isLeft(), isTrue);
        result.fold(
          (left) => expect(left, isA<ValidationError>()),
          (right) => fail('Should not be right'),
        );
      });
    });

    group('validateTask', () {
      test('should return right for successful validation', () async {
        final result = 'test'.field('Test').notEmpty().validateTaskEither();

        final either = await result.run();
        expect(either.isRight(), isTrue);
        either.fold(
          (left) => fail('Should not be left'),
          (right) => expect(right, equals('test')),
        );
      });

      test('should return left for failed validation', () async {
        final result = ''.field('Test').notEmpty().validateTaskEither();

        final either = await result.run();
        expect(either.isLeft(), isTrue);
        either.fold(
          (left) => expect(left, isA<ValidationError>()),
          (right) => fail('Should not be right'),
        );
      });
    });

    group('Async validation', () {
      test('should pass with async validator that succeeds', () async {
        final result = await 'test'
            .field('Test')
            .customAsync((value) async => ValidationSuccess(value))
            .validateAsync();
        expect(result, equals('test'));
      });

      test('should fail with async validator that fails', () {
        expect(
          () async => await 'test'
              .field('Test')
              .customAsync((value) async => ValidationFailure('Async error'))
              .validateAsync(),
          throwsA(isA<ValidationError>()),
        );
      });

      test('should handle mixed sync and async validators', () async {
        final result = await 'test'
            .field('Test')
            .notEmpty()
            .customAsync((value) async => ValidationSuccess(value))
            .validateAsync();
        expect(result, equals('test'));
      });
    });

    group('Chaining', () {
      test('should chain multiple validators successfully', () {
        final result = 'test@example.com'
            .field('Email')
            .notEmpty()
            .email()
            .minLength(10)
            .validate();
        expect(result, equals('test@example.com'));
      });

      test('should fail on first validation failure in chain', () {
        expect(
          () => 'test@example.com'
              .field('Email')
              .notEmpty()
              .minLength(20) // This should fail
              .email()
              .validate(),
          throwsA(isA<ValidationError>()),
        );
      });
    });
  });
}
