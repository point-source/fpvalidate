/// Represents the result of a validation operation.
sealed class ValidationResult<T> {
  const ValidationResult();
}

/// Indicates that validation was successful.
class ValidationSuccess<T> extends ValidationResult<T> {
  const ValidationSuccess(this.value);
  final T value;
}

/// Indicates that validation failed.
class ValidationFailure<T> extends ValidationResult<T> {
  const ValidationFailure(this.message);
  final String message;
}
