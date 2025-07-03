// ignore_for_file: avoid-unsafe-collection-methods

import 'package:test/test.dart';
import 'package:fpvalidate/fpvalidate.dart';

void main() {
  group('BatchValidationExtension', () {
    group('validateAsync', () {
      test('should validate all sync steps successfully', () async {
        final steps = [
          'test@example.com'.field('Email').isNotEmpty().isEmail(),
          'password123'.field('Password').isNotEmpty().minLength(8),
          '25'.field('Age').toInt().min(18),
        ];

        final result = await steps.validateAsync();

        expect(result, hasLength(3));
        expect(result[0], equals('test@example.com'));
        expect(result[1], equals('password123'));
        expect(result[2], equals(25));
      });

      test('should validate mixed sync and async steps successfully', () async {
        final steps = <ValidationStep>[
          'test@example.com'.field('Email').isNotEmpty().isEmail(),
          Future.value('password123')
              .field('Password')
              .check(
                (value) async => value.isNotEmpty && value.length >= 8,
                (fieldName) => '$fieldName must be at least 8 characters long',
              ),
          '25'.field('Age').toInt().min(18),
        ];

        final result = await steps.validateAsync();

        expect(result, hasLength(3));
        expect(result[0], equals('test@example.com'));
        expect(result[1], equals('password123'));
        expect(result[2], equals(25));
      });

      test('should throw first validation error', () {
        final steps = [
          ''.field('Email').isNotEmpty().isEmail(),
          'password123'.field('Password').isNotEmpty().minLength(8),
          '25'.field('Age').toInt().min(18),
        ];

        expect(() => steps.validateAsync(), throwsA(isA<ValidationError>()));
      });

      test('should handle async validation errors', () {
        final steps = [
          'test@example.com'.field('Email').isNotEmpty().isEmail(),
          Future.value('')
              .field('Password')
              .check(
                (value) async => value.isNotEmpty,
                (fieldName) => 'Field $fieldName is empty',
              ),
        ];

        expect(() => steps.validateAsync(), throwsA(isA<ValidationError>()));
      });
    });

    group('validateTaskEither', () {
      test('should validate all steps successfully', () async {
        final steps = [
          'test@example.com'.field('Email').isNotEmpty().isEmail(),
          'password123'.field('Password').isNotEmpty().minLength(8),
          '25'.field('Age').toInt().min(18),
        ];

        final result = await steps.validateTaskEither().run();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (values) {
          expect(values, hasLength(3));
          expect(values[0], equals('test@example.com'));
          expect(values[1], equals('password123'));
          expect(values[2], equals(25));
        });
      });

      test('should return first validation error', () async {
        final steps = [
          ''.field('Email').isNotEmpty().isEmail(),
          'password123'.field('Password').isNotEmpty().minLength(8),
          '25'.field('Age').toInt().min(18),
        ];

        final result = await steps.validateTaskEither().run();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Email'));
          expect(error.message, equals('Field Email is empty'));
        }, (values) => fail('Should return error'));
      });

      test('should handle mixed sync and async steps', () async {
        final steps = <ValidationStep>[
          'test@example.com'.field('Email').isNotEmpty().isEmail(),
          Future.value('password123')
              .field('Password')
              .check(
                (value) async => value.isNotEmpty && value.length >= 8,
                (fieldName) => '$fieldName must be at least 8 characters long',
              ),
          '25'.field('Age').toInt().min(18),
        ];

        final result = await steps.validateTaskEither().run();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (values) {
          expect(values, hasLength(3));
          expect(values[0], equals('test@example.com'));
          expect(values[1], equals('password123'));
          expect(values[2], equals(25));
        });
      });
    });
  });

  group('BatchSyncValidationExtension', () {
    group('validate', () {
      test('should validate all sync steps successfully', () {
        final steps = <SyncValidationStep>[
          'test@example.com'.field('Email').isNotEmpty().isEmail(),
          'password123'.field('Password').isNotEmpty().minLength(8),
          '25'.field('Age').toInt().min(18),
        ];

        final result = steps.validate();

        expect(result, hasLength(3));
        expect(result[0], equals('test@example.com'));
        expect(result[1], equals('password123'));
        expect(result[2], equals(25));
      });

      test('should throw first validation error', () {
        final steps = <SyncValidationStep>[
          ''.field('Email').isNotEmpty().isEmail(),
          'password123'.field('Password').isNotEmpty().minLength(8),
          '25'.field('Age').toInt().min(18),
        ];

        expect(() => steps.validate(), throwsA(isA<ValidationError>()));
      });
    });

    group('validateEither', () {
      test('should validate all sync steps successfully', () {
        final steps = <SyncValidationStep>[
          'test@example.com'.field('Email').isNotEmpty().isEmail(),
          'password123'.field('Password').isNotEmpty().minLength(8),
          '25'.field('Age').toInt().min(18),
        ];

        final result = steps.validateEither();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (values) {
          expect(values, hasLength(3));
          expect(values[0], equals('test@example.com'));
          expect(values[1], equals('password123'));
          expect(values[2], equals(25));
        });
      });

      test('should return first validation error', () {
        final steps = <SyncValidationStep>[
          ''.field('Email').isNotEmpty().isEmail(),
          'password123'.field('Password').isNotEmpty().minLength(8),
          '25'.field('Age').toInt().min(18),
        ];

        final result = steps.validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Email'));
          expect(error.message, equals('Field Email is empty'));
        }, (values) => fail('Should return error'));
      });
    });
  });

  group('BatchAsyncValidationExtension', () {
    group('validateAsync', () {
      test('should validate all async steps successfully', () async {
        final steps = <AsyncValidationStep>[
          Future.value('test@example.com')
              .field('Email')
              .check(
                (value) async => value.isNotEmpty && value.contains('@'),
                (fieldName) => '$fieldName must be a valid email',
              ),
          Future.value('password123')
              .field('Password')
              .check(
                (value) async => value.isNotEmpty && value.length >= 8,
                (fieldName) => '$fieldName must be at least 8 characters long',
              ),
          Future.value('25')
              .field('Age')
              .tryMap(
                (value) async => int.parse(value),
                (fieldName) => '$fieldName must be a number',
              )
              .check(
                (value) async => value >= 18,
                (fieldName) => '$fieldName must be at least 18',
              ),
        ];

        final result = await steps.validateAsync();

        expect(result, hasLength(3));
        expect(result[0], equals('test@example.com'));
        expect(result[1], equals('password123'));
        expect(result[2], equals(25));
      });

      test('should throw first validation error', () {
        final steps = <AsyncValidationStep>[
          Future.value('')
              .field('Email')
              .check(
                (value) async => value.isNotEmpty,
                (fieldName) => 'Field $fieldName is empty',
              ),
          Future.value('password123')
              .field('Password')
              .check(
                (value) async => value.isNotEmpty && value.length >= 8,
                (fieldName) => '$fieldName must be at least 8 characters long',
              ),
        ];

        expect(() => steps.validateAsync(), throwsA(isA<ValidationError>()));
      });
    });

    group('validateTaskEither', () {
      test('should validate all async steps successfully', () async {
        final steps = <AsyncValidationStep>[
          Future.value('test@example.com')
              .field('Email')
              .check(
                (value) async => value.isNotEmpty && value.contains('@'),
                (fieldName) => '$fieldName must be a valid email',
              ),
          Future.value('password123')
              .field('Password')
              .check(
                (value) async => value.isNotEmpty && value.length >= 8,
                (fieldName) => '$fieldName must be at least 8 characters long',
              ),
          Future.value('25')
              .field('Age')
              .tryMap(
                (value) async => int.parse(value),
                (fieldName) => '$fieldName must be a number',
              )
              .check(
                (value) async => value >= 18,
                (fieldName) => '$fieldName must be at least 18',
              ),
        ];

        final result = await steps.validateTaskEither().run();

        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (values) {
          expect(values, hasLength(3));
          expect(values[0], equals('test@example.com'));
          expect(values[1], equals('password123'));
          expect(values[2], equals(25));
        });
      });

      test('should return first validation error', () async {
        final steps = <AsyncValidationStep>[
          Future.value('')
              .field('Email')
              .check(
                (value) async => value.isNotEmpty,
                (fieldName) => 'Field $fieldName is empty',
              ),
          Future.value('password123')
              .field('Password')
              .check(
                (value) async => value.isNotEmpty && value.length >= 8,
                (fieldName) => '$fieldName must be at least 8 characters long',
              ),
        ];

        final result = await steps.validateTaskEither().run();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Email'));
          expect(error.message, equals('Field Email is empty'));
        }, (values) => fail('Should return error'));
      });
    });
  });
}
