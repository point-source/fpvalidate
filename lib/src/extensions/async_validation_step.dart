import 'dart:async';

import 'package:fpvalidate/src/validation_step.dart';

/// A function type that asynchronously validates a value and returns a validation result.
typedef AsyncValidator<T, R> = Future<ValidationStep<R>> Function(T value);

class AsyncValidationStep<T> {
  final Future<ValidationStep<T>> _run;

  const AsyncValidationStep(this._run);

  AsyncValidationStep<R> next<R>(AsyncValidator<T, R> onValidate) {
    return AsyncValidationStep(_run.then((step) => onValidate(step.validated)));
  }

  Future<T> get validated => _run.then((step) => step.validated);
}
