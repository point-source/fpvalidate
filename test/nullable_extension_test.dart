import 'package:test/test.dart';
import 'package:fpvalidate/fpvalidate.dart';

void main() {
  group('NullableExtension', () {
    group('isNotNull', () {
      test('should succeed when value is not null', () {
        final result = 'test'.field('Test Field').isNotNull().validateEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error for non-null value'),
          (value) => expect(value, equals('test')),
        );
      });

      test('should fail when value is null', () {
        final result = (null as String?)
            .field('Test Field')
            .isNotNull()
            .validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Test Field'));
          expect(error.message, equals('Field Test Field is null'));
        }, (value) => fail('Should return error for null value'));
      });

      test('should transform type from nullable to non-nullable', () {
        final result = 'test'.field('Test Field').isNotNull().validateEither();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (value) {
          expect(value, isA<String>());
          expect(value, equals('test'));
        });
      });

      test(
        'should allow chaining with non-nullable validators after isNotNull',
        () {
          final result = 'test'
              .field('Test Field')
              .isNotNull()
              .notEmpty()
              .validateEither();

          expect(result.isRight(), isTrue);
          result.fold(
            (error) => fail('Should not return error'),
            (value) => expect(value, equals('test')),
          );
        },
      );

      test(
        'should fail when chaining with non-nullable validators on null value',
        () {
          final result = (null as String?)
              .field('Test Field')
              .isNotNull()
              .notEmpty()
              .validateEither();

          expect(result.isLeft(), isTrue);
          result.fold((error) {
            expect(error.fieldName, equals('Test Field'));
            expect(error.message, equals('Field Test Field is null'));
          }, (value) => fail('Should return error for null value'));
        },
      );

      test('should work with different nullable types', () {
        // Test with int
        final intResult = (42 as int?)
            .field('Int Field')
            .isNotNull()
            .validateEither();
        expect(intResult.isRight(), isTrue);
        intResult.fold(
          (error) => fail('Should not return error for non-null int'),
          (value) => expect(value, equals(42)),
        );

        // Test with double
        final doubleResult = (3.14 as double?)
            .field('Double Field')
            .isNotNull()
            .validateEither();
        expect(doubleResult.isRight(), isTrue);
        doubleResult.fold(
          (error) => fail('Should not return error for non-null double'),
          (value) => expect(value, equals(3.14)),
        );

        // Test with bool
        final boolResult = (true as bool?)
            .field('Bool Field')
            .isNotNull()
            .validateEither();
        expect(boolResult.isRight(), isTrue);
        boolResult.fold(
          (error) => fail('Should not return error for non-null bool'),
          (value) => expect(value, equals(true)),
        );
      });

      test('should fail with null values of different types', () {
        // Test with null int
        final intResult = (null as int?)
            .field('Int Field')
            .isNotNull()
            .validateEither();
        expect(intResult.isLeft(), isTrue);
        intResult.fold((error) {
          expect(error.fieldName, equals('Int Field'));
          expect(error.message, equals('Field Int Field is null'));
        }, (value) => fail('Should return error for null int'));

        // Test with null double
        final doubleResult = (null as double?)
            .field('Double Field')
            .isNotNull()
            .validateEither();
        expect(doubleResult.isLeft(), isTrue);
        doubleResult.fold((error) {
          expect(error.fieldName, equals('Double Field'));
          expect(error.message, equals('Field Double Field is null'));
        }, (value) => fail('Should return error for null double'));
      });

      test('should work with complex chaining scenarios', () {
        final result = 'test@example.com'
            .field('Email')
            .isNotNull()
            .notEmpty()
            .isEmail()
            .validateEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error for valid email'),
          (value) => expect(value, equals('test@example.com')),
        );
      });

      test('should fail early in complex chaining when value is null', () {
        final result = (null as String?)
            .field('Email')
            .isNotNull()
            .notEmpty()
            .isEmail()
            .validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Email'));
          expect(error.message, equals('Field Email is null'));
        }, (value) => fail('Should return error for null value'));
      });
    });
  });
}
