import 'package:test/test.dart';
import 'package:trust_but_verify/trust_but_verify.dart';

void main() {
  group('NumExtension', () {
    group('min', () {
      test('should succeed when value is greater than min', () {
        final result = 10.trust('Number').min(5).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(10)),
        );
      });

      test('should succeed when value equals min', () {
        final result = 5.trust('Number').min(5).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(5)),
        );
      });

      test('should fail when value is less than min', () {
        final result = 3.trust('Number').min(5).verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(
            error.message,
            equals(
              'Number must be at least 5 (got 3)',
            ),
          );
        }, (value) => fail('Should return error'));
      });

      test('should work with negative numbers', () {
        final result = (-5).trust('Number').min(-10).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(-5)),
        );
      });
    });

    group('max', () {
      test('should succeed when value is less than max', () {
        final result = 5.trust('Number').max(10).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(5)),
        );
      });

      test('should succeed when value equals max', () {
        final result = 10.trust('Number').max(10).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(10)),
        );
      });

      test('should fail when value is greater than max', () {
        final result = 15.trust('Number').max(10).verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(
            error.message,
            equals('Number must be at most 10 (got 15)'),
          );
        }, (value) => fail('Should return error'));
      });
    });

    group('isEven', () {
      test('should succeed with even numbers', () {
        final result = 4.trust('Number').isEven().verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(4)),
        );
      });

      test('should fail with odd numbers', () {
        final result = 5.trust('Number').isEven().verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be even (got 5)'));
        }, (value) => fail('Should return error'));
      });

      test('should work with zero', () {
        final result = 0.trust('Number').isEven().verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(0)),
        );
      });

      test('should work with negative even numbers', () {
        final result = (-2).trust('Number').isEven().verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(-2)),
        );
      });
    });

    group('isOdd', () {
      test('should succeed with odd numbers', () {
        final result = 5.trust('Number').isOdd().verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(5)),
        );
      });

      test('should fail with even numbers', () {
        final result = 4.trust('Number').isOdd().verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be odd (got 4)'));
        }, (value) => fail('Should return error'));
      });

      test('should work with negative odd numbers', () {
        final result = (-3).trust('Number').isOdd().verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(-3)),
        );
      });
    });

    group('isPositive', () {
      test('should succeed with positive numbers', () {
        final result = 5.trust('Number').isPositive().verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(5)),
        );
      });

      test('should fail with zero', () {
        final result = 0.trust('Number').isPositive().verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be positive'));
        }, (value) => fail('Should return error'));
      });

      test('should fail with negative numbers', () {
        final result = (-5).trust('Number').isPositive().verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be positive'));
        }, (value) => fail('Should return error'));
      });
    });

    group('isNonNegative', () {
      test('should succeed with positive numbers', () {
        final result = 5.trust('Number').isNonNegative().verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(5)),
        );
      });

      test('should succeed with zero', () {
        final result = 0.trust('Number').isNonNegative().verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(0)),
        );
      });

      test('should fail with negative numbers', () {
        final result = (-5).trust('Number').isNonNegative().verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be non-negative'));
        }, (value) => fail('Should return error'));
      });
    });

    group('isNegative', () {
      test('should succeed with negative numbers', () {
        final result = (-5).trust('Number').isNegative().verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(-5)),
        );
      });

      test('should fail with zero', () {
        final result = 0.trust('Number').isNegative().verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be negative'));
        }, (value) => fail('Should return error'));
      });

      test('should fail with positive numbers', () {
        final result = 5.trust('Number').isNegative().verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be negative'));
        }, (value) => fail('Should return error'));
      });
    });

    group('isNonPositive', () {
      test('should succeed with negative numbers', () {
        final result = (-5).trust('Number').isNonPositive().verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(-5)),
        );
      });

      test('should succeed with zero', () {
        final result = 0.trust('Number').isNonPositive().verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(0)),
        );
      });

      test('should fail with positive numbers', () {
        final result = 5.trust('Number').isNonPositive().verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be non-positive'));
        }, (value) => fail('Should return error'));
      });
    });

    group('isInt', () {
      test('should succeed with integer values', () {
        final result = 5.trust('Number').isInt().verifyEither();
        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (value) {
          expect(value, isA<int>());
          expect(value, equals(5));
        });
      });

      test('should succeed with double that equals integer', () {
        final result = 5.0.trust('Number').isInt().verifyEither();
        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (value) {
          expect(value, isA<int>());
          expect(value, equals(5));
        });
      });

      test('should fail with non-integer double', () {
        final result = 5.5.trust('Number').isInt().verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be an integer'));
        }, (value) => fail('Should return error'));
      });

      test('should transform type from num to int', () {
        final result = 10.trust('Number').isInt().min(5).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (value) {
          expect(value, isA<int>());
          expect(value, equals(10));
        });
      });
    });

    group('isPowerOfTwo', () {
      test('should succeed with powers of 2', () {
        final powers = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024];
        for (final power in powers) {
          final result = power.trust('Number').isPowerOfTwo().verifyEither();
          expect(
            result.isRight(),
            isTrue,
            reason: '$power should be a power of 2',
          );
          result.fold(
            (error) => fail('$power should be a power of 2'),
            (value) => expect(value, equals(power)),
          );
        }
      });

      test('should fail with non-powers of 2', () {
        final nonPowers = [0, 3, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15];
        for (final nonPower in nonPowers) {
          final result = nonPower
              .trust('Number')
              .isPowerOfTwo()
              .verifyEither();
          expect(
            result.isLeft(),
            isTrue,
            reason: '$nonPower should not be a power of 2',
          );
          result.fold((error) {
            expect(error.fieldName, equals('Number'));
            expect(error.message, equals('Number must be a power of 2'));
          }, (value) => fail('$nonPower should not be a power of 2'));
        }
      });

      test('should fail with negative numbers', () {
        final result = (-2).trust('Number').isPowerOfTwo().verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be a power of 2'));
        }, (value) => fail('Should return error'));
      });

      test('should work with double powers of 2', () {
        final result = 8.0.trust('Number').isPowerOfTwo().verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(8.0)),
        );
      });
    });

    group('isPortNumber', () {
      test('should succeed with valid port numbers', () {
        final validPorts = [1, 80, 443, 8080, 3000, 5000, 65535];
        for (final port in validPorts) {
          final result = port.trust('Port').isPortNumber().verifyEither();
          expect(
            result.isRight(),
            isTrue,
            reason: '$port should be a valid port',
          );
          result.fold(
            (error) => fail('$port should be a valid port'),
            (value) => expect(value, equals(port)),
          );
        }
      });

      test('should fail with invalid port numbers', () {
        final invalidPorts = [0, 65536, 70000, -1, -100];
        for (final port in invalidPorts) {
          final result = port.trust('Port').isPortNumber().verifyEither();
          expect(
            result.isLeft(),
            isTrue,
            reason: '$port should not be a valid port',
          );
          result.fold((error) {
            expect(error.fieldName, equals('Port'));
            expect(
              error.message,
              equals('Port must be a valid port number (1-65535)'),
            );
          }, (value) => fail('$port should not be a valid port'));
        }
      });
    });

    group('isWithinPercentage', () {
      test('should succeed when value is within percentage range', () {
        final result = 95
            .trust('Value')
            .isWithinPercentage(100, 10)
            .verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(95)),
        );
      });

      test('should succeed when value equals target', () {
        final result = 100
            .trust('Value')
            .isWithinPercentage(100, 10)
            .verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(100)),
        );
      });

      test('should succeed when value is at boundary', () {
        final result = 90
            .trust('Value')
            .isWithinPercentage(100, 10)
            .verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(90)),
        );
      });

      test('should fail when value is outside percentage range', () {
        final result = 85
            .trust('Value')
            .isWithinPercentage(100, 10)
            .verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Value'));
          expect(error.message, equals('Value must be within 10.0% of 100'));
        }, (value) => fail('Should return error'));
      });

      test('should work with different percentages', () {
        final result = 98
            .trust('Value')
            .isWithinPercentage(100, 5)
            .verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(98)),
        );
      });
    });

    group('inRange', () {
      test('should succeed when value is within range', () {
        final result = 5.trust('Number').inRange(1, 10).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(5)),
        );
      });

      test('should succeed when value equals min', () {
        final result = 1.trust('Number').inRange(1, 10).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(1)),
        );
      });

      test('should succeed when value equals max', () {
        final result = 10.trust('Number').inRange(1, 10).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(10)),
        );
      });

      test('should fail when value is below range', () {
        final result = 0.trust('Number').inRange(1, 10).verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(
            error.message,
            equals('Number must be between 1 and 10 (got 0)'),
          );
        }, (value) => fail('Should return error'));
      });

      test('should fail when value is above range', () {
        final result = 15.trust('Number').inRange(1, 10).verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(
            error.message,
            equals('Number must be between 1 and 10 (got 15)'),
          );
        }, (value) => fail('Should return error'));
      });

      test('should work with negative ranges', () {
        final result = (-5).trust('Number').inRange(-10, 0).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(-5)),
        );
      });
    });

    group('chaining', () {
      test('should work with multiple validators', () {
        final result = 24
            .trust('Age')
            .min(18)
            .max(65)
            .isEven()
            .verifyEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(24)),
        );
      });

      test('should fail on first validation failure', () {
        final result = 15
            .trust('Age')
            .min(18)
            .max(65)
            .isEven()
            .verifyEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Age'));
          expect(
            error.message,
            equals('Age must be at least 18 (got 15)'),
          );
        }, (value) => fail('Should return error'));
      });
    });

    group('isOneOf', () {
      test('should succeed when value is in allowed values list', () {
        final result = 3.trust('Priority').isOneOf([
          1,
          2,
          3,
          4,
          5,
        ]).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(3)),
        );
      });

      test('should fail when value is not in allowed values list', () {
        final result = 7.trust('Priority').isOneOf([
          1,
          2,
          3,
          4,
          5,
        ]).verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Priority'));
          expect(
            error.message,
            equals('Priority must be one of: 1, 2, 3, 4, 5'),
          );
        }, (value) => fail('Should return error'));
      });

      test('should work with single allowed value', () {
        final result = 42.trust('Number').isOneOf([42]).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(42)),
        );
      });

      test('should work with empty list (always fails)', () {
        final result = 5.trust('Number').isOneOf([]).verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be one of: '));
        }, (value) => fail('Should return error'));
      });

      test('should work with negative numbers', () {
        final result = (-1).trust('Number').isOneOf([
          -1,
          0,
          1,
        ]).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(-1)),
        );
      });

      test('should work with doubles', () {
        final result = 3.14.trust('Pi').isOneOf([
          3.14,
          2.71,
          1.41,
        ]).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(3.14)),
        );
      });

      test('should work with mixed int and double values', () {
        // ignore: avoid-unnecessary-type-casts
        final result = (5 as num).trust('Number').isOneOf([
          1,
          2.5,
          5,
          10.0,
        ]).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(5)),
        );
      });
    });

    group('isNoneOf', () {
      test('should succeed when value is not in forbidden values list', () {
        final result = 3000.trust('Port').isNoneOf([
          80,
          443,
          8080,
        ]).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(3000)),
        );
      });

      test('should fail when value is in forbidden values list', () {
        final result = 80.trust('Port').isNoneOf([
          80,
          443,
          8080,
        ]).verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Port'));
          expect(
            error.message,
            equals('Port must not be one of: 80, 443, 8080'),
          );
        }, (value) => fail('Should return error'));
      });

      test('should work with single forbidden value', () {
        final result = 3000.trust('Port').isNoneOf([8080]).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(3000)),
        );
      });

      test('should work with empty list (always succeeds)', () {
        final result = 5000.trust('Port').isNoneOf([]).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(5000)),
        );
      });

      test('should work with negative numbers', () {
        final result = (-5).trust('Number').isNoneOf([
          -1,
          0,
          1,
        ]).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(-5)),
        );
      });

      test('should fail with negative numbers when value matches', () {
        final result = (-1).trust('Number').isNoneOf([
          -1,
          0,
          1,
        ]).verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must not be one of: -1, 0, 1'));
        }, (value) => fail('Should return error'));
      });

      test('should work with doubles', () {
        final result = 2.5.trust('Rating').isNoneOf([
          0.0,
          1.0,
          2.0,
        ]).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(2.5)),
        );
      });

      test('should fail with doubles when value matches', () {
        final result = 2.0.trust('Rating').isNoneOf([
          0.0,
          1.0,
          2.0,
        ]).verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Rating'));
          expect(
            error.message,
            equals('Rating must not be one of: 0.0, 1.0, 2.0'),
          );
        }, (value) => fail('Should return error'));
      });

      test('should work with mixed int and double values', () {
        // ignore: avoid-unnecessary-type-casts
        final result = (7 as num).trust('Number').isNoneOf([
          1,
          2.5,
          5,
          10.0,
        ]).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(7)),
        );
      });

      test(
        'should fail with mixed int and double values when value matches',
        () {
          // ignore: avoid-unnecessary-type-casts
          final result = (5 as num).trust('Number').isNoneOf([
            1,
            2.5,
            5,
            10.0,
          ]).verifyEither();
          expect(result.isLeft(), isTrue);
          result.fold((error) {
            expect(error.fieldName, equals('Number'));
            expect(
              error.message,
              equals('Number must not be one of: 1, 2.5, 5, 10.0'),
            );
          }, (value) => fail('Should return error'));
        },
      );

      test('should work with zero', () {
        final result = 0.trust('Number').isNoneOf([-1, 1]).verifyEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(0)),
        );
      });

      test('should fail with zero when it is forbidden', () {
        final result = 0.trust('Number').isNoneOf([-1, 0, 1]).verifyEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must not be one of: -1, 0, 1'));
        }, (value) => fail('Should return error'));
      });
    });
  });
}
