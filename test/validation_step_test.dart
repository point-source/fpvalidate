import 'package:test/test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpvalidate/fpvalidate.dart';

void main() {
  group('SyncValidationStep', () {
    group('tryMap', () {
      test('should transform value successfully', () {
        final step = '123'.field('Number');
        final result = step
            .tryMap(
              (value) => int.parse(value),
              (fieldName) => '$fieldName must be a number',
            )
            .validateEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(123)),
        );
      });

      test('should return error when transformation fails', () {
        final step = 'abc'.field('Number');
        final result = step
            .tryMap(
              (value) => int.parse(value),
              (fieldName) => '$fieldName must be a number',
            )
            .validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be a number'));
        }, (value) => fail('Should return error'));
      });
    });

    group('check', () {
      test('should succeed when condition is true', () {
        final step = 'test@example.com'.field('Email');
        final result = step
            .check(
              (value) => value.contains('@'),
              (fieldName) => '$fieldName must contain @',
            )
            .validateEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('test@example.com')),
        );
      });

      test('should fail when condition is false', () {
        final step = 'invalid-email'.field('Email');
        final result = step
            .check(
              (value) => value.contains('@'),
              (fieldName) => '$fieldName must contain @',
            )
            .validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Email'));
          expect(error.message, equals('Email must contain @'));
        }, (value) => fail('Should return error'));
      });

      test('should handle exceptions in check function', () {
        final step = 'test'.field('String');
        final result = step
            .check(
              (value) => throw Exception('Test exception'),
              (fieldName) => '$fieldName is invalid',
            )
            .validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(error.message, contains('Exception: Test exception'));
        }, (value) => fail('Should return error'));
      });
    });

    group('bind', () {
      test('should bind to another validation step', () {
        final step = '123'.field('Number');
        final result = step
            .bind((value) => Right(int.parse(value)))
            .validateEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(123)),
        );
      });

      test('should propagate error from bound step', () {
        final step = 'abc'.field('Number');
        final result = step
            .bind((value) => Left(ValidationError('Number', 'Invalid number')))
            .validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Invalid number'));
        }, (value) => fail('Should return error'));
      });
    });

    group('toAsync', () {
      test('should convert to async validation step', () async {
        final step = 'test'.field('String');
        final asyncStep = step.toAsync();

        expect(asyncStep, isA<AsyncValidationStep<String>>());

        final result = await asyncStep.validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('test')),
        );
      });
    });

    group('validate', () {
      test('should return value when successful', () {
        final step = 'test'.field('String');
        final result = step.validate();

        expect(result, equals('test'));
      });

      test('should throw ValidationError when failed', () {
        final step = ''.field('String').notEmpty();

        expect(() => step.validate(), throwsA(isA<ValidationError>()));
      });
    });

    group('validateEither', () {
      test('should return Right when successful', () {
        final step = 'test'.field('String');
        final result = step.validateEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('test')),
        );
      });

      test('should return Left when failed', () {
        final step = ''.field('String').notEmpty();
        final result = step.validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(error.message, equals('Field String is empty'));
        }, (value) => fail('Should return error'));
      });
    });

    group('errorOrNull', () {
      test('should return null when successful', () {
        final step = 'test'.field('String');
        final result = step.errorOrNull();

        expect(result, isNull);
      });

      test('should return error message when failed', () {
        final step = ''.field('String').notEmpty();
        final result = step.errorOrNull();

        expect(result, equals('Field String is empty'));
      });
    });

    group('asFormValidator', () {
      test('should return null when successful', () {
        final step = 'test'.field('String');
        final result = step.asFormValidator();

        expect(result, isNull);
      });

      test('should return error message when failed', () {
        final step = ''.field('String').notEmpty();
        final result = step.asFormValidator();

        expect(result, equals('Field String is empty'));
      });
    });
  });

  group('AsyncValidationStep', () {
    group('tryMap', () {
      test('should transform value successfully', () async {
        final step = Future.value('123').field('Number');
        final result = await step
            .tryMap(
              (value) async => int.parse(value),
              (fieldName) => '$fieldName must be a number',
            )
            .validateEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(123)),
        );
      });

      test('should return error when transformation fails', () async {
        final step = Future.value('abc').field('Number');
        final result = await step
            .tryMap(
              (value) async => int.parse(value),
              (fieldName) => '$fieldName must be a number',
            )
            .validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be a number'));
        }, (value) => fail('Should return error'));
      });
    });

    group('check', () {
      test('should succeed when condition is true', () async {
        final step = Future.value('test@example.com').field('Email');
        final result = await step
            .check(
              (value) async => value.contains('@'),
              (fieldName) => '$fieldName must contain @',
            )
            .validateEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('test@example.com')),
        );
      });

      test('should fail when condition is false', () async {
        final step = Future.value('invalid-email').field('Email');
        final result = await step
            .check(
              (value) async => value.contains('@'),
              (fieldName) => '$fieldName must contain @',
            )
            .validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Email'));
          expect(error.message, equals('Email must contain @'));
        }, (value) => fail('Should return error'));
      });
    });

    group('then', () {
      test('should chain with sync validation step', () async {
        final step = Future.value('123').field('Number');
        final result = await step
            .then(
              (syncStep) => syncStep.tryMap(
                (value) => int.parse(value),
                (fieldName) => '$fieldName must be a number',
              ),
            )
            .validateEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(123)),
        );
      });
    });

    group('bind', () {
      test('should bind to sync validation step', () async {
        final step = Future.value('123').field('Number');
        final result = await step
            .bind((value) => Right(int.parse(value)))
            .validateEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(123)),
        );
      });
    });

    group('bindAsync', () {
      test('should bind to async validation step', () async {
        final step = Future.value('123').field('Number');
        final result = await step
            .bindAsync(
              (value) => TaskEither.tryCatch(
                () async => int.parse(value),
                (error, stackTrace) =>
                    ValidationError('Number', 'Invalid number', stackTrace),
              ),
            )
            .validateEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(123)),
        );
      });
    });

    group('validate', () {
      test('should return value when successful', () async {
        final step = Future.value('test').field('String');
        final result = await step.validate();

        expect(result, equals('test'));
      });

      test('should throw ValidationError when failed', () async {
        final step = Future.value('')
            .field('String')
            .check(
              (value) async => value.isNotEmpty,
              (fieldName) => 'Field $fieldName is empty',
            );

        expect(() => step.validate(), throwsA(isA<ValidationError>()));
      });
    });

    group('validateEither', () {
      test('should return Right when successful', () async {
        final step = Future.value('test').field('String');
        final result = await step.validateEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('test')),
        );
      });

      test('should return Left when failed', () async {
        final step = Future.value('')
            .field('String')
            .check(
              (value) async => value.isNotEmpty,
              (fieldName) => 'Field $fieldName is empty',
            );
        final result = await step.validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('String'));
          expect(error.message, equals('Field String is empty'));
        }, (value) => fail('Should return error'));
      });
    });

    group('validateTaskEither', () {
      test('should return TaskEither', () async {
        final step = Future.value('test').field('String');
        final taskEither = step.validateTaskEither();

        expect(taskEither, isA<TaskEither<ValidationError, String>>());

        final result = await taskEither.run();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals('test')),
        );
      });
    });

    group('errorOrNull', () {
      test('should return null when successful', () async {
        final step = Future.value('test').field('String');
        final result = await step.errorOrNull();

        expect(result, isNull);
      });

      test('should return error message when failed', () async {
        final step = Future.value('')
            .field('String')
            .check(
              (value) async => value.isNotEmpty,
              (fieldName) => 'Field $fieldName is empty',
            );
        final result = await step.errorOrNull();

        expect(result, equals('Field String is empty'));
      });
    });

    group('asFormValidator', () {
      test('should return null when successful', () async {
        final step = Future.value('test').field('String');
        final result = await step.asFormValidator();

        expect(result, isNull);
      });

      test('should return error message when failed', () async {
        final step = Future.value('')
            .field('String')
            .check(
              (value) async => value.isNotEmpty,
              (fieldName) => 'Field $fieldName is empty',
            );
        final result = await step.asFormValidator();

        expect(result, equals('Field String is empty'));
      });
    });
  });
}
