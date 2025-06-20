import 'package:test/test.dart';
import 'package:fpvalidate/src/numeric_validators.dart';
import 'package:fpvalidate/src/validation_result.dart';

void main() {
  group('NumericValidators', () {
    group('isInteger', () {
      test('should pass for integer', () {
        final validator = NumericValidators.isInteger();
        final result = validator(42);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals(42));
      });

      test('should fail for decimal', () {
        final validator = NumericValidators.isInteger();
        final result = validator(42.5);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be an integer'),
        );
      });

      test('should pass for zero', () {
        final validator = NumericValidators.isInteger();
        final result = validator(0);
        expect(result, isA<ValidationSuccess>());
      });
    });

    group('isEven', () {
      test('should pass for even number', () {
        final validator = NumericValidators.isEven();
        final result = validator(42);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals(42));
      });

      test('should fail for odd number', () {
        final validator = NumericValidators.isEven();
        final result = validator(43);
        expect(result, isA<ValidationFailure>());
        expect((result as ValidationFailure).message, equals('must be even'));
      });

      test('should pass for zero', () {
        final validator = NumericValidators.isEven();
        final result = validator(0);
        expect(result, isA<ValidationSuccess>());
      });
    });

    group('isOdd', () {
      test('should pass for odd number', () {
        final validator = NumericValidators.isOdd();
        final result = validator(43);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals(43));
      });

      test('should fail for even number', () {
        final validator = NumericValidators.isOdd();
        final result = validator(42);
        expect(result, isA<ValidationFailure>());
        expect((result as ValidationFailure).message, equals('must be odd'));
      });

      test('should fail for zero', () {
        final validator = NumericValidators.isOdd();
        final result = validator(0);
        expect(result, isA<ValidationFailure>());
      });
    });

    group('isPerfectSquare', () {
      test('should pass for perfect square', () {
        final validator = NumericValidators.isPerfectSquare();
        final result = validator(16);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals(16));
      });

      test('should fail for non-perfect square', () {
        final validator = NumericValidators.isPerfectSquare();
        final result = validator(15);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be a perfect square'),
        );
      });

      test('should fail for negative number', () {
        final validator = NumericValidators.isPerfectSquare();
        final result = validator(-16);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be non-negative to be a perfect square'),
        );
      });

      test('should pass for zero', () {
        final validator = NumericValidators.isPerfectSquare();
        final result = validator(0);
        expect(result, isA<ValidationSuccess>());
      });
    });

    group('isPrime', () {
      test('should pass for prime number', () {
        final validator = NumericValidators.isPrime();
        final result = validator(17);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals(17));
      });

      test('should fail for non-prime number', () {
        final validator = NumericValidators.isPrime();
        final result = validator(15);
        expect(result, isA<ValidationFailure>());
        expect((result as ValidationFailure).message, equals('must be prime'));
      });

      test('should fail for number less than 2', () {
        final validator = NumericValidators.isPrime();
        final result = validator(1);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be at least 2 to be prime'),
        );
      });

      test('should fail for decimal', () {
        final validator = NumericValidators.isPrime();
        final result = validator(17.5);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be an integer to be prime'),
        );
      });
    });

    group('isPowerOfTwo', () {
      test('should pass for power of 2', () {
        final validator = NumericValidators.isPowerOfTwo();
        final result = validator(16);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals(16));
      });

      test('should fail for non-power of 2', () {
        final validator = NumericValidators.isPowerOfTwo();
        final result = validator(15);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be a power of 2'),
        );
      });

      test('should fail for negative number', () {
        final validator = NumericValidators.isPowerOfTwo();
        final result = validator(-16);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be positive to be a power of 2'),
        );
      });

      test('should fail for zero', () {
        final validator = NumericValidators.isPowerOfTwo();
        final result = validator(0);
        expect(result, isA<ValidationFailure>());
      });

      test('should fail for decimal', () {
        final validator = NumericValidators.isPowerOfTwo();
        final result = validator(16.5);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be an integer to be a power of 2'),
        );
      });
    });

    group('withinPercentage', () {
      test('should pass for value within percentage', () {
        final validator = NumericValidators.withinPercentage(100, 10);
        final result = validator(95);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals(95));
      });

      test('should fail for value outside percentage', () {
        final validator = NumericValidators.withinPercentage(100, 10);
        final result = validator(85);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be within 10% of 100'),
        );
      });

      test('should fail for zero target', () {
        final validator = NumericValidators.withinPercentage(0, 10);
        final result = validator(5);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('target value cannot be zero'),
        );
      });
    });

    group('isPortNumber', () {
      test('should pass for valid port number', () {
        final validator = NumericValidators.isPortNumber();
        final result = validator(8080);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals(8080));
      });

      test('should fail for port number too low', () {
        final validator = NumericValidators.isPortNumber();
        final result = validator(0);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be between 1 and 65535'),
        );
      });

      test('should fail for port number too high', () {
        final validator = NumericValidators.isPortNumber();
        final result = validator(70000);
        expect(result, isA<ValidationFailure>());
      });

      test('should fail for decimal', () {
        final validator = NumericValidators.isPortNumber();
        final result = validator(8080.5);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be an integer'),
        );
      });
    });

    group('isYear', () {
      test('should pass for valid year', () {
        final validator = NumericValidators.isYear();
        final result = validator(2023);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals(2023));
      });

      test('should fail for year too early', () {
        final validator = NumericValidators.isYear();
        final result = validator(1899);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be between 1900 and 2100'),
        );
      });

      test('should fail for year too late', () {
        final validator = NumericValidators.isYear();
        final result = validator(2101);
        expect(result, isA<ValidationFailure>());
      });

      test('should fail for decimal', () {
        final validator = NumericValidators.isYear();
        final result = validator(2023.5);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be an integer'),
        );
      });
    });

    group('isMonth', () {
      test('should pass for valid month', () {
        final validator = NumericValidators.isMonth();
        final result = validator(6);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals(6));
      });

      test('should fail for month too low', () {
        final validator = NumericValidators.isMonth();
        final result = validator(0);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be between 1 and 12'),
        );
      });

      test('should fail for month too high', () {
        final validator = NumericValidators.isMonth();
        final result = validator(13);
        expect(result, isA<ValidationFailure>());
      });
    });

    group('isDayOfMonth', () {
      test('should pass for valid day', () {
        final validator = NumericValidators.isDayOfMonth();
        final result = validator(15);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals(15));
      });

      test('should fail for day too low', () {
        final validator = NumericValidators.isDayOfMonth();
        final result = validator(0);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be between 1 and 31'),
        );
      });

      test('should fail for day too high', () {
        final validator = NumericValidators.isDayOfMonth();
        final result = validator(32);
        expect(result, isA<ValidationFailure>());
      });
    });

    group('isHour', () {
      test('should pass for valid hour', () {
        final validator = NumericValidators.isHour();
        final result = validator(14);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals(14));
      });

      test('should fail for hour too low', () {
        final validator = NumericValidators.isHour();
        final result = validator(-1);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be between 0 and 23'),
        );
      });

      test('should fail for hour too high', () {
        final validator = NumericValidators.isHour();
        final result = validator(24);
        expect(result, isA<ValidationFailure>());
      });
    });

    group('isMinute', () {
      test('should pass for valid minute', () {
        final validator = NumericValidators.isMinute();
        final result = validator(30);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals(30));
      });

      test('should fail for minute too low', () {
        final validator = NumericValidators.isMinute();
        final result = validator(-1);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be between 0 and 59'),
        );
      });

      test('should fail for minute too high', () {
        final validator = NumericValidators.isMinute();
        final result = validator(60);
        expect(result, isA<ValidationFailure>());
      });
    });

    group('isSecond', () {
      test('should pass for valid second', () {
        final validator = NumericValidators.isSecond();
        final result = validator(30);
        expect(result, isA<ValidationSuccess>());
        expect((result as ValidationSuccess).value, equals(30));
      });

      test('should fail for second too low', () {
        final validator = NumericValidators.isSecond();
        final result = validator(-1);
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('must be between 0 and 59'),
        );
      });

      test('should fail for second too high', () {
        final validator = NumericValidators.isSecond();
        final result = validator(60);
        expect(result, isA<ValidationFailure>());
      });
    });
  });
}
