part of 'validation_error.dart';

sealed class NullableValidationError extends ValidationError {
  const NullableValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}

class NullValueValidationError extends NullableValidationError {
  const NullValueValidationError(
    super.fieldName,
    super.message, [
    super.stackTrace,
  ]);
}
