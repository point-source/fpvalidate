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
class ValidationError {
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
