part 'string_validation_error.dart';
part 'numeric_validation_error.dart';
part 'nullable_validation_error.dart';

/// Represents a validation error with field name and error message.
///
/// This class is used to provide detailed information about validation failures,
/// including which field failed validation and what the specific error is.
///
/// Example:
/// ```dart
/// final error = ValidationError('Email', 'Email must be a valid email address');
/// print(error); // Output: Email: Email must be a valid email address
/// ```
sealed class ValidationError {
  /// Creates a new validation error.
  ///
  /// [fieldName] is the name of the field that failed validation.
  /// [message] is the error message describing the validation failure.
  /// [stackTrace] is an optional stack trace for debugging purposes.
  const ValidationError(this.fieldName, this.message, [this.stackTrace]);

  /// The name of the field that failed validation.
  final String fieldName;

  /// The error message describing the validation failure.
  final String message;

  /// Optional stack trace for debugging purposes.
  final StackTrace? stackTrace;

  @override
  String toString() => '$fieldName: $message';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationError &&
          runtimeType == other.runtimeType &&
          fieldName == other.fieldName &&
          message == other.message &&
          stackTrace == other.stackTrace;

  @override
  int get hashCode =>
      fieldName.hashCode ^ message.hashCode ^ stackTrace.hashCode;
}

typedef ValidationErrorFactory<T> =
    T Function(String fieldName, String message, [StackTrace? stackTrace]);

/// Represents an error that occurs during or before field initialization.
class FieldInitializationError extends ValidationError {
  /// Represents an error that occurs during or before field initialization.
  ///
  /// [fieldName] is the name of the field that failed initialization.
  /// [message] is the error message describing the initialization failure.
  /// [stackTrace] is an optional stack trace for debugging purposes.
  const FieldInitializationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

/// Represents an error that occurs during or before asynchronous field initialization.
class AsyncFieldInitializationError extends ValidationError {
  /// Creates a new asynchronous field initialization error.
  ///
  /// [fieldName] is the name of the field that failed initialization.
  /// [message] is the error message describing the initialization failure.
  /// [stackTrace] is an optional stack trace for debugging purposes.
  const AsyncFieldInitializationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

/// Represents an error that occurs during a tryMap validation step.
class TryMapValidationError extends ValidationError {
  /// Creates a new tryMap validation error.
  ///
  /// [fieldName] is the name of the field that failed validation.
  /// [message] is the error message describing the validation failure.
  /// [stackTrace] is an optional stack trace for debugging purposes.
  const TryMapValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

/// Represents an error that occurs during a check validation step.
class CheckValidationError extends ValidationError {
  /// Creates a new check validation error.
  ///
  /// [fieldName] is the name of the field that failed validation.
  /// [message] is the error message describing the validation failure.
  /// [stackTrace] is an optional stack trace for debugging purposes.
  const CheckValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

/// Represents an error that occurs during a bind validation step.
class BindValidationError extends ValidationError {
  /// Creates a new bind validation error.
  ///
  /// [fieldName] is the name of the field that failed validation.
  /// [message] is the error message describing the validation failure.
  /// [stackTrace] is an optional stack trace for debugging purposes.
  const BindValidationError(super.fieldName, super.message, [super.stackTrace]);
}
