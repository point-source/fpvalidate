import 'package:test/test.dart';
import 'package:fpvalidate/src/validation_extension.dart';
import 'package:fpvalidate/src/string_validation_extension.dart';
import 'package:fpvalidate/src/validation_error.dart';
import 'package:fpvalidate/src/validation_result.dart';
import 'package:fpvalidate/src/numeric_validation_extension.dart';

void main() {
  group('ValidationExtension', () {
    test('should create ValidationBuilder with field name', () {
      final builder = 'test'.field('Test Field');
      expect(builder.value, equals('test'));
      expect(builder.fieldName, equals('Test Field'));
    });

    test('should work with different types', () {
      final stringBuilder = 'test'.field('String');
      final intBuilder = 42.field('Number');
      final doubleBuilder = 3.14.field('Decimal');
      final boolBuilder = true.field('Boolean');

      expect(stringBuilder.value, equals('test'));
      expect(intBuilder.value, equals(42));
      expect(doubleBuilder.value, equals(3.14));
      expect(boolBuilder.value, equals(true));
    });
  });

  group('NullableValidationExtension', () {
    test('should create ValidationBuilder with nullable value', () {
      final builder = NullableValidationBuilderExtension(
        'test',
      ).field('Test Field');
      expect(builder.value, equals('test'));
      expect(builder.fieldName, equals('Test Field'));
    });

    test('should work with null value', () {
      final builder = NullableValidationBuilderExtension(
        null,
      ).field('Test Field');
      expect(builder.value, isNull);
      expect(builder.fieldName, equals('Test Field'));
    });
  });

  group('ValidationBuilderListExtension', () {
    group('validate', () {
      test('should validate all builders successfully', () {
        final builders = [
          'test'.field('Field1').notEmpty(),
          42.field('Field2').min(10),
          'valid@email.com'.field('Field3').email(),
        ];

        final results = builders.validate();
        expect(results, equals(['test', 42, 'valid@email.com']));
      });

      test('should throw ValidationError on first failure', () {
        final builders = [
          'test'.field('Field1').notEmpty(),
          ''.field('Field2').notEmpty(), // This should fail
          'valid@email.com'.field('Field3').email(),
        ];

        expect(() => builders.validate(), throwsA(isA<ValidationError>()));
      });

      test('should throw ValidationError with correct field name', () {
        final builders = [
          'test'.field('Field1').notEmpty(),
          ''.field('Field2').notEmpty(),
        ];

        try {
          builders.validate();
          fail('Should have thrown ValidationError');
        } catch (e) {
          expect(e, isA<ValidationError>());
          expect((e as ValidationError).fieldName, equals('Field2'));
        }
      });
    });

    group('validateAsync', () {
      test('should validate all builders asynchronously', () async {
        final builders = [
          'test'.field('Field1').notEmpty(),
          42.field('Field2').min(10),
          'valid@email.com'.field('Field3').email(),
        ];

        final results = await builders.validateAsync();
        expect(results, equals(['test', 42, 'valid@email.com']));
      });

      test('should throw ValidationError on first async failure', () {
        final builders = [
          'test'.field('Field1').notEmpty(),
          'test'
              .field('Field2')
              .customAsync((value) async => ValidationFailure('Async error')),
        ];

        expect(
          () async => await builders.validateAsync(),
          throwsA(isA<ValidationError>()),
        );
      });
    });

    group('validateEither', () {
      test('should return right for successful validation', () {
        final builders = [
          'test'.field('Field1').notEmpty(),
          42.field('Field2').min(10),
        ];

        final result = builders.validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (left) => fail('Should not be left'),
          (right) => expect(right, equals(['test', 42])),
        );
      });

      test('should return left for failed validation', () {
        final builders = [
          'test'.field('Field1').notEmpty(),
          ''.field('Field2').notEmpty(), // This should fail
        ];

        final result = builders.validateEither();
        expect(result.isLeft(), isTrue);
        result.fold(
          (left) => expect(left, isA<ValidationError>()),
          (right) => fail('Should not be right'),
        );
      });
    });

    group('validateTask', () {
      test('should return right for successful validation', () async {
        final builders = [
          'test'.field('Field1').notEmpty(),
          42.field('Field2').min(10),
        ];

        final result = builders.validateTaskEither();
        final either = await result.run();
        expect(either.isRight(), isTrue);
        either.fold(
          (left) => fail('Should not be left'),
          (right) => expect(right, equals(['test', 42])),
        );
      });

      test('should return left for failed validation', () async {
        final builders = [
          'test'.field('Field1').notEmpty(),
          ''.field('Field2').notEmpty(), // This should fail
        ];

        final result = builders.validateTaskEither();
        final either = await result.run();
        expect(either.isLeft(), isTrue);
        either.fold(
          (left) => expect(left, isA<ValidationError>()),
          (right) => fail('Should not be right'),
        );
      });
    });

    group('Error handling', () {
      test('should handle non-ValidationError exceptions', () {
        final builders = [
          'test'.field('Field1').notEmpty(),
          'test'
              .field('Field2')
              .custom((value) => throw Exception('Custom exception')),
        ];

        expect(() => builders.validate(), throwsA(isA<ValidationError>()));
      });

      test(
        'should handle non-ValidationError exceptions in async validation',
        () {
          final builders = [
            'test'.field('Field1').notEmpty(),
            'test'
                .field('Field2')
                .customAsync(
                  (value) async => throw Exception('Custom exception'),
                ),
          ];

          expect(
            () async => await builders.validateAsync(),
            throwsA(isA<ValidationError>()),
          );
        },
      );
    });
  });

  group('StringValidationExtension', () {
    test('contains should validate substring presence', () {
      expect(
        () => 'hello world'.field('Test').contains('world').validate(),
        returnsNormally,
      );

      expect(
        () => 'hello world'.field('Test').contains('missing').validate(),
        throwsA(isA<ValidationError>()),
      );
    });

    test('startsWith should validate prefix', () {
      expect(
        () =>
            'https://example.com'.field('Test').startsWith('https').validate(),
        returnsNormally,
      );

      expect(
        () => 'http://example.com'.field('Test').startsWith('https').validate(),
        throwsA(isA<ValidationError>()),
      );
    });

    test('endsWith should validate suffix', () {
      expect(
        () => 'file.txt'.field('Test').endsWith('.txt').validate(),
        returnsNormally,
      );

      expect(
        () => 'file.doc'.field('Test').endsWith('.txt').validate(),
        throwsA(isA<ValidationError>()),
      );
    });

    test('alphanumeric should validate alphanumeric characters only', () {
      expect(
        () => 'abc123'.field('Test').alphanumeric().validate(),
        returnsNormally,
      );

      expect(
        () => 'abc-123'.field('Test').alphanumeric().validate(),
        throwsA(isA<ValidationError>()),
      );
    });

    test('lettersOnly should validate letters only', () {
      expect(
        () => 'abcdef'.field('Test').lettersOnly().validate(),
        returnsNormally,
      );

      expect(
        () => 'abc123'.field('Test').lettersOnly().validate(),
        throwsA(isA<ValidationError>()),
      );
    });

    test('digitsOnly should validate digits only', () {
      expect(
        () => '123456'.field('Test').digitsOnly().validate(),
        returnsNormally,
      );

      expect(
        () => '123abc'.field('Test').digitsOnly().validate(),
        throwsA(isA<ValidationError>()),
      );
    });

    test('uuid should validate UUID format', () {
      expect(
        () => '550e8400-e29b-41d4-a716-446655440000'
            .field('Test')
            .uuid()
            .validate(),
        returnsNormally,
      );

      expect(
        () => 'invalid-uuid'.field('Test').uuid().validate(),
        throwsA(isA<ValidationError>()),
      );
    });

    test('creditCard should validate credit card format', () {
      expect(
        () => '4111111111111111'.field('Test').creditCard().validate(),
        returnsNormally,
      );

      expect(
        () => '1234'.field('Test').creditCard().validate(),
        throwsA(isA<ValidationError>()),
      );
    });

    test('postalCode should validate postal code format', () {
      expect(
        () => '12345'.field('Test').postalCode().validate(),
        returnsNormally,
      );

      expect(
        () => '12345-6789'.field('Test').postalCode().validate(),
        returnsNormally,
      );

      expect(
        () => '1234'.field('Test').postalCode().validate(),
        throwsA(isA<ValidationError>()),
      );
    });

    test('isoDate should validate ISO date format', () {
      expect(
        () => '2023-12-25'.field('Test').isoDate().validate(),
        returnsNormally,
      );

      expect(
        () => '2023-13-01'.field('Test').isoDate().validate(),
        throwsA(isA<ValidationError>()),
      );
    });

    test('time24Hour should validate 24-hour time format', () {
      expect(
        () => '14:30'.field('Test').time24Hour().validate(),
        returnsNormally,
      );

      expect(
        () => '25:00'.field('Test').time24Hour().validate(),
        throwsA(isA<ValidationError>()),
      );
    });

    test('should chain multiple string validators', () {
      expect(
        () => 'https://example.com/api'
            .field('URL')
            .startsWith('https')
            .contains('api')
            .validate(),
        returnsNormally,
      );

      expect(
        () => 'http://example.com/api'
            .field('URL')
            .startsWith('https')
            .contains('api')
            .validate(),
        throwsA(isA<ValidationError>()),
      );
    });
  });
}
