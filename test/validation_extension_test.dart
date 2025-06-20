import 'package:test/test.dart';
import 'package:fpvalidate/src/validation_extension.dart';
import 'package:fpvalidate/src/validation_error.dart';
import 'package:fpvalidate/src/validation_result.dart';

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
      final builder = NullableValidationExtension('test').field('Test Field');
      expect(builder.value, equals('test'));
      expect(builder.fieldName, equals('Test Field'));
    });

    test('should work with null value', () {
      final builder = NullableValidationExtension(null).field('Test Field');
      expect(builder.value, isNull);
      expect(builder.fieldName, equals('Test Field'));
    });
  });

  group('ValidationBuilderListExtension', () {
    group('validate', () {
      test('should validate all builders successfully', () {
        final builders = [
          'test'.field('Field1').notEmpty(),
          '42'.field('Field2').min(10),
          'valid@email.com'.field('Field3').email(),
        ];

        final results = builders.validate();
        expect(results, equals(['test', '42', 'valid@email.com']));
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
          '42'.field('Field2').min(10),
          'valid@email.com'.field('Field3').email(),
        ];

        final results = await builders.validateAsync();
        expect(results, equals(['test', '42', 'valid@email.com']));
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
          '42'.field('Field2').min(10),
        ];

        final result = builders.validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (left) => fail('Should not be left'),
          (right) => expect(right, equals(['test', '42'])),
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
          '42'.field('Field2').min(10),
        ];

        final result = builders.validateTaskEither();
        final either = await result.run();
        expect(either.isRight(), isTrue);
        either.fold(
          (left) => fail('Should not be left'),
          (right) => expect(right, equals(['test', '42'])),
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
}
