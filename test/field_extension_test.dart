import 'package:test/test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpvalidate/fpvalidate.dart';

void main() {
  group('FieldExtension', () {
    test('should create sync validation step for string', () {
      final step = 'test@example.com'.field('Email');

      expect(step, isA<SyncValidationStep<String>>());
      expect(step.fieldName, equals('Email'));

      final result = step.validateEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals('test@example.com')),
      );
    });

    test('should create sync validation step for int', () {
      final step = 42.field('Age');

      expect(step, isA<SyncValidationStep<int>>());
      expect(step.fieldName, equals('Age'));

      final result = step.validateEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals(42)),
      );
    });

    test('should create sync validation step for double', () {
      final step = 3.14.field('Pi');

      expect(step, isA<SyncValidationStep<double>>());
      expect(step.fieldName, equals('Pi'));

      final result = step.validateEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals(3.14)),
      );
    });

    test('should create sync validation step for bool', () {
      final step = true.field('IsActive');

      expect(step, isA<SyncValidationStep<bool>>());
      expect(step.fieldName, equals('IsActive'));

      final result = step.validateEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals(true)),
      );
    });

    test('should create sync validation step for list', () {
      final step = [1, 2, 3].field('Numbers');

      expect(step, isA<SyncValidationStep<List<int>>>());
      expect(step.fieldName, equals('Numbers'));

      final result = step.validateEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals([1, 2, 3])),
      );
    });

    test('should create sync validation step for map', () {
      final step = {'key': 'value'}.field('Config');

      expect(step, isA<SyncValidationStep<Map<String, String>>>());
      expect(step.fieldName, equals('Config'));

      final result = step.validateEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals({'key': 'value'})),
      );
    });

    test('should create sync validation step for null', () {
      final step = null.field('Nullable');

      expect(step, isA<SyncValidationStep<Null>>());
      expect(step.fieldName, equals('Nullable'));

      final result = step.validateEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, isNull),
      );
    });
  });

  group('FieldExtensionAsync', () {
    test('should create async validation step for Future string', () async {
      final step = Future.value('test@example.com').field('Email');

      expect(step, isA<AsyncValidationStep<String>>());
      expect(step.fieldName, equals('Email'));

      final result = await step.validateEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals('test@example.com')),
      );
    });

    test('should create async validation step for Future int', () async {
      final step = Future.value(42).field('Age');

      expect(step, isA<AsyncValidationStep<int>>());
      expect(step.fieldName, equals('Age'));

      final result = await step.validateEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals(42)),
      );
    });

    test('should create async validation step for Future double', () async {
      final step = Future.value(3.14).field('Pi');

      expect(step, isA<AsyncValidationStep<double>>());
      expect(step.fieldName, equals('Pi'));

      final result = await step.validateEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals(3.14)),
      );
    });

    test('should create async validation step for Future bool', () async {
      final step = Future.value(true).field('IsActive');

      expect(step, isA<AsyncValidationStep<bool>>());
      expect(step.fieldName, equals('IsActive'));

      final result = await step.validateEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals(true)),
      );
    });

    test('should create async validation step for Future list', () async {
      final step = Future.value([1, 2, 3]).field('Numbers');

      expect(step, isA<AsyncValidationStep<List<int>>>());
      expect(step.fieldName, equals('Numbers'));

      final result = await step.validateEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals([1, 2, 3])),
      );
    });

    test('should create async validation step for Future map', () async {
      final step = Future.value({'key': 'value'}).field('Config');

      expect(step, isA<AsyncValidationStep<Map<String, String>>>());
      expect(step.fieldName, equals('Config'));

      final result = await step.validateEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals({'key': 'value'})),
      );
    });

    test('should create async validation step for Future null', () async {
      final step = Future.value(null).field('Nullable');

      expect(step, isA<AsyncValidationStep<Null>>());
      expect(step.fieldName, equals('Nullable'));

      final result = await step.validateEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, isNull),
      );
    });

    test('should handle Future that throws error', () async {
      final step = Future<String>.error('Test error').field('ErrorField');

      expect(step, isA<AsyncValidationStep<String>>());
      expect(step.fieldName, equals('ErrorField'));

      final result = await step.validateEither();
      expect(result.isLeft(), isTrue);
      result.fold((error) {
        expect(error.fieldName, equals('ErrorField'));
        expect(error.message, contains('Test error'));
      }, (value) => fail('Should return error'));
    });

    test('should handle Future that completes with exception', () async {
      final step = Future.delayed(
        Duration(milliseconds: 10),
        () => throw Exception('Test exception'),
      ).field('ExceptionField');

      expect(step, isA<AsyncValidationStep<Object>>());
      expect(step.fieldName, equals('ExceptionField'));

      final result = await step.validateEither();
      expect(result.isLeft(), isTrue);
      result.fold((error) {
        expect(error.fieldName, equals('ExceptionField'));
        expect(error.message, contains('Exception: Test exception'));
      }, (value) => fail('Should return error'));
    });
  });

  group('FieldExtensionRight', () {
    test('should create validation step from Right', () {
      final right = Right<String, String>('test@example.com');
      final step = right.field('Email');

      expect(step, isA<SyncValidationStep<String>>());
      expect(step.fieldName, equals('Email'));

      final result = step.validateEither();
      expect(result.isRight(), isTrue);
      expect(result.fold((l) => null, (r) => r), equals('test@example.com'));
    });

    test('should work with string validation on Right', () {
      final right = Right<String, String>('test@example.com');
      final result = right.field('Email').notEmpty().isEmail().validateEither();

      expect(result.isRight(), isTrue);
      expect(result.fold((l) => null, (r) => r), equals('test@example.com'));
    });

    test('should fail validation on Right with invalid email', () {
      final right = Right<String, String>('invalid-email');
      final result = right.field('Email').notEmpty().isEmail().validateEither();

      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l.fieldName, (r) => null), equals('Email'));
      expect(result.fold((l) => l.message, (r) => null), contains('Email'));
    });

    test('should handle empty string in Right', () {
      final right = Right<String, String>('');
      final result = right.field('Email').notEmpty().validateEither();

      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l.fieldName, (r) => null), equals('Email'));
      expect(result.fold((l) => l.message, (r) => null), contains('Email'));
    });
  });

  group('FieldExtensionLeft', () {
    test('should propagate left error from Left', () {
      final left = Left<String, String>('Invalid input');
      final step = left.field('Email');

      expect(step, isA<SyncValidationStep<String>>());
      expect(step.fieldName, equals('Email'));

      final result = step.validateEither();
      expect(result.isLeft(), isTrue);
      expect(
        result.fold((l) => l.message, (r) => null),
        equals('Invalid input'),
      );
      expect(result.fold((l) => l.fieldName, (r) => null), equals('Email'));
    });
  });

  group('FieldExtensionTaskEither', () {
    test('should create validation step from Right TaskEither', () async {
      final taskEither = TaskEither.right('test@example.com');
      final step = taskEither.field('Email');

      expect(step, isA<AsyncValidationStep<String>>());
      expect(step.fieldName, equals('Email'));

      final result = await step.validateEither();
      expect(result.isRight(), isTrue);
      expect(result.fold((l) => null, (r) => r), equals('test@example.com'));
    });

    test('should propagate left error from TaskEither', () async {
      final taskEither = TaskEither<String, String>.left('Invalid input');
      final step = taskEither.field('Email');

      expect(step, isA<AsyncValidationStep<String>>());
      expect(step.fieldName, equals('Email'));

      final result = await step.validateEither();
      expect(result.isLeft(), isTrue);
      expect(
        result.fold((l) => l.message, (r) => null),
        equals('Invalid input'),
      );
      expect(result.fold((l) => l.fieldName, (r) => null), equals('Email'));
    });

    test('should chain validation methods on Right TaskEither', () async {
      final taskEither = TaskEither.right('test@example.com');
      final result = await taskEither
          .field('Email')
          .then((step) => step.notEmpty().isEmail())
          .validateEither();

      expect(result.isRight(), isTrue);
      expect(result.fold((l) => null, (r) => r), equals('test@example.com'));
    });

    test(
      'should fail validation on Right TaskEither with invalid email',
      () async {
        final taskEither = TaskEither.right('invalid-email');
        final result = await taskEither
            .field('Email')
            .then((step) => step.notEmpty().isEmail())
            .validateEither();

        expect(result.isLeft(), isTrue);
        expect(result.fold((l) => l.fieldName, (r) => null), equals('Email'));
        expect(result.fold((l) => l.message, (r) => null), contains('Email'));
      },
    );

    test('should handle empty string in Right TaskEither', () async {
      final taskEither = TaskEither.right('');
      final result = await taskEither
          .field('Email')
          .then((step) => step.notEmpty())
          .validateEither();

      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l.fieldName, (r) => null), equals('Email'));
      expect(result.fold((l) => l.message, (r) => null), contains('Email'));
    });

    test('should handle async operations in TaskEither', () async {
      final taskEither = TaskEither.tryCatch(
        () async => 'test@example.com',
        (error, stackTrace) => 'Async error',
      );

      final result = await taskEither
          .field('Email')
          .then((step) => step.notEmpty().isEmail())
          .validateEither();

      expect(result.isRight(), isTrue);
      expect(result.fold((l) => null, (r) => r), equals('test@example.com'));
    });
  });

  group('Integration tests', () {
    test('should work with numeric validation on Right', () {
      final right = Right<Exception, int>(42);
      final result = right.field('Age').min(18).validateEither();

      expect(result.isRight(), isTrue);
      expect(result.fold((l) => null, (r) => r), equals(42));
    });

    test('should work with numeric validation on TaskEither', () async {
      final taskEither = TaskEither.right(42);
      final result = await taskEither
          .field('Age')
          .then((step) => step.min(18))
          .validateEither();

      expect(result.isRight(), isTrue);
      expect(result.fold((l) => null, (r) => r), equals(42));
    });
  });
}
