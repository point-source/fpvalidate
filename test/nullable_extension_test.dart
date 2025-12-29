// ignore_for_file: avoid-unnecessary-type-casts

import 'package:test/test.dart';
import 'package:trust_but_verify/trust_but_verify.dart';

void main() {
  group('NullableExtension', () {
    group('isNotNull', () {
      test('should succeed when value is not null', () {
        final result = 'test'.trust('Test Field').isNotNull().verifyEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error for non-null value'),
          (value) => expect(value, equals('test')),
        );
      });

      test('should fail when value is null', () {
        final result = (null as String?)
            .trust('Test Field')
            .isNotNull()
            .verifyEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Test Field'));
          expect(error.message, equals('Test Field cannot be null'));
        }, (value) => fail('Should return error for null value'));
      });

      test('should transform type from nullable to non-nullable', () {
        final result = 'test'.trust('Test Field').isNotNull().verifyEither();

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
              .trust('Test Field')
              .isNotNull()
              .isNotEmpty()
              .verifyEither();

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
              .trust('Test Field')
              .isNotNull()
              .isNotEmpty()
              .verifyEither();

          expect(result.isLeft(), isTrue);
          result.fold((error) {
            expect(error.fieldName, equals('Test Field'));
            expect(error.message, equals('Test Field cannot be null'));
          }, (value) => fail('Should return error for null value'));
        },
      );

      test('should work with different nullable types', () {
        // Test with int
        final intResult = (42 as int?)
            .trust('Int Field')
            .isNotNull()
            .verifyEither();
        expect(intResult.isRight(), isTrue);
        intResult.fold(
          (error) => fail('Should not return error for non-null int'),
          (value) => expect(value, equals(42)),
        );

        // Test with double
        final doubleResult = (3.14 as double?)
            .trust('Double Field')
            .isNotNull()
            .verifyEither();
        expect(doubleResult.isRight(), isTrue);
        doubleResult.fold(
          (error) => fail('Should not return error for non-null double'),
          (value) => expect(value, equals(3.14)),
        );

        // Test with bool
        final boolResult = (true as bool?)
            .trust('Bool Field')
            .isNotNull()
            .verifyEither();
        expect(boolResult.isRight(), isTrue);
        boolResult.fold(
          (error) => fail('Should not return error for non-null bool'),
          (value) => expect(value, equals(true)),
        );
      });

      test('should fail with null values of different types', () {
        // Test with null int
        final intResult = (null as int?)
            .trust('Int Field')
            .isNotNull()
            .verifyEither();
        expect(intResult.isLeft(), isTrue);
        intResult.fold((error) {
          expect(error.fieldName, equals('Int Field'));
          expect(error.message, equals('Int Field cannot be null'));
        }, (value) => fail('Should return error for null int'));

        // Test with null double
        final doubleResult = (null as double?)
            .trust('Double Field')
            .isNotNull()
            .verifyEither();
        expect(doubleResult.isLeft(), isTrue);
        doubleResult.fold((error) {
          expect(error.fieldName, equals('Double Field'));
          expect(error.message, equals('Double Field cannot be null'));
        }, (value) => fail('Should return error for null double'));
      });

      test('should work with complex chaining scenarios', () {
        final result = 'test@example.com'
            .trust('Email')
            .isNotNull()
            .isNotEmpty()
            .isEmail()
            .verifyEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error for valid email'),
          (value) => expect(value, equals('test@example.com')),
        );
      });

      test('should fail early in complex chaining when value is null', () {
        final result = (null as String?)
            .trust('Email')
            .isNotNull()
            .isNotEmpty()
            .isEmail()
            .verifyEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Email'));
          expect(error.message, equals('Email cannot be null'));
        }, (value) => fail('Should return error for null value'));
      });
    });
  });
}
