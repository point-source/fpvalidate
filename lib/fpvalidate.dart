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
///     .notEmpty()
///     .email()
///     .validate()
///     .mapLeft((error) => CustomError(error.message));
///
/// // Multiple field validation
/// final result = [
///   email.field('Email').notEmpty().email(),
///   password.field('Password').notEmpty().minLength(8),
///   age.field('Age').min(13).max(120),
/// ].validate()
/// .mapLeft((error) => CustomError(error.message));
/// ```
library;

export 'src/validation_error.dart';
export 'src/validation_builder.dart';
export 'src/validation_extension.dart';
export 'src/string_validators.dart';
export 'src/numeric_validators.dart';
export 'src/nullable_validators.dart';

// TODO: Export any libraries intended for clients of this package.
