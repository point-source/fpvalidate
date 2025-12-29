import 'package:test/test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trust_but_verify/trust_but_verify.dart';

void main() {
  group('FieldExtension', () {
    test('should create sync validation step for string', () {
      final step = 'test@example.com'.trust('Email');

      expect(step, isA<SyncValidationStep<String>>());
      expect(step.fieldName, equals('Email'));

      final result = step.verifyEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals('test@example.com')),
      );
    });

    test('should create sync validation step for int', () {
      final step = 42.trust('Age');

      expect(step, isA<SyncValidationStep<int>>());
      expect(step.fieldName, equals('Age'));

      final result = step.verifyEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals(42)),
      );
    });

    test('should create sync validation step for double', () {
      final step = 3.14.trust('Pi');

      expect(step, isA<SyncValidationStep<double>>());
      expect(step.fieldName, equals('Pi'));

      final result = step.verifyEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals(3.14)),
      );
    });

    test('should create sync validation step for bool', () {
      final step = true.trust('IsActive');

      expect(step, isA<SyncValidationStep<bool>>());
      expect(step.fieldName, equals('IsActive'));

      final result = step.verifyEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals(true)),
      );
    });

    test('should create sync validation step for list', () {
      final step = [1, 2, 3].trust('Numbers');

      expect(step, isA<SyncValidationStep<List<int>>>());
      expect(step.fieldName, equals('Numbers'));

      final result = step.verifyEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals([1, 2, 3])),
      );
    });

    test('should create sync validation step for map', () {
      final step = {'key': 'value'}.trust('Config');

      expect(step, isA<SyncValidationStep<Map<String, String>>>());
      expect(step.fieldName, equals('Config'));

      final result = step.verifyEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals({'key': 'value'})),
      );
    });

    test('should create sync validation step for null', () {
      final step = null.trust('Nullable');

      expect(step, isA<SyncValidationStep<Null>>());
      expect(step.fieldName, equals('Nullable'));

      final result = step.verifyEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, isNull),
      );
    });
  });

  group('FieldExtensionAsync', () {
    test('should create async validation step for Future string', () async {
      final step = Future.value('test@example.com').trust('Email');

      expect(step, isA<AsyncValidationStep<String>>());
      expect(step.fieldName, equals('Email'));

      final result = await step.verifyEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals('test@example.com')),
      );
    });

    test('should create async validation step for Future int', () async {
      final step = Future.value(42).trust('Age');

      expect(step, isA<AsyncValidationStep<int>>());
      expect(step.fieldName, equals('Age'));

      final result = await step.verifyEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals(42)),
      );
    });

    test('should create async validation step for Future double', () async {
      final step = Future.value(3.14).trust('Pi');

      expect(step, isA<AsyncValidationStep<double>>());
      expect(step.fieldName, equals('Pi'));

      final result = await step.verifyEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals(3.14)),
      );
    });

    test('should create async validation step for Future bool', () async {
      final step = Future.value(true).trust('IsActive');

      expect(step, isA<AsyncValidationStep<bool>>());
      expect(step.fieldName, equals('IsActive'));

      final result = await step.verifyEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals(true)),
      );
    });

    test('should create async validation step for Future list', () async {
      final step = Future.value([1, 2, 3]).trust('Numbers');

      expect(step, isA<AsyncValidationStep<List<int>>>());
      expect(step.fieldName, equals('Numbers'));

      final result = await step.verifyEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals([1, 2, 3])),
      );
    });

    test('should create async validation step for Future map', () async {
      final step = Future.value({'key': 'value'}).trust('Config');

      expect(step, isA<AsyncValidationStep<Map<String, String>>>());
      expect(step.fieldName, equals('Config'));

      final result = await step.verifyEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals({'key': 'value'})),
      );
    });

    test('should create async validation step for Future null', () async {
      final step = Future.value(null).trust('Nullable');

      expect(step, isA<AsyncValidationStep<Null>>());
      expect(step.fieldName, equals('Nullable'));

      final result = await step.verifyEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, isNull),
      );
    });

    test('should handle Future that throws error', () async {
      final step = Future<String>.error('Test error').trust('ErrorField');

      expect(step, isA<AsyncValidationStep<String>>());
      expect(step.fieldName, equals('ErrorField'));

      final result = await step.verifyEither();
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
      ).trust('ExceptionField');

      expect(step, isA<AsyncValidationStep<Object>>());
      expect(step.fieldName, equals('ExceptionField'));

      final result = await step.verifyEither();
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
      final step = right.trust('Email');

      expect(step, isA<SyncValidationStep<String>>());
      expect(step.fieldName, equals('Email'));

      final result = step.verifyEither();
      expect(result.isRight(), isTrue);
      expect(result.fold((l) => null, (r) => r), equals('test@example.com'));
    });

    test('should work with string validation on Right', () {
      final right = Right<String, String>('test@example.com');
      final result = right.trust('Email').isNotEmpty().isEmail().verifyEither();

      expect(result.isRight(), isTrue);
      expect(result.fold((l) => null, (r) => r), equals('test@example.com'));
    });

    test('should fail validation on Right with invalid email', () {
      final right = Right<String, String>('invalid-email');
      final result = right.trust('Email').isNotEmpty().isEmail().verifyEither();

      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l.fieldName, (r) => null), equals('Email'));
      expect(result.fold((l) => l.message, (r) => null), contains('Email'));
    });

    test('should handle empty string in Right', () {
      final right = Right<String, String>('');
      final result = right.trust('Email').isNotEmpty().verifyEither();

      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l.fieldName, (r) => null), equals('Email'));
      expect(result.fold((l) => l.message, (r) => null), contains('Email'));
    });
  });

  group('FieldExtensionLeft', () {
    test('should propagate left error from Left', () {
      final left = Left<String, String>('Invalid input');
      final step = left.trust('Email');

      expect(step, isA<SyncValidationStep<String>>());
      expect(step.fieldName, equals('Email'));

      final result = step.verifyEither();
      expect(result.isLeft(), isTrue);
      expect(
        result.fold((l) => l.message, (r) => null),
        equals('Invalid input'),
      );
      expect(result.fold((l) => l.fieldName, (r) => null), equals('Email'));
    });
  });

  group('FieldExtensionEither', () {
    test('should create validation step from Right Either', () {
      final either = Right<String, String>('test@example.com');
      final step = either.trust('Email');

      expect(step, isA<SyncValidationStep<String>>());
      expect(step.fieldName, equals('Email'));

      final result = step.verifyEither();
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error'),
        (value) => expect(value, equals('test@example.com')),
      );
    });

    test('should create validation step from Left Either', () {
      final either = Left<String, String>('Previous error');
      final step = either.trust('Email');

      expect(step, isA<SyncValidationStep<String>>());
      expect(step.fieldName, equals('Email'));

      final result = step.verifyEither();
      expect(result.isLeft(), isTrue);
      result.fold((error) {
        expect(error, isA<FieldInitializationError>());
        expect(error.fieldName, equals('Email'));
        expect(error.message, equals('Previous error'));
      }, (value) => fail('Should return error'));
    });

    test('should work with string validation on Right Either', () {
      final either = Right<String, String>('test@example.com');
      final result = either
          .trust('Email')
          .isNotEmpty()
          .isEmail()
          .verifyEither();

      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error: ${error.message}'),
        (value) => expect(value, equals('test@example.com')),
      );
    });

    test('should fail validation on Right Either with invalid email', () {
      final either = Right<String, String>('invalid-email');
      final result = either
          .trust('Email')
          .isNotEmpty()
          .isEmail()
          .verifyEither();

      expect(result.isLeft(), isTrue);
      result.fold((error) {
        expect(error.fieldName, equals('Email'));
        expect(error.message, contains('Email'));
      }, (value) => fail('Should return error'));
    });

    test('should handle empty string in Right Either', () {
      final either = Right<String, String>('');
      final result = either.trust('Email').isNotEmpty().verifyEither();

      expect(result.isLeft(), isTrue);
      result.fold((error) {
        expect(error.fieldName, equals('Email'));
        expect(error.message, contains('Email'));
      }, (value) => fail('Should return error'));
    });

    test('should propagate left error without additional validation', () {
      final either = Left<String, String>('Database connection failed');
      final result = either.trust('UserData').verifyEither();

      expect(result.isLeft(), isTrue);
      result.fold((error) {
        expect(error, isA<FieldInitializationError>());
        expect(error.fieldName, equals('UserData'));
        expect(error.message, equals('Database connection failed'));
      }, (value) => fail('Should return error'));
    });

    test('should work with numeric validation on Right Either', () {
      final either = Right<String, int>(42);
      final result = either.trust('Age').min(18).max(100).verifyEither();

      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error: ${error.message}'),
        (value) => expect(value, equals(42)),
      );
    });

    test('should fail numeric validation on Right Either', () {
      final either = Right<String, int>(15);
      final result = either.trust('Age').min(18).verifyEither();

      expect(result.isLeft(), isTrue);
      result.fold((error) {
        expect(error.fieldName, equals('Age'));
        expect(error.message, contains('Age'));
      }, (value) => fail('Should return error'));
    });

    test('should handle Either with different left type', () {
      final either = Left<Exception, String>(Exception('Network error'));
      final result = either.trust('Response').verifyEither();

      expect(result.isLeft(), isTrue);
      result.fold((error) {
        expect(error, isA<FieldInitializationError>());
        expect(error.fieldName, equals('Response'));
        expect(error.message, contains('Exception: Network error'));
      }, (value) => fail('Should return error'));
    });

    test('should handle Either with complex right type', () {
      final either = Right<String, Map<String, dynamic>>({
        'name': 'John',
        'age': 30,
      });
      final result = either.trust('UserData').verifyEither();

      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail('Should not return error: ${error.message}'),
        (value) {
          expect(value, isA<Map<String, dynamic>>());
          expect(value['name'], equals('John'));
          expect(value['age'], equals(30));
        },
      );
    });

    test('should work with Either from computation', () {
      Either<String, int> parseAge(String input) {
        final parsed = int.tryParse(input);

        return parsed != null ? Right(parsed) : Left('Invalid age format');
      }

      final validResult = parseAge('25').trust('Age').min(18).verifyEither();

      expect(validResult.isRight(), isTrue);
      validResult.fold(
        (error) => fail('Should not return error: ${error.message}'),
        (value) => expect(value, equals(25)),
      );

      final invalidResult = parseAge(
        'not a number',
      ).trust('Age').verifyEither();

      expect(invalidResult.isLeft(), isTrue);
      invalidResult.fold((error) {
        expect(error, isA<FieldInitializationError>());
        expect(error.fieldName, equals('Age'));
        expect(error.message, equals('Invalid age format'));
      }, (value) => fail('Should return error'));
    });
  });

  group('FieldExtensionTaskEither', () {
    test('should create validation step from Right TaskEither', () async {
      final taskEither = TaskEither.right('test@example.com');
      final step = taskEither.trust('Email');

      expect(step, isA<AsyncValidationStep<String>>());
      expect(step.fieldName, equals('Email'));

      final result = await step.verifyEither();
      expect(result.isRight(), isTrue);
      expect(result.fold((l) => null, (r) => r), equals('test@example.com'));
    });

    test('should propagate left error from TaskEither', () async {
      final taskEither = TaskEither<String, String>.left('Invalid input');
      final step = taskEither.trust('Email');

      expect(step, isA<AsyncValidationStep<String>>());
      expect(step.fieldName, equals('Email'));

      final result = await step.verifyEither();
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
          .trust('Email')
          .then((step) => step.isNotEmpty().isEmail())
          .verifyEither();

      expect(result.isRight(), isTrue);
      expect(result.fold((l) => null, (r) => r), equals('test@example.com'));
    });

    test(
      'should fail validation on Right TaskEither with invalid email',
      () async {
        final taskEither = TaskEither.right('invalid-email');
        final result = await taskEither
            .trust('Email')
            .then((step) => step.isNotEmpty().isEmail())
            .verifyEither();

        expect(result.isLeft(), isTrue);
        expect(result.fold((l) => l.fieldName, (r) => null), equals('Email'));
        expect(result.fold((l) => l.message, (r) => null), contains('Email'));
      },
    );

    test('should handle empty string in Right TaskEither', () async {
      final taskEither = TaskEither.right('');
      final result = await taskEither
          .trust('Email')
          .then((step) => step.isNotEmpty())
          .verifyEither();

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
          .trust('Email')
          .then((step) => step.isNotEmpty().isEmail())
          .verifyEither();

      expect(result.isRight(), isTrue);
      expect(result.fold((l) => null, (r) => r), equals('test@example.com'));
    });
  });

  group('Integration tests', () {
    test('should work with numeric validation on Right', () {
      final right = Right<Exception, int>(42);
      final result = right.trust('Age').min(18).verifyEither();

      expect(result.isRight(), isTrue);
      expect(result.fold((l) => null, (r) => r), equals(42));
    });

    test('should work with numeric validation on TaskEither', () async {
      final taskEither = TaskEither.right(42);
      final result = await taskEither
          .trust('Age')
          .then((step) => step.min(18))
          .verifyEither();

      expect(result.isRight(), isTrue);
      expect(result.fold((l) => null, (r) => r), equals(42));
    });
  });
}
