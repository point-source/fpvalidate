import 'package:fpvalidate/fpvalidate.dart';

/// Custom validation messages that override only specific messages.
// ignore: prefer-match-file-name
class CustomValidationMessages with ValidationMessagesMixin {
  @override
  String emptyField(String fieldName) => 'The $fieldName field cannot be empty';

  @override
  String invalidEmail(String fieldName) =>
      'Please enter a valid email address for $fieldName';

  // All other messages will use the default English implementation
}

/// Complete Spanish implementation of validation messages.
class SpanishValidationMessages implements ValidationMessages {
  const SpanishValidationMessages();

  @override
  String emptyField(String fieldName) => 'El campo $fieldName está vacío';

  @override
  String minLength(String fieldName, int length) =>
      '$fieldName debe tener al menos $length caracteres';

  @override
  String maxLength(String fieldName, int length) =>
      '$fieldName no debe tener más de $length caracteres';

  @override
  String invalidEmail(String fieldName) =>
      '$fieldName debe ser una dirección de correo válida';

  @override
  String invalidUrl(String fieldName) => '$fieldName debe ser una URL válida';

  @override
  String invalidPhone(String fieldName) =>
      '$fieldName debe ser un número de teléfono válido';

  @override
  String invalidPattern(String fieldName, String description) =>
      '$fieldName debe coincidir con el patrón: $description';

  @override
  String missingSubstring(String fieldName, String substring) =>
      '$fieldName debe contener "$substring"';

  @override
  String invalidPrefix(String fieldName, String prefix) =>
      '$fieldName debe comenzar con "$prefix"';

  @override
  String invalidSuffix(String fieldName, String suffix) =>
      '$fieldName debe terminar con "$suffix"';

  @override
  String invalidAlphanumeric(String fieldName) =>
      '$fieldName debe contener solo caracteres alfanuméricos';

  @override
  String invalidLettersOnly(String fieldName) =>
      '$fieldName debe contener solo letras';

  @override
  String invalidDigitsOnly(String fieldName) =>
      '$fieldName debe contener solo dígitos';

  @override
  String invalidUuid(String fieldName) => '$fieldName debe ser un UUID válido';

  @override
  String invalidCreditCard(String fieldName) =>
      '$fieldName debe ser un número de tarjeta de crédito válido';

  @override
  String invalidPostalCode(String fieldName) =>
      '$fieldName debe ser un código postal válido';

  @override
  String invalidIsoDate(String fieldName) =>
      '$fieldName debe estar en formato de fecha ISO (YYYY-MM-DD)';

  @override
  String invalidDate(String fieldName) =>
      '$fieldName debe ser una fecha válida';

  @override
  String invalidTime24Hour(String fieldName) =>
      '$fieldName debe estar en formato de 24 horas (HH:MM)';

  @override
  String invalidTime24HourStrict(String fieldName) =>
      '$fieldName debe estar en formato de 24 horas (HH:MM) con ceros iniciales';

  @override
  String invalidAllowedValue(String fieldName, List<String> allowedValues) =>
      '$fieldName debe ser uno de: ${allowedValues.join(', ')}';

  @override
  String invalidForbiddenValue(
    String fieldName,
    List<String> forbiddenValues,
  ) => '$fieldName no debe ser uno de: ${forbiddenValues.join(', ')}';

  @override
  String invalidNumberFormat(String fieldName, String value) =>
      'El valor $value del campo $fieldName no es un número';

  @override
  String invalidMinValue(String fieldName, num value, num min) =>
      'El valor $value del campo $fieldName debe ser mayor o igual a $min';

  @override
  String invalidMaxValue(String fieldName, num value, num max) =>
      'El valor $value del campo $fieldName debe ser menor o igual a $max';

  @override
  String invalidEvenNumber(String fieldName, num value) =>
      'El valor $value del campo $fieldName debe ser par';

  @override
  String invalidOddNumber(String fieldName, num value) =>
      'El valor $value del campo $fieldName debe ser impar';

  @override
  String invalidPositiveNumber(String fieldName) =>
      '$fieldName debe ser positivo';

  @override
  String invalidNonNegativeNumber(String fieldName) =>
      '$fieldName debe ser no negativo';

  @override
  String invalidNegativeNumber(String fieldName) =>
      '$fieldName debe ser negativo';

  @override
  String invalidNonPositiveNumber(String fieldName) =>
      '$fieldName debe ser no positivo';

  @override
  String invalidInteger(String fieldName) =>
      '$fieldName debe ser un número entero';

  @override
  String invalidPowerOfTwo(String fieldName) =>
      '$fieldName debe ser una potencia de 2';

  @override
  String invalidPortNumber(String fieldName) =>
      '$fieldName debe ser un número de puerto válido (1-65535)';

  @override
  String invalidPercentageRange(
    String fieldName,
    double percentage,
    num target,
  ) => '$fieldName debe estar dentro del $percentage% de $target';

  @override
  String invalidRange(String fieldName, num value, num min, num max) =>
      'El valor $value del campo $fieldName debe estar entre $min y $max';

  @override
  String invalidAllowedNumericValue(
    String fieldName,
    List<num> allowedValues,
  ) => '$fieldName debe ser uno de: ${allowedValues.join(', ')}';

  @override
  String invalidForbiddenNumericValue(
    String fieldName,
    List<num> forbiddenValues,
  ) => '$fieldName no debe ser uno de: ${forbiddenValues.join(', ')}';

  @override
  String nullField(String fieldName) => 'El campo $fieldName es nulo';
}

/// Example demonstrating how to use custom validation messages.
///
/// This example shows how to:
/// 1. Override specific messages using the mixin
/// 2. Create a complete custom implementation
/// 3. Configure the package to use custom messages
void main() {
  // Example 1: Override only specific messages using the mixin
  print('=== Example 1: Partial Override ===');
  _examplePartialOverride();

  // Example 2: Complete custom implementation
  print('\n=== Example 2: Complete Custom Implementation ===');
  _exampleCompleteCustom();

  // Example 3: Reset to defaults
  print('\n=== Example 3: Reset to Defaults ===');
  _exampleResetToDefaults();
}

/// Example showing how to override only specific messages.
void _examplePartialOverride() {
  // Configure the package to use our custom messages
  ValidationStep.configureMessages(CustomValidationMessages());

  // Test the validation
  final email = '';
  final result = email
      .field('Email')
      .isNotEmpty() // Uses custom message
      .isEmail() // Uses custom message
      .minLength(8) // Uses default message
      .validateEither();

  result.fold(
    (error) => print('Error: ${error.message}'),
    (value) => print('Success: $value'),
  );
}

/// Example showing how to create a complete custom implementation.
void _exampleCompleteCustom() {
  // Configure the package to use Spanish messages
  ValidationStep.configureMessages(SpanishValidationMessages());

  // Test the validation
  final age = 15;
  final result = age
      .field('Edad')
      .min(18) // Uses Spanish message
      .max(65) // Uses Spanish message
      .validateEither();

  result.fold(
    (error) => print('Error: ${error.message}'),
    (value) => print('Success: $value'),
  );
}

/// Example showing how to reset to default messages.
void _exampleResetToDefaults() {
  // Reset to default English messages
  ValidationStep.resetMessages();

  // Test the validation
  final password = 'weak';
  final result = password
      .field('Password')
      .minLength(8) // Uses default English message
      .validateEither();

  result.fold(
    (error) => print('Error: ${error.message}'),
    (value) => print('Success: $value'),
  );
}
