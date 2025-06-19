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
  const ValidationError(this.fieldName, this.message);

  /// The name of the field that failed validation.
  final String fieldName;

  /// The error message describing the validation failure.
  final String message;

  @override
  String toString() => '$fieldName: $message';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationError &&
          runtimeType == other.runtimeType &&
          fieldName == other.fieldName &&
          message == other.message;

  @override
  int get hashCode => fieldName.hashCode ^ message.hashCode;
}
