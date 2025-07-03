/// A functional validation library for Dart with support for TaskEither and Either types.
///
/// This library provides a fluent API for validating data with functional programming
/// principles, supporting both synchronous (Either) and asynchronous (TaskEither) validation.
///
/// Example usage:
/// ```dart
/// import 'package:fpvalidate/fpvalidate.dart';
///
/// // Single field validation
/// final result = email
///     .field('Email')
///     .isNotEmpty()
///     .isEmail()
///     .validate()
///     .mapLeft((error) => CustomError(error.message));
///
/// // Multiple field validation
/// final result = [
///   email.field('Email').isNotEmpty().isEmail(),
///   password.field('Password').isNotEmpty().minLength(8),
///   age.field('Age').min(13).max(120),
/// ].validate()
/// .mapLeft((error) => CustomError(error.message));
/// ```
library;

export 'src/validation_error.dart';
export 'src/validation_step.dart';
export 'src/extensions/batch_validation_extension.dart';

// TODO: Export any libraries intended for clients of this package.
