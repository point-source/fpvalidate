import 'package:test/test.dart';
import 'package:fpvalidate/src/validation_result.dart';

void main() {
  group('ValidationResult', () {
    group('ValidationSuccess', () {
      test('should create a success result with a value', () {
        const result = ValidationSuccess('test value');
        expect(result.value, equals('test value'));
      });

      test('should work with different types', () {
        const stringResult = ValidationSuccess('string');
        const intResult = ValidationSuccess(42);
        const doubleResult = ValidationSuccess(3.14);
        const boolResult = ValidationSuccess(true);

        expect(stringResult.value, equals('string'));
        expect(intResult.value, equals(42));
        expect(doubleResult.value, equals(3.14));
        expect(boolResult.value, equals(true));
      });

      test('should be equal to another ValidationSuccess with same value', () {
        const result1 = ValidationSuccess('test');
        const result2 = ValidationSuccess('test');
        expect(result1, equals(result2));
      });

      test('should not be equal to ValidationSuccess with different value', () {
        const result1 = ValidationSuccess('test1');
        const result2 = ValidationSuccess('test2');
        expect(result1, isNot(equals(result2)));
      });
    });

    group('ValidationFailure', () {
      test('should create a failure result with a message', () {
        const result = ValidationFailure('validation failed');
        expect(result.message, equals('validation failed'));
      });

      test(
        'should be equal to another ValidationFailure with same message',
        () {
          const result1 = ValidationFailure('error message');
          const result2 = ValidationFailure('error message');
          expect(result1, equals(result2));
        },
      );

      test(
        'should not be equal to ValidationFailure with different message',
        () {
          const result1 = ValidationFailure('error 1');
          const result2 = ValidationFailure('error 2');
          expect(result1, isNot(equals(result2)));
        },
      );
    });

    group('Pattern matching', () {
      test('should handle ValidationSuccess in switch statement', () {
        const result = ValidationSuccess('test');

        final message = switch (result) {
          ValidationSuccess(value: final val) => 'Success: $val',
          // ignore: dead_code, avoid-unrelated-type-assertions
          ValidationFailure(message: final msg) => 'Failure: $msg',
        };

        expect(message, equals('Success: test'));
      });

      test('should handle ValidationFailure in switch statement', () {
        const result = ValidationFailure('test error');

        final message = switch (result) {
          // ignore: avoid-unrelated-type-assertions
          ValidationSuccess(value: final val) => 'Success: $val',
          ValidationFailure(message: final msg) => 'Failure: $msg',
        };

        expect(message, equals('Failure: test error'));
      });
    });
  });
}
