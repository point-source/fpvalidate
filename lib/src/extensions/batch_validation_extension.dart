import 'package:fpdart/fpdart.dart';
import 'package:fpvalidate/fpvalidate.dart';

extension BatchValidationExtension<T> on List<ValidationStep<T>> {
  Future<List<T>> validateAsync() => Future.wait(
    map(
      (step) => switch (step) {
        SyncValidationStep<T> _ => Future.value(step.validate()),
        AsyncValidationStep<T> _ => step.validate().then((value) => value),
      },
    ),
  );

  TaskEither<ValidationError, List<T>> validateTaskEither() => map(
    (step) => switch (step) {
      SyncValidationStep<T> _ => step.validateEither().toTaskEither(),
      AsyncValidationStep<T> _ => step.validateTaskEither(),
    },
  ).sequenceTaskEither();
}

extension BatchSyncValidationExtension<T> on List<SyncValidationStep<T>> {
  List<T> validate() => map((step) => step.validate()).toList();

  Either<ValidationError, List<T>> validateEither() =>
      map((step) => step.validateEither()).sequenceEither();
}

extension BatchAsyncValidationExtension<T> on List<AsyncValidationStep<T>> {
  Future<List<T>> validateAsync() =>
      BatchValidationExtension(this).validateAsync();

  TaskEither<ValidationError, List<T>> validateTaskEither() =>
      BatchValidationExtension(this).validateTaskEither();
}
