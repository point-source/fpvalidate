part of '../validation_step.dart';

/// Extension that provides the [field] method for creating validation steps from values.
///
/// This extension allows you to start a validation chain by calling [field] on any value.
/// The [field] method creates a [SyncValidationStep] that can be chained with various
/// validation methods.
///
/// Example:
/// ```dart
/// final result = 'test@example.com'
///     .field('Email')
///     .isNotEmpty()
///     .isEmail()
///     .validateEither();
/// ```
extension FieldExtension<T> on T {
  /// Creates a synchronous validation step for this value.
  ///
  /// This method is the entry point for creating validation chains. It wraps the
  /// current value in a [SyncValidationStep] that can be chained with various
  /// validation methods.
  ///
  /// [fieldName] is used in error messages to identify which field failed validation.
  /// It should be descriptive and user-friendly (e.g., 'Email', 'Password', 'Age').
  ///
  /// Returns a [SyncValidationStep<T>] that can be chained with validation methods.
  ///
  /// Example:
  /// ```dart
  /// final step = 'test@example.com'.field('Email');
  /// final result = step.isNotEmpty().isEmail().validateEither();
  /// ```
  SyncValidationStep<T> field(String fieldName) =>
      ._(value: Right(this), fieldName: fieldName);
}

/// Extension that provides the [field] method for creating validation steps from [Future] values.
///
/// This extension allows you to start an asynchronous validation chain by calling [field]
/// on a [Future]. The [field] method creates an [AsyncValidationStep] that can be chained
/// with various validation methods.
///
/// Example:
/// ```dart
/// final result = await Future.value('test@example.com')
///     .field('Email')
///     .isNotEmpty()
///     .isEmail()
///     .validateEither();
/// ```
extension FieldExtensionAsync<T> on Future<T> {
  /// Creates an asynchronous validation step for this [Future] value.
  ///
  /// This method is the entry point for creating asynchronous validation chains.
  /// It wraps the current [Future] in an [AsyncValidationStep] that can be chained
  /// with various validation methods.
  ///
  /// [fieldName] is used in error messages to identify which field failed validation.
  /// It should be descriptive and user-friendly (e.g., 'Email', 'Password', 'Age').
  ///
  /// Returns an [AsyncValidationStep<T>] that can be chained with validation methods.
  ///
  /// Example:
  /// ```dart
  /// final step = Future.value('test@example.com').field('Email');
  /// final result = await step.isNotEmpty().isEmail().validateEither();
  /// ```
  AsyncValidationStep<T> field(String fieldName) => ._(
    value: TaskEither.tryCatch(
      () async => await this,
      (error, stackTrace) => AsyncFieldInitializationError(
        fieldName,
        error.toString(),
        stackTrace,
      ),
    ),
    fieldName: fieldName,
  );
}

/// Extension that provides the [field] method for creating validation steps from [Either] values.
///
/// This extension allows you to start a validation chain by calling [field] on an [Either].
/// The [field] method creates a [SyncValidationStep] that validates the right value if it exists,
/// or propagates the left error if the [Either] is a left.
///
/// Example:
/// ```dart
/// final result = Right('test@example.com')
///     .field('Email')
///     .isNotEmpty()
///     .isEmail()
///     .validateEither();
/// ```
extension FieldExtensionRight<L, R> on Right<L, R> {
  /// Creates a synchronous validation step for the right value of this [Right].
  ///
  /// This method is the entry point for creating validation chains from [Right] values.
  /// It creates a [SyncValidationStep] that can be chained with various validation methods.
  ///
  /// [fieldName] is used in error messages to identify which field failed validation.
  /// It should be descriptive and user-friendly (e.g., 'Email', 'Password', 'Age').
  ///
  /// Returns a [SyncValidationStep<R>] that can be chained with validation methods.
  ///
  /// Example:
  /// ```dart
  /// final step = Right('test@example.com').field('Email');
  /// final result = step.isNotEmpty().isEmail().validateEither();
  /// ```
  SyncValidationStep<R> field(String fieldName) =>
      ._(value: Right(value), fieldName: fieldName);
}

/// Extension that provides the [field] method for creating validation steps from [Left] values.
///
/// This extension allows you to start a validation chain by calling [field] on a [Left].
/// The [field] method creates a [SyncValidationStep] that propagates the left error.
///
/// Example:
/// ```dart
/// final result = Left('Invalid input')
///     .field('Email')
///     .validateEither();
/// ```
extension FieldExtensionLeft<L, R> on Left<L, R> {
  /// Creates a synchronous validation step that propagates the left error.
  ///
  /// This method is the entry point for creating validation chains from [Left] values.
  /// It creates a [SyncValidationStep] that immediately fails with the left error.
  ///
  /// [fieldName] is used in error messages to identify which field failed validation.
  /// It should be descriptive and user-friendly (e.g., 'Email', 'Password', 'Age').
  ///
  /// Returns a [SyncValidationStep<R>] that immediately fails with the left error.
  ///
  /// Example:
  /// ```dart
  /// final step = Left('Invalid input').field('Email');
  /// final result = step.validateEither();
  /// ```
  SyncValidationStep<R> field(String fieldName) => ._(
    value: Left(
      FieldInitializationError(fieldName, value.toString(), .current),
    ),
    fieldName: fieldName,
  );
}

/// Extension that provides the [field] method for creating validation steps from [Either] values.
///
/// This extension allows you to start a validation chain by calling [field] on an [Either].
/// The [field] method creates a [SyncValidationStep] that validates the right value if it exists,
/// or propagates the left error wrapped in a [FieldInitializationError] if the [Either] is a left.
///
/// This extension is useful when you have an [Either] value from a previous operation and want
/// to continue with validation. It handles both [Left] and [Right] cases automatically.
///
/// Example:
/// ```dart
/// final either = Right<String, String>('test@example.com');
/// final result = either
///     .field('Email')
///     .isNotEmpty()
///     .isEmail()
///     .validateEither();
///
/// final errorEither = Left<String, String>('Previous error');
/// final errorResult = errorEither
///     .field('Email')
///     .validateEither(); // Propagates the error
/// ```
extension FieldExtensionEither<L, R> on Either<L, R> {
  /// Creates a synchronous validation step for the value of this [Either].
  ///
  /// This method is the entry point for creating validation chains from [Either] values.
  /// It uses [fold] to handle both cases:
  /// - If this is a [Left], it wraps the left value in a [FieldInitializationError] and
  ///   creates a failing [SyncValidationStep].
  /// - If this is a [Right], it creates a successful [SyncValidationStep] with the right value.
  ///
  /// [fieldName] is used in error messages to identify which field failed validation.
  /// It should be descriptive and user-friendly (e.g., 'Email', 'Password', 'Age').
  ///
  /// Returns a [SyncValidationStep<R>] that can be chained with validation methods.
  ///
  /// Example:
  /// ```dart
  /// // Success case
  /// final rightEither = Right<String, String>('valid@email.com');
  /// final step = rightEither.field('Email');
  /// final result = step.isEmail().validateEither();
  /// // result is Right('valid@email.com')
  ///
  /// // Error case
  /// final leftEither = Left<String, String>('Database error');
  /// final errorStep = leftEither.field('Email');
  /// final errorResult = errorStep.validateEither();
  /// // errorResult is Left(FieldInitializationError('Email', 'Database error', ...))
  /// ```
  SyncValidationStep<R> field(String fieldName) => fold(
    (l) => ._(
      value: Left(FieldInitializationError(fieldName, l.toString(), .current)),
      fieldName: fieldName,
    ),
    (r) => ._(value: Right(r), fieldName: fieldName),
  );
}

/// Extension that provides the [field] method for creating validation steps from [TaskEither] values.
///
/// This extension allows you to start an asynchronous validation chain by calling [field]
/// on a [TaskEither]. The [field] method creates an [AsyncValidationStep] that validates
/// the right value if it exists, or propagates the left error if the [TaskEither] is a left.
///
/// Example:
/// ```dart
/// final result = await TaskEither.right('test@example.com')
///     .field('Email')
///     .isNotEmpty()
///     .isEmail()
///     .validateEither();
/// ```
extension FieldExtensionTaskEither<L, R> on TaskEither<L, R> {
  /// Creates an asynchronous validation step for the right value of this [TaskEither].
  ///
  /// This method is the entry point for creating asynchronous validation chains from [TaskEither] values.
  /// If this [TaskEither] resolves to a right, it creates an [AsyncValidationStep] that can be chained
  /// with various validation methods. If it resolves to a left, the error is propagated.
  ///
  /// [fieldName] is used in error messages to identify which field failed validation.
  /// It should be descriptive and user-friendly (e.g., 'Email', 'Password', 'Age').
  ///
  /// Returns an [AsyncValidationStep<R>] that can be chained with validation methods.
  ///
  /// Example:
  /// ```dart
  /// final step = TaskEither.right('test@example.com').field('Email');
  /// final result = await step.isNotEmpty().isEmail().validateEither();
  /// ```
  AsyncValidationStep<R> field(String fieldName) => ._(
    value: flatMap((right) => TaskEither.right(right)).mapLeft(
      (left) => FieldInitializationError(fieldName, left.toString(), .current),
    ),
    fieldName: fieldName,
  );
}
