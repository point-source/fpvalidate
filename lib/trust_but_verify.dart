/// A fluent validation library for Dart with support for transformation and sync/async validators.
///
/// This library provides a fluent API for validating data with functional programming
/// principles, supporting both synchronous (Either) and asynchronous (TaskEither) validation.
///
/// Example usage:
/// ```dart
/// import 'package:trust_but_verify/trust_but_verify.dart';
///
/// // Single field validation
/// final result = email
///     .trust('Email')
///     .isNotEmpty()
///     .isEmail()
///     .verifyEither();
///
/// // Without field name (uses generic messages)
/// final result = email
///     .trust()
///     .isNotEmpty()
///     .isEmail()
///     .verifyEither();
///
/// // Multiple field validation
/// final result = [
///   email.trust('Email').isNotEmpty().isEmail(),
///   password.trust('Password').isNotEmpty().minLength(8),
///   age.trust('Age').min(13).max(120),
/// ].verifyEither();
///
/// // Custom error messages
/// final result = step.verify((fieldName) => 'Please enter a valid $fieldName');
/// ```
library;

export 'src/errors/validation_error.dart';
export 'src/validation_step.dart';
export 'src/extensions/batch_validation_extension.dart';
export 'src/i18n/validation_messages.dart';
export 'src/i18n/translations/english_validation_messages.dart';
export 'src/i18n/validation_messages_mixin.dart';
export 'src/i18n/validation_i18n.dart';
