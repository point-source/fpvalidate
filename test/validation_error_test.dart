import 'package:test/test.dart';
import 'package:fpvalidate/fpvalidate.dart';

void main() {
  group('ValidationError', () {
    test('should create validation error with required parameters', () {
      const error = FieldInitializationError('Email', 'Email is required');

      expect(error.fieldName, equals('Email'));
      expect(error.message, equals('Email is required'));
      expect(error.stackTrace, isNull);
    });

    test('should create validation error with stack trace', () {
      final stackTrace = StackTrace.current;
      final error = FieldInitializationError(
        'Email',
        'Email is required',
        stackTrace,
      );

      expect(error.fieldName, equals('Email'));
      expect(error.message, equals('Email is required'));
      expect(error.stackTrace, equals(stackTrace));
    });

    test('should format toString correctly', () {
      const error = FieldInitializationError('Email', 'Email is required');

      expect(error.toString(), equals('Email: Email is required'));
    });

    test('should be equal to identical error', () {
      const error1 = FieldInitializationError('Email', 'Email is required');
      const error2 = FieldInitializationError('Email', 'Email is required');

      expect(error1, equals(error2));
      expect(error1.hashCode, equals(error2.hashCode));
    });

    test('should not be equal to error with different field name', () {
      const error1 = FieldInitializationError('Email', 'Email is required');
      const error2 = FieldInitializationError('Password', 'Email is required');

      expect(error1, isNot(equals(error2)));
    });

    test('should not be equal to error with different message', () {
      const error1 = FieldInitializationError('Email', 'Email is required');
      const error2 = FieldInitializationError('Email', 'Email is invalid');

      expect(error1, isNot(equals(error2)));
    });

    test('should not be equal to error with different stack trace', () {
      final stackTrace1 = StackTrace.current;
      // ignore: avoid-duplicate-initializers
      final stackTrace2 = StackTrace.current;

      final error1 = FieldInitializationError(
        'Email',
        'Email is required',
        stackTrace1,
      );
      final error2 = FieldInitializationError(
        'Email',
        'Email is required',
        stackTrace2,
      );

      expect(error1, isNot(equals(error2)));
    });

    test('should have consistent hashCode', () {
      const error = FieldInitializationError('Email', 'Email is required');

      expect(error.hashCode, equals(error.hashCode));
    });

    test('should have different hashCode for different errors', () {
      const error1 = FieldInitializationError('Email', 'Email is required');
      const error2 = FieldInitializationError(
        'Password',
        'Password is required',
      );

      expect(error1.hashCode, isNot(equals(error2.hashCode)));
    });

    test('should support pattern matching for different error types', () {
      const fieldError = FieldInitializationError('Field', 'Field error');
      const stringError = EmptyStringValidationError('String', 'String error');
      const numericError = InvalidMinValueValidationError(
        'Number',
        'Number error',
      );
      const nullableError = NullValueValidationError(
        'Nullable',
        'Nullable error',
      );

      // Test pattern matching
      expect(_getErrorType(fieldError), equals('FieldInitializationError'));
      expect(_getErrorType(stringError), equals('StringValidationError'));
      expect(_getErrorType(numericError), equals('NumericValidationError'));
      expect(_getErrorType(nullableError), equals('NullableValidationError'));
    });

    test('should create different error types correctly', () {
      const asyncError = AsyncFieldInitializationError('Async', 'Async error');
      const tryMapError = TryMapValidationError('TryMap', 'TryMap error');
      const checkError = CheckValidationError('Check', 'Check error');
      const bindError = BindValidationError('Bind', 'Bind error');

      expect(asyncError.fieldName, equals('Async'));
      expect(tryMapError.message, equals('TryMap error'));
      expect(checkError.stackTrace, isNull);
      expect(bindError.toString(), equals('Bind: Bind error'));
    });

    test('should create string validation errors correctly', () {
      const emailError = InvalidEmailValidationError('Email', 'Invalid email');
      const urlError = InvalidUrlValidationError('URL', 'Invalid URL');
      const phoneError = InvalidPhoneValidationError('Phone', 'Invalid phone');

      expect(emailError, isA<StringValidationError>());
      expect(urlError, isA<StringValidationError>());
      expect(phoneError, isA<StringValidationError>());
    });

    test('should create numeric validation errors correctly', () {
      const minError = InvalidMinValueValidationError('Age', 'Age too low');
      const maxError = InvalidMaxValueValidationError('Age', 'Age too high');
      const rangeError = InvalidRangeValidationError(
        'Score',
        'Score out of range',
      );

      expect(minError, isA<NumericValidationError>());
      expect(maxError, isA<NumericValidationError>());
      expect(rangeError, isA<NumericValidationError>());
    });

    test('should create nullable validation errors correctly', () {
      const nullError = NullValueValidationError(
        'Required',
        'Field is required',
      );

      expect(nullError, isA<NullableValidationError>());
      expect(nullError.fieldName, equals('Required'));
      expect(nullError.message, equals('Field is required'));
    });
  });
}

String _getErrorType(ValidationError error) {
  return switch (error) {
    FieldInitializationError() => 'FieldInitializationError',
    AsyncFieldInitializationError() => 'AsyncFieldInitializationError',
    TryMapValidationError() => 'TryMapValidationError',
    CheckValidationError() => 'CheckValidationError',
    BindValidationError() => 'BindValidationError',
    StringValidationError() => 'StringValidationError',
    NumericValidationError() => 'NumericValidationError',
    NullableValidationError() => 'NullableValidationError',
  };
}
