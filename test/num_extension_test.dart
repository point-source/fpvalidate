import 'package:test/test.dart';
import 'package:fpvalidate/fpvalidate.dart';

void main() {
  group('NumExtension', () {
    group('min', () {
      test('should succeed when value is greater than min', () {
        final result = 10.field('Number').min(5).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(10)),
        );
      });

      test('should succeed when value equals min', () {
        final result = 5.field('Number').min(5).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(5)),
        );
      });

      test('should fail when value is less than min', () {
        final result = 3.field('Number').min(5).validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(
            error.message,
            equals(
              'Value 3 of field Number must be greater than or equal to 5',
            ),
          );
        }, (value) => fail('Should return error'));
      });

      test('should work with negative numbers', () {
        final result = (-5).field('Number').min(-10).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(-5)),
        );
      });
    });

    group('max', () {
      test('should succeed when value is less than max', () {
        final result = 5.field('Number').max(10).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(5)),
        );
      });

      test('should succeed when value equals max', () {
        final result = 10.field('Number').max(10).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(10)),
        );
      });

      test('should fail when value is greater than max', () {
        final result = 15.field('Number').max(10).validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(
            error.message,
            equals('Value 15 of field Number must be less than or equal to 10'),
          );
        }, (value) => fail('Should return error'));
      });
    });

    group('isEven', () {
      test('should succeed with even numbers', () {
        final result = 4.field('Number').isEven().validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(4)),
        );
      });

      test('should fail with odd numbers', () {
        final result = 5.field('Number').isEven().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Value 5 of field Number must be even'));
        }, (value) => fail('Should return error'));
      });

      test('should work with zero', () {
        final result = 0.field('Number').isEven().validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(0)),
        );
      });

      test('should work with negative even numbers', () {
        final result = (-2).field('Number').isEven().validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(-2)),
        );
      });
    });

    group('isOdd', () {
      test('should succeed with odd numbers', () {
        final result = 5.field('Number').isOdd().validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(5)),
        );
      });

      test('should fail with even numbers', () {
        final result = 4.field('Number').isOdd().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Value 4 of field Number must be odd'));
        }, (value) => fail('Should return error'));
      });

      test('should work with negative odd numbers', () {
        final result = (-3).field('Number').isOdd().validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(-3)),
        );
      });
    });

    group('isPositive', () {
      test('should succeed with positive numbers', () {
        final result = 5.field('Number').isPositive().validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(5)),
        );
      });

      test('should fail with zero', () {
        final result = 0.field('Number').isPositive().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be positive'));
        }, (value) => fail('Should return error'));
      });

      test('should fail with negative numbers', () {
        final result = (-5).field('Number').isPositive().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be positive'));
        }, (value) => fail('Should return error'));
      });
    });

    group('isNonNegative', () {
      test('should succeed with positive numbers', () {
        final result = 5.field('Number').isNonNegative().validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(5)),
        );
      });

      test('should succeed with zero', () {
        final result = 0.field('Number').isNonNegative().validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(0)),
        );
      });

      test('should fail with negative numbers', () {
        final result = (-5).field('Number').isNonNegative().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be non-negative'));
        }, (value) => fail('Should return error'));
      });
    });

    group('isNegative', () {
      test('should succeed with negative numbers', () {
        final result = (-5).field('Number').isNegative().validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(-5)),
        );
      });

      test('should fail with zero', () {
        final result = 0.field('Number').isNegative().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be negative'));
        }, (value) => fail('Should return error'));
      });

      test('should fail with positive numbers', () {
        final result = 5.field('Number').isNegative().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be negative'));
        }, (value) => fail('Should return error'));
      });
    });

    group('isNonPositive', () {
      test('should succeed with negative numbers', () {
        final result = (-5).field('Number').isNonPositive().validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(-5)),
        );
      });

      test('should succeed with zero', () {
        final result = 0.field('Number').isNonPositive().validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(0)),
        );
      });

      test('should fail with positive numbers', () {
        final result = 5.field('Number').isNonPositive().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be non-positive'));
        }, (value) => fail('Should return error'));
      });
    });

    group('isInt', () {
      test('should succeed with integer values', () {
        final result = 5.field('Number').isInt().validateEither();
        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (value) {
          expect(value, isA<int>());
          expect(value, equals(5));
        });
      });

      test('should succeed with double that equals integer', () {
        final result = 5.0.field('Number').isInt().validateEither();
        expect(result.isRight(), isTrue);
        result.fold((error) => fail('Should not return error'), (value) {
          expect(value, isA<int>());
          expect(value, equals(5));
        });
      });

      test('should fail with non-integer double', () {
        final result = 5.5.field('Number').isInt().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be an integer'));
        }, (value) => fail('Should return error'));
      });

      test('should transform type from num to int', () {
        final result = 10.field('Number').isInt().min(5).validateEither();
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
          final result = power.field('Number').isPowerOfTwo().validateEither();
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
              .field('Number')
              .isPowerOfTwo()
              .validateEither();
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
        final result = (-2).field('Number').isPowerOfTwo().validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(error.message, equals('Number must be a power of 2'));
        }, (value) => fail('Should return error'));
      });

      test('should work with double powers of 2', () {
        final result = 8.0.field('Number').isPowerOfTwo().validateEither();
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
          final result = port.field('Port').isPortNumber().validateEither();
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
          final result = port.field('Port').isPortNumber().validateEither();
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
            .field('Value')
            .isWithinPercentage(100, 10)
            .validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(95)),
        );
      });

      test('should succeed when value equals target', () {
        final result = 100
            .field('Value')
            .isWithinPercentage(100, 10)
            .validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(100)),
        );
      });

      test('should succeed when value is at boundary', () {
        final result = 90
            .field('Value')
            .isWithinPercentage(100, 10)
            .validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(90)),
        );
      });

      test('should fail when value is outside percentage range', () {
        final result = 85
            .field('Value')
            .isWithinPercentage(100, 10)
            .validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Value'));
          expect(error.message, equals('Value must be within 10.0% of 100'));
        }, (value) => fail('Should return error'));
      });

      test('should work with different percentages', () {
        final result = 98
            .field('Value')
            .isWithinPercentage(100, 5)
            .validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(98)),
        );
      });
    });

    group('inRange', () {
      test('should succeed when value is within range', () {
        final result = 5.field('Number').inRange(1, 10).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(5)),
        );
      });

      test('should succeed when value equals min', () {
        final result = 1.field('Number').inRange(1, 10).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(1)),
        );
      });

      test('should succeed when value equals max', () {
        final result = 10.field('Number').inRange(1, 10).validateEither();
        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(10)),
        );
      });

      test('should fail when value is below range', () {
        final result = 0.field('Number').inRange(1, 10).validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(
            error.message,
            equals('Value 0 of field Number must be between 1 and 10'),
          );
        }, (value) => fail('Should return error'));
      });

      test('should fail when value is above range', () {
        final result = 15.field('Number').inRange(1, 10).validateEither();
        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Number'));
          expect(
            error.message,
            equals('Value 15 of field Number must be between 1 and 10'),
          );
        }, (value) => fail('Should return error'));
      });

      test('should work with negative ranges', () {
        final result = (-5).field('Number').inRange(-10, 0).validateEither();
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
            .field('Age')
            .min(18)
            .max(65)
            .isEven()
            .validateEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (error) => fail('Should not return error'),
          (value) => expect(value, equals(24)),
        );
      });

      test('should fail on first validation failure', () {
        final result = 15
            .field('Age')
            .min(18)
            .max(65)
            .isEven()
            .validateEither();

        expect(result.isLeft(), isTrue);
        result.fold((error) {
          expect(error.fieldName, equals('Age'));
          expect(
            error.message,
            equals('Value 15 of field Age must be greater than or equal to 18'),
          );
        }, (value) => fail('Should return error'));
      });
    });
  });
}
