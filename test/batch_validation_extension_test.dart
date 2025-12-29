// ignore_for_file: avoid-unsafe-collection-methods

import 'package:test/test.dart';
import 'package:trust_but_verify/trust_but_verify.dart';

void main() {
  group('BatchValidationExtension', () {
    group('validateAsync', () {
      test('should validate all sync steps successfully', () async {
        final steps = [
          'test@example.com'.trust('Email').isNotEmpty().isEmail(),
          'password123'.trust('Password').isNotEmpty().minLength(8),
          '25'.trust('Age').toInt().min(18),
        ];

        final result = await steps.verifyAsync();

        expect(result, hasLength(3));
        expect(result[0], equals('test@example.com'));
        expect(result[1], equals('password123'));
        expect(result[2], equals(25));
      });

      test('should validate mixed sync and async steps successfully', () async {
        final steps = <ValidationStep>[
          'test@example.com'.trust('Email').isNotEmpty().isEmail(),
          Future.value('password123')
              .trust('Password')
              .ensure(
                (value) async => value.isNotEmpty && value.length >= 8,
                (fieldName) => '$fieldName must be at least 8 characters long',
              ),
          '25'.trust('Age').toInt().min(18),
        ];

        final result = await steps.verifyAsync();

        expect(result, hasLength(3));
        expect(result[0], equals('test@example.com'));
        expect(result[1], equals('password123'));
        expect(result[2], equals(25));
      });

      test('should throw first validation error', () {
        final steps = [
          ''.trust('Email').isNotEmpty().isEmail(),
          'password123'.trust('Password').isNotEmpty().minLength(8),
          '25'.trust('Age').toInt().min(18),
        ];

        expect(() => steps.verifyAsync(), throwsA(isA<ValidationError>()));
      });

      test('should handle async validation errors', () {
        final steps = [
          'test@example.com'.trust('Email').isNotEmpty().isEmail(),
          Future.value('')
              .trust('Password')
              .ensure(
                (value) async => value.isNotEmpty,
                (fieldName) => 'Field $fieldName is empty',
              ),
        ];

        expect(() => steps.verifyAsync(), throwsA(isA<ValidationError>()));
      });
    });

    group('validateTaskEither', () {
      test('should validate all steps successfully', () async {
        final steps = [
          'test@example.com'.trust('Email').isNotEmpty().isEmail(),
          'password123'.trust('Password').isNotEmpty().minLength(8),
          '25'.trust('Age').toInt().min(18),
        ];

        final result = await steps.verifyTaskEither().run();

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
          ''.trust('Email').isNotEmpty().isEmail(),
          'password123'.trust('Password').isNotEmpty().minLength(8),
          '25'.trust('Age').toInt().min(18),
        ];

        final result = await steps.verifyTaskEither().run();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Email'));
          expect(error.message, equals('Email cannot be empty'));
        }, (values) => fail('Should return error'));
      });

      test('should handle mixed sync and async steps', () async {
        final steps = <ValidationStep>[
          'test@example.com'.trust('Email').isNotEmpty().isEmail(),
          Future.value('password123')
              .trust('Password')
              .ensure(
                (value) async => value.isNotEmpty && value.length >= 8,
                (fieldName) => '$fieldName must be at least 8 characters long',
              ),
          '25'.trust('Age').toInt().min(18),
        ];

        final result = await steps.verifyTaskEither().run();

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
          'test@example.com'.trust('Email').isNotEmpty().isEmail(),
          'password123'.trust('Password').isNotEmpty().minLength(8),
          '25'.trust('Age').toInt().min(18),
        ];

        final result = steps.verify();

        expect(result, hasLength(3));
        expect(result[0], equals('test@example.com'));
        expect(result[1], equals('password123'));
        expect(result[2], equals(25));
      });

      test('should throw first validation error', () {
        final steps = <SyncValidationStep>[
          ''.trust('Email').isNotEmpty().isEmail(),
          'password123'.trust('Password').isNotEmpty().minLength(8),
          '25'.trust('Age').toInt().min(18),
        ];

        expect(() => steps.verify(), throwsA(isA<ValidationError>()));
      });
    });

    group('validateEither', () {
      test('should validate all sync steps successfully', () {
        final steps = <SyncValidationStep>[
          'test@example.com'.trust('Email').isNotEmpty().isEmail(),
          'password123'.trust('Password').isNotEmpty().minLength(8),
          '25'.trust('Age').toInt().min(18),
        ];

        final result = steps.verifyEither();

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
          ''.trust('Email').isNotEmpty().isEmail(),
          'password123'.trust('Password').isNotEmpty().minLength(8),
          '25'.trust('Age').toInt().min(18),
        ];

        final result = steps.verifyEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Email'));
          expect(error.message, equals('Email cannot be empty'));
        }, (values) => fail('Should return error'));
      });
    });
  });

  group('BatchAsyncValidationExtension', () {
    group('validateAsync', () {
      test('should validate all async steps successfully', () async {
        final steps = <AsyncValidationStep>[
          Future.value('test@example.com')
              .trust('Email')
              .ensure(
                (value) async => value.isNotEmpty && value.contains('@'),
                (fieldName) => '$fieldName must be a valid email',
              ),
          Future.value('password123')
              .trust('Password')
              .ensure(
                (value) async => value.isNotEmpty && value.length >= 8,
                (fieldName) => '$fieldName must be at least 8 characters long',
              ),
          Future.value('25')
              .trust('Age')
              .tryMap(
                (value) async => int.parse(value),
                (fieldName) => '$fieldName must be a number',
              )
              .ensure(
                (value) async => value >= 18,
                (fieldName) => '$fieldName must be at least 18',
              ),
        ];

        final result = await steps.verifyAsync();

        expect(result, hasLength(3));
        expect(result[0], equals('test@example.com'));
        expect(result[1], equals('password123'));
        expect(result[2], equals(25));
      });

      test('should throw first validation error', () {
        final steps = <AsyncValidationStep>[
          Future.value('')
              .trust('Email')
              .ensure(
                (value) async => value.isNotEmpty,
                (fieldName) => 'Field $fieldName is empty',
              ),
          Future.value('password123')
              .trust('Password')
              .ensure(
                (value) async => value.isNotEmpty && value.length >= 8,
                (fieldName) => '$fieldName must be at least 8 characters long',
              ),
        ];

        expect(() => steps.verifyAsync(), throwsA(isA<ValidationError>()));
      });
    });

    group('validateTaskEither', () {
      test('should validate all async steps successfully', () async {
        final steps = <AsyncValidationStep>[
          Future.value('test@example.com')
              .trust('Email')
              .ensure(
                (value) async => value.isNotEmpty && value.contains('@'),
                (fieldName) => '$fieldName must be a valid email',
              ),
          Future.value('password123')
              .trust('Password')
              .ensure(
                (value) async => value.isNotEmpty && value.length >= 8,
                (fieldName) => '$fieldName must be at least 8 characters long',
              ),
          Future.value('25')
              .trust('Age')
              .tryMap(
                (value) async => int.parse(value),
                (fieldName) => '$fieldName must be a number',
              )
              .ensure(
                (value) async => value >= 18,
                (fieldName) => '$fieldName must be at least 18',
              ),
        ];

        final result = await steps.verifyTaskEither().run();

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
              .trust('Email')
              .ensure(
                (value) async => value.isNotEmpty,
                (fieldName) => 'Field $fieldName is empty',
              ),
          Future.value('password123')
              .trust('Password')
              .ensure(
                (value) async => value.isNotEmpty && value.length >= 8,
                (fieldName) => '$fieldName must be at least 8 characters long',
              ),
        ];

        final result = await steps.verifyTaskEither().run();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Email'));
          expect(error.message, equals('Field Email is empty'));
        }, (values) => fail('Should return error'));
      });
    });
  });
}
