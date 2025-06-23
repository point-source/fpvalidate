import 'package:fpdart/fpdart.dart';
import 'package:fpvalidate/src/validation_error.dart';

part 'extensions/field_extension.dart';
part 'extensions/nullable_extension.dart';
part 'extensions/num_extension.dart';
part 'extensions/string_extension.dart';

sealed class ValidationStep<T> {
  final String fieldName;

  const ValidationStep({required this.fieldName});

  ValidationStep<R> bind<R>(Either<ValidationError, R> Function(T) f);

  AsyncValidationStep<R> bindAsync<R>(
    TaskEither<ValidationError, R> Function(T) f,
  );

  Either<ValidationError, R> _success<R>(R value) => Right(value);

  Either<ValidationError, R> _fail<R>(String message) =>
      Left(ValidationError(fieldName, message));
}

class SyncValidationStep<T> extends ValidationStep<T> {
  final Either<ValidationError, T> _value;

  const SyncValidationStep({
    required Either<ValidationError, T> value,
    required super.fieldName,
  }) : _value = value;

  @override
  SyncValidationStep<R> bind<R>(Either<ValidationError, R> Function(T) f) {
    return SyncValidationStep(value: _value.flatMap(f), fieldName: fieldName);
  }

  @override
  AsyncValidationStep<R> bindAsync<R>(
    TaskEither<ValidationError, R> Function(T) f,
  ) {
    return AsyncValidationStep(
      value: _value.toTaskEither().flatMap(f),
      fieldName: fieldName,
    );
  }

  T validate() => _value.fold((l) => throw l, (r) => r);

  Either<ValidationError, T> validateEither() => _value;
}

class AsyncValidationStep<T> extends ValidationStep<T> {
  final TaskEither<ValidationError, T> _value;

  const AsyncValidationStep({
    required TaskEither<ValidationError, T> value,
    required super.fieldName,
  }) : _value = value;

  @override
  AsyncValidationStep<R> bind<R>(Either<ValidationError, R> Function(T) f) {
    return AsyncValidationStep(
      value: _value.chainEither(f),
      fieldName: fieldName,
    );
  }

  @override
  AsyncValidationStep<R> bindAsync<R>(
    TaskEither<ValidationError, R> Function(T) f,
  ) {
    return AsyncValidationStep(value: _value.flatMap(f), fieldName: fieldName);
  }

  Future<T> validate() =>
      _value.run().then((value) => value.fold((l) => throw l, (r) => r));

  TaskEither<ValidationError, T> validateTaskEither() => _value;
}
