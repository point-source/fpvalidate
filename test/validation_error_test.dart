import 'package:test/test.dart';
import 'package:fpvalidate/src/validation_error.dart';

void main() {
  group('ValidationError', () {
    test('should create a validation error with field name and message', () {
      const error = ValidationError('Email', 'Email must be valid');
      expect(error.fieldName, equals('Email'));
      expect(error.message, equals('Email must be valid'));
      expect(error.stackTrace, isNull);
    });

    test('should create a validation error with stack trace', () {
      final stackTrace = StackTrace.current;
      final error = ValidationError('Email', 'Email must be valid', stackTrace);
      expect(error.fieldName, equals('Email'));
      expect(error.message, equals('Email must be valid'));
      expect(error.stackTrace, equals(stackTrace));
    });

    test('should format toString correctly', () {
      const error = ValidationError('Email', 'Email must be valid');
      expect(error.toString(), equals('Email: Email must be valid'));
    });

    test('should be equal to another ValidationError with same properties', () {
      const error1 = ValidationError('Email', 'Email must be valid');
      const error2 = ValidationError('Email', 'Email must be valid');
      expect(error1, equals(error2));
    });

    test(
      'should not be equal to ValidationError with different field name',
      () {
        const error1 = ValidationError('Email', 'Email must be valid');
        const error2 = ValidationError('Password', 'Email must be valid');
        expect(error1, isNot(equals(error2)));
      },
    );

    test('should not be equal to ValidationError with different message', () {
      const error1 = ValidationError('Email', 'Email must be valid');
      const error2 = ValidationError('Email', 'Email is required');
      expect(error1, isNot(equals(error2)));
    });

    test(
      'should not be equal to ValidationError with different stack trace',
      () {
        final stackTrace1 = StackTrace.current;
        // ignore: avoid-duplicate-initializers
        final stackTrace2 = StackTrace.current;
        final error1 = ValidationError(
          'Email',
          'Email must be valid',
          stackTrace1,
        );
        final error2 = ValidationError(
          'Email',
          'Email must be valid',
          stackTrace2,
        );
        expect(error1, isNot(equals(error2)));
      },
    );

    test('should have consistent hashCode', () {
      const error1 = ValidationError('Email', 'Email must be valid');
      const error2 = ValidationError('Email', 'Email must be valid');
      expect(error1.hashCode, equals(error2.hashCode));
    });
  });
}
