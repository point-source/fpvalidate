part of '../validation_step.dart';

/// Extension that provides the [trust] method for creating validation steps from values.
///
/// This extension allows you to start a validation chain by calling [trust] on any value.
/// The [trust] method creates a [SyncValidationStep] that can be chained with various
/// validation methods.
///
/// Example:
/// ```dart
/// // With field name
/// final result = 'test@example.com'
///     .trust('Email')
///     .isNotEmpty()
///     .isEmail()
///     .verify();
///
/// // Without field name (uses generic messages)
/// final result = 'test@example.com'
///     .trust()
///     .isNotEmpty()
///     .isEmail()
///     .verify();
/// ```
extension TrustExtension<T> on T {
  /// Creates a synchronous validation step for this value.
  ///
  /// This method is the entry point for creating validation chains. It wraps the
  /// current value in a [SyncValidationStep] that can be chained with various
  /// validation methods.
  ///
  /// [fieldName] is used in error messages to identify which field failed validation.
  /// It should be descriptive and user-friendly (e.g., 'Email', 'Password', 'Age').
  /// If omitted, error messages will use generic language (e.g., "Value must be...").
  ///
  /// Returns a [SyncValidationStep<T>] that can be chained with validation methods.
  ///
  /// Example:
  /// ```dart
  /// final step = 'test@example.com'.trust('Email');
  /// final result = step.isNotEmpty().isEmail().verify();
  /// ```
  SyncValidationStep<T> trust([String fieldName = '']) =>
      ._(value: Right(this), fieldName: fieldName);
}

/// Extension that provides the [trust] method for creating validation steps from [Future] values.
///
/// This extension allows you to start an asynchronous validation chain by calling [trust]
/// on a [Future]. The [trust] method creates an [AsyncValidationStep] that can be chained
/// with various validation methods.
///
/// Example:
/// ```dart
/// final result = await Future.value('test@example.com')
///     .trust('Email')
///     .isNotEmpty()
///     .isEmail()
///     .verify();
/// ```
extension TrustExtensionAsync<T> on Future<T> {
  /// Creates an asynchronous validation step for this [Future] value.
  ///
  /// This method is the entry point for creating asynchronous validation chains.
  /// It wraps the current [Future] in an [AsyncValidationStep] that can be chained
  /// with various validation methods.
  ///
  /// [fieldName] is used in error messages to identify which field failed validation.
  /// It should be descriptive and user-friendly (e.g., 'Email', 'Password', 'Age').
  /// If omitted, error messages will use generic language.
  ///
  /// Returns an [AsyncValidationStep<T>] that can be chained with validation methods.
  ///
  /// Example:
  /// ```dart
  /// final step = Future.value('test@example.com').trust('Email');
  /// final result = await step.isNotEmpty().isEmail().verify();
  /// ```
  AsyncValidationStep<T> trust([String fieldName = '']) => ._(
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

/// Extension that provides the [trust] method for creating validation steps from [Right] values.
///
/// This extension allows you to start a validation chain by calling [trust] on a [Right].
/// The [trust] method creates a [SyncValidationStep] that validates the right value.
///
/// Example:
/// ```dart
/// final result = Right('test@example.com')
///     .trust('Email')
///     .isNotEmpty()
///     .isEmail()
///     .verify();
/// ```
extension TrustExtensionRight<L, R> on Right<L, R> {
  /// Creates a synchronous validation step for the right value of this [Right].
  ///
  /// This method is the entry point for creating validation chains from [Right] values.
  /// It creates a [SyncValidationStep] that can be chained with various validation methods.
  ///
  /// [fieldName] is used in error messages to identify which field failed validation.
  /// It should be descriptive and user-friendly (e.g., 'Email', 'Password', 'Age').
  /// If omitted, error messages will use generic language.
  ///
  /// Returns a [SyncValidationStep<R>] that can be chained with validation methods.
  ///
  /// Example:
  /// ```dart
  /// final step = Right('test@example.com').trust('Email');
  /// final result = step.isNotEmpty().isEmail().verify();
  /// ```
  SyncValidationStep<R> trust([String fieldName = '']) =>
      ._(value: Right(value), fieldName: fieldName);
}

/// Extension that provides the [trust] method for creating validation steps from [Left] values.
///
/// This extension allows you to start a validation chain by calling [trust] on a [Left].
/// The [trust] method creates a [SyncValidationStep] that propagates the left error.
///
/// Example:
/// ```dart
/// final result = Left('Invalid input')
///     .trust('Email')
///     .verify();
/// // Throws FieldInitializationError
/// ```
extension TrustExtensionLeft<L, R> on Left<L, R> {
  /// Creates a synchronous validation step that propagates the left error.
  ///
  /// This method is the entry point for creating validation chains from [Left] values.
  /// It creates a [SyncValidationStep] that immediately fails with the left error.
  ///
  /// [fieldName] is used in error messages to identify which field failed validation.
  /// It should be descriptive and user-friendly (e.g., 'Email', 'Password', 'Age').
  /// If omitted, error messages will use generic language.
  ///
  /// Returns a [SyncValidationStep<R>] that immediately fails with the left error.
  ///
  /// Example:
  /// ```dart
  /// final step = Left('Invalid input').trust('Email');
  /// final result = step.verify(); // Throws FieldInitializationError
  /// ```
  SyncValidationStep<R> trust([String fieldName = '']) => ._(
    value: Left(
      FieldInitializationError(fieldName, value.toString(), .current),
    ),
    fieldName: fieldName,
  );
}

/// Extension that provides the [trust] method for creating validation steps from [Either] values.
///
/// This extension allows you to start a validation chain by calling [trust] on an [Either].
/// The [trust] method creates a [SyncValidationStep] that validates the right value if it exists,
/// or propagates the left error wrapped in a [FieldInitializationError] if the [Either] is a left.
///
/// This extension is useful when you have an [Either] value from a previous operation and want
/// to continue with validation. It handles both [Left] and [Right] cases automatically.
///
/// Example:
/// ```dart
/// final either = Right<String, String>('test@example.com');
/// final result = either
///     .trust('Email')
///     .isNotEmpty()
///     .isEmail()
///     .verify();
///
/// final errorEither = Left<String, String>('Previous error');
/// final errorResult = errorEither
///     .trust('Email')
///     .verify(); // Throws FieldInitializationError
/// ```
extension TrustExtensionEither<L, R> on Either<L, R> {
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
  /// If omitted, error messages will use generic language.
  ///
  /// Returns a [SyncValidationStep<R>] that can be chained with validation methods.
  ///
  /// Example:
  /// ```dart
  /// // Success case
  /// final rightEither = Right<String, String>('valid@email.com');
  /// final step = rightEither.trust('Email');
  /// final result = step.isEmail().verify();
  /// // result is 'valid@email.com'
  ///
  /// // Error case
  /// final leftEither = Left<String, String>('Database error');
  /// final errorStep = leftEither.trust('Email');
  /// final errorResult = errorStep.verify();
  /// // Throws FieldInitializationError('Email', 'Database error', ...)
  /// ```
  SyncValidationStep<R> trust([String fieldName = '']) => fold(
    (l) => ._(
      value: Left(FieldInitializationError(fieldName, l.toString(), .current)),
      fieldName: fieldName,
    ),
    (r) => ._(value: Right(r), fieldName: fieldName),
  );
}

/// Extension that provides the [trust] method for creating validation steps from [TaskEither] values.
///
/// This extension allows you to start an asynchronous validation chain by calling [trust]
/// on a [TaskEither]. The [trust] method creates an [AsyncValidationStep] that validates
/// the right value if it exists, or propagates the left error if the [TaskEither] is a left.
///
/// Example:
/// ```dart
/// final result = await TaskEither.right('test@example.com')
///     .trust('Email')
///     .isNotEmpty()
///     .isEmail()
///     .verify();
/// ```
extension TrustExtensionTaskEither<L, R> on TaskEither<L, R> {
  /// Creates an asynchronous validation step for the right value of this [TaskEither].
  ///
  /// This method is the entry point for creating asynchronous validation chains from [TaskEither] values.
  /// If this [TaskEither] resolves to a right, it creates an [AsyncValidationStep] that can be chained
  /// with various validation methods. If it resolves to a left, the error is propagated.
  ///
  /// [fieldName] is used in error messages to identify which field failed validation.
  /// It should be descriptive and user-friendly (e.g., 'Email', 'Password', 'Age').
  /// If omitted, error messages will use generic language.
  ///
  /// Returns an [AsyncValidationStep<R>] that can be chained with validation methods.
  ///
  /// Example:
  /// ```dart
  /// final step = TaskEither.right('test@example.com').trust('Email');
  /// final result = await step.isNotEmpty().isEmail().verify();
  /// ```
  AsyncValidationStep<R> trust([String fieldName = '']) => ._(
    value: flatMap((right) => TaskEither.right(right)).mapLeft(
      (left) => FieldInitializationError(fieldName, left.toString(), .current),
    ),
    fieldName: fieldName,
  );
}
