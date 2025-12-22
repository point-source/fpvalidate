// ignore_for_file: unnecessary_nullable_for_final_variable_declarations

import 'package:test/test.dart';
import 'package:fpvalidate/fpvalidate.dart';

void main() {
  group('CastingExtension', () {
    group('isType', () {
      test('should succeed when value is of the expected type (int)', () {
        final Object? value = 42;
        final result = value.field('Number').isType<int>().validateEither();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (v) {
          expect(v, isA<int>());
          expect(v, equals(42));
        });
      });

      test('should succeed when value is of the expected type (String)', () {
        final Object? value = 'hello';
        final result = value.field('Text').isType<String>().validateEither();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (v) {
          expect(v, isA<String>());
          expect(v, equals('hello'));
        });
      });

      test('should succeed when value is of the expected type (double)', () {
        final Object? value = 3.14;
        final result = value.field('Pi').isType<double>().validateEither();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (v) {
          expect(v, isA<double>());
          expect(v, equals(3.14));
        });
      });

      test('should succeed when value is of the expected type (bool)', () {
        final Object? value = true;
        final result = value.field('Flag').isType<bool>().validateEither();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (v) {
          expect(v, isA<bool>());
          expect(v, equals(true));
        });
      });

      test('should succeed when value is of the expected type (List)', () {
        final Object? value = [1, 2, 3];
        final result = value.field('Numbers').isType<List>().validateEither();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (v) {
          expect(v, isA<List>());
          expect(v, equals([1, 2, 3]));
        });
      });

      test('should fail when value is not of the expected type (int)', () {
        final Object? value = 'not a number';
        final result = value.field('Number').isType<int>().validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error, isA<TypeMismatchValidationError>());
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be of type int'));
        }, (v) => fail('Should return error'));
      });

      test('should fail when value is not of the expected type (String)', () {
        final Object? value = 42;
        final result = value.field('Text').isType<String>().validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error, isA<TypeMismatchValidationError>());
          expect(error.fieldName, equals('Text'));
          expect(error.message, equals('Text must be of type String'));
        }, (v) => fail('Should return error'));
      });

      test('should fail when value is not of the expected type (double)', () {
        final Object? value = 42;
        final result = value.field('Pi').isType<double>().validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error, isA<TypeMismatchValidationError>());
          expect(error.fieldName, equals('Pi'));
          expect(error.message, equals('Pi must be of type double'));
        }, (v) => fail('Should return error'));
      });

      test('should fail when value is not of the expected type (bool)', () {
        final Object? value = 'not a bool';
        final result = value.field('Flag').isType<bool>().validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error, isA<TypeMismatchValidationError>());
          expect(error.fieldName, equals('Flag'));
          expect(error.message, equals('Flag must be of type bool'));
        }, (v) => fail('Should return error'));
      });

      test('should allow chaining with type-specific validators (int)', () {
        final Object? value = 42;
        final result = value
            .field('Age')
            .isType<int>()
            .min(18)
            .max(65)
            .validateEither();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (v) {
          expect(v, isA<int>());
          expect(v, equals(42));
        });
      });

      test('should allow chaining with type-specific validators (String)', () {
        final Object? value = 'test@example.com';
        final result = value
            .field('Email')
            .isType<String>()
            .isNotEmpty()
            .isEmail()
            .validateEither();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (v) {
          expect(v, isA<String>());
          expect(v, equals('test@example.com'));
        });
      });

      test('should fail when chained validator fails after type check', () {
        final Object? value = 10;
        final result = value
            .field('Age')
            .isType<int>()
            .min(18)
            .validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error, isA<InvalidMinValueValidationError>());
          expect(error.fieldName, equals('Age'));
        }, (v) => fail('Should return error'));
      });

      test('should handle num type correctly with int value', () {
        final Object? value = 42;
        final result = value.field('Number').isType<num>().validateEither();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (v) {
          expect(v, isA<num>());
          expect(v, equals(42));
        });
      });

      test('should handle num type correctly with double value', () {
        final Object? value = 3.14;
        final result = value.field('Number').isType<num>().validateEither();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (v) {
          expect(v, isA<num>());
          expect(v, equals(3.14));
        });
      });

      test('should handle nullable types correctly', () {
        final Object? value = null;
        final result = value.field('Optional').isType<int?>().validateEither();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (v) {
          expect(v, isNull);
        });
      });

      test('should fail when non-null value expected but null provided', () {
        final Object? value = null;
        final result = value.field('Required').isType<int>().validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error, isA<TypeMismatchValidationError>());
          expect(error.fieldName, equals('Required'));
          expect(error.message, equals('Required must be of type int'));
        }, (v) => fail('Should return error'));
      });

      test('should work with custom types', () {
        final Object? value = DateTime(2023, 1, 1);
        final result = value.field('Date').isType<DateTime>().validateEither();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (v) {
          expect(v, isA<DateTime>());
          expect(v, equals(DateTime(2023, 1, 1)));
        });
      });

      test('should fail with custom types when type mismatch', () {
        final Object? value = 'not a date';
        final result = value.field('Date').isType<DateTime>().validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error, isA<TypeMismatchValidationError>());
          expect(error.fieldName, equals('Date'));
          expect(error.message, equals('Date must be of type DateTime'));
        }, (v) => fail('Should return error'));
      });

      test('should work with generic List types', () {
        final Object? value = <int>[1, 2, 3];
        final result = value
            .field('Numbers')
            .isType<List<int>>()
            .validateEither();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (v) {
          expect(v, isA<List<int>>());
          expect(v, equals([1, 2, 3]));
        });
      });

      test('should work with Map types', () {
        final Object? value = {'key': 'value'};
        final result = value
            .field('Data')
            .isType<Map<String, String>>()
            .validateEither();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (v) {
          expect(v, isA<Map<String, String>>());
          expect(v, equals({'key': 'value'}));
        });
      });
    });
  });
}
