import 'package:fpvalidate/src/extensions/async_validation_step.dart';
import 'package:fpvalidate/src/validation_error.dart';

part 'extensions/field_extension.dart';
part 'extensions/nullable_extension.dart';
part 'extensions/num_extension.dart';
part 'extensions/string_extension.dart';

/// A function type that validates a value and returns a validation result.
typedef Validator<T, R> = ValidationStep<R> Function(T value);

sealed class ValidationStep<T> {
  final String fieldName;
  const ValidationStep(this.fieldName);

  ValidationStep<R> next<R>(Validator<T, R> onValidate);

  AsyncValidationStep<R> nextAsync<R>(AsyncValidator<T, R> onValidate);

  Success<R> _success<R>(R value) => Success(fieldName, value);

  Failure<R> _fail<R>(String message, [StackTrace? stackTrace]) =>
      Failure(fieldName, ValidationError(fieldName, message, stackTrace));

  T get validated;

  R match<R>(R Function(T) onSuccess, R Function(ValidationError) onFailure) {
    return switch (this) {
      Success<T> success => onSuccess(success.validated),
      Failure<T> failure => onFailure(failure.error),
    };
  }
}

class Success<T> extends ValidationStep<T> {
  @override
  final T validated;

  const Success(super.fieldName, this.validated);

  @override
  ValidationStep<R> next<R>(Validator<T, R> onValidate) {
    return onValidate(validated);
  }

  @override
  AsyncValidationStep<R> nextAsync<R>(AsyncValidator<T, R> onValidate) {
    return AsyncValidationStep(onValidate(validated));
  }
}

class Failure<T> extends ValidationStep<T> {
  final ValidationError error;

  const Failure(super.fieldName, this.error);

  @override
  ValidationStep<R> next<R>(Validator<T, R> onValidate) {
    return Failure<R>(fieldName, error);
  }

  @override
  AsyncValidationStep<R> nextAsync<R>(AsyncValidator<T, R> onValidate) {
    return AsyncValidationStep(Future.value(Failure<R>(fieldName, error)));
  }

  @override
  T get validated => throw error;
}
