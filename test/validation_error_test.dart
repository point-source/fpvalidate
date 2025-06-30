import 'package:test/test.dart';
import 'package:fpvalidate/fpvalidate.dart';

void main() {
  group('ValidationError', () {
    test('should create validation error with required parameters', () {
      const error = ValidationError('Email', 'Email is required');

      expect(error.fieldName, equals('Email'));
      expect(error.message, equals('Email is required'));
      expect(error.stackTrace, isNull);
    });

    test('should create validation error with stack trace', () {
      final stackTrace = StackTrace.current;
      final error = ValidationError('Email', 'Email is required', stackTrace);

      expect(error.fieldName, equals('Email'));
      expect(error.message, equals('Email is required'));
      expect(error.stackTrace, equals(stackTrace));
    });

    test('should format toString correctly', () {
      const error = ValidationError('Email', 'Email is required');

      expect(error.toString(), equals('Email: Email is required'));
    });

    test('should be equal to identical error', () {
      const error1 = ValidationError('Email', 'Email is required');
      const error2 = ValidationError('Email', 'Email is required');

      expect(error1, equals(error2));
      expect(error1.hashCode, equals(error2.hashCode));
    });

    test('should not be equal to error with different field name', () {
      const error1 = ValidationError('Email', 'Email is required');
      const error2 = ValidationError('Password', 'Email is required');

      expect(error1, isNot(equals(error2)));
    });

    test('should not be equal to error with different message', () {
      const error1 = ValidationError('Email', 'Email is required');
      const error2 = ValidationError('Email', 'Email is invalid');

      expect(error1, isNot(equals(error2)));
    });

    test('should not be equal to error with different stack trace', () {
      final stackTrace1 = StackTrace.current;
      final stackTrace2 = StackTrace.current;

      final error1 = ValidationError('Email', 'Email is required', stackTrace1);
      final error2 = ValidationError('Email', 'Email is required', stackTrace2);

      expect(error1, isNot(equals(error2)));
    });

    test('should not be equal to null', () {
      const error = ValidationError('Email', 'Email is required');

      expect(error, isNot(equals(null)));
    });

    test('should not be equal to different type', () {
      const error = ValidationError('Email', 'Email is required');

      expect(error, isNot(equals('not an error')));
    });

    test('should have consistent hashCode', () {
      const error = ValidationError('Email', 'Email is required');

      expect(error.hashCode, equals(error.hashCode));
    });

    test('should have different hashCode for different errors', () {
      const error1 = ValidationError('Email', 'Email is required');
      const error2 = ValidationError('Password', 'Password is required');

      expect(error1.hashCode, isNot(equals(error2.hashCode)));
    });
  });
}
