import 'package:trust_but_verify/src/i18n/validation_messages.dart';

/// Complete Spanish implementation of validation messages.
///
/// When [fieldName] is empty, messages use "El valor" (The value) as a generic placeholder.
class SpanishValidationMessages implements ValidationMessages {
  const SpanishValidationMessages();

  /// Helper to get display name - uses "El valor" when fieldName is empty.
  String _displayName(String fieldName) =>
      fieldName.isEmpty ? 'El valor' : fieldName;

  @override
  String emptyField(String fieldName) =>
      '${_displayName(fieldName)} no puede estar vacío';

  @override
  String minLength(String fieldName, int length) =>
      '${_displayName(fieldName)} debe tener al menos $length caracteres';

  @override
  String maxLength(String fieldName, int length) =>
      '${_displayName(fieldName)} no debe tener más de $length caracteres';

  @override
  String invalidEmail(String fieldName) =>
      '${_displayName(fieldName)} debe ser una dirección de correo válida';

  @override
  String invalidUrl(String fieldName) =>
      '${_displayName(fieldName)} debe ser una URL válida';

  @override
  String invalidPhone(String fieldName) =>
      '${_displayName(fieldName)} debe ser un número de teléfono válido';

  @override
  String invalidPattern(String fieldName, String description) =>
      '${_displayName(fieldName)} debe coincidir con el patrón: $description';

  @override
  String missingSubstring(String fieldName, String substring) =>
      '${_displayName(fieldName)} debe contener "$substring"';

  @override
  String invalidPrefix(String fieldName, String prefix) =>
      '${_displayName(fieldName)} debe comenzar con "$prefix"';

  @override
  String invalidSuffix(String fieldName, String suffix) =>
      '${_displayName(fieldName)} debe terminar con "$suffix"';

  @override
  String invalidAlphanumeric(String fieldName) =>
      '${_displayName(fieldName)} debe contener solo caracteres alfanuméricos';

  @override
  String invalidLettersOnly(String fieldName) =>
      '${_displayName(fieldName)} debe contener solo letras';

  @override
  String invalidDigitsOnly(String fieldName) =>
      '${_displayName(fieldName)} debe contener solo dígitos';

  @override
  String invalidUuid(String fieldName) =>
      '${_displayName(fieldName)} debe ser un UUID válido';

  @override
  String invalidCreditCard(String fieldName) =>
      '${_displayName(fieldName)} debe ser un número de tarjeta de crédito válido';

  @override
  String invalidPostalCode(String fieldName) =>
      '${_displayName(fieldName)} debe ser un código postal válido';

  @override
  String invalidIsoDate(String fieldName) =>
      '${_displayName(fieldName)} debe estar en formato de fecha ISO (YYYY-MM-DD)';

  @override
  String invalidDate(String fieldName) =>
      '${_displayName(fieldName)} debe ser una fecha válida';

  @override
  String invalidTime24Hour(String fieldName) =>
      '${_displayName(fieldName)} debe estar en formato de 24 horas (HH:MM)';

  @override
  String invalidTime24HourStrict(String fieldName) =>
      '${_displayName(fieldName)} debe estar en formato de 24 horas (HH:MM) con ceros iniciales';

  @override
  String invalidAllowedValue(String fieldName, List<String> allowedValues) =>
      '${_displayName(fieldName)} debe ser uno de: ${allowedValues.join(', ')}';

  @override
  String invalidForbiddenValue(
    String fieldName,
    List<String> forbiddenValues,
  ) =>
      '${_displayName(fieldName)} no debe ser uno de: ${forbiddenValues.join(', ')}';

  @override
  String invalidNumberFormat(String fieldName, String value) =>
      '"$value" no es un número válido${fieldName.isEmpty ? '' : ' para ${_displayName(fieldName)}'}';

  @override
  String invalidMinValue(String fieldName, num value, num min) =>
      '${_displayName(fieldName)} debe ser al menos $min (tiene $value)';

  @override
  String invalidMaxValue(String fieldName, num value, num max) =>
      '${_displayName(fieldName)} debe ser como máximo $max (tiene $value)';

  @override
  String invalidEvenNumber(String fieldName, num value) =>
      '${_displayName(fieldName)} debe ser par (tiene $value)';

  @override
  String invalidOddNumber(String fieldName, num value) =>
      '${_displayName(fieldName)} debe ser impar (tiene $value)';

  @override
  String invalidPositiveNumber(String fieldName) =>
      '${_displayName(fieldName)} debe ser positivo';

  @override
  String invalidNonNegativeNumber(String fieldName) =>
      '${_displayName(fieldName)} debe ser no negativo';

  @override
  String invalidNegativeNumber(String fieldName) =>
      '${_displayName(fieldName)} debe ser negativo';

  @override
  String invalidNonPositiveNumber(String fieldName) =>
      '${_displayName(fieldName)} debe ser no positivo';

  @override
  String invalidInteger(String fieldName) =>
      '${_displayName(fieldName)} debe ser un número entero';

  @override
  String invalidPowerOfTwo(String fieldName) =>
      '${_displayName(fieldName)} debe ser una potencia de 2';

  @override
  String invalidPortNumber(String fieldName) =>
      '${_displayName(fieldName)} debe ser un número de puerto válido (1-65535)';

  @override
  String invalidPercentageRange(
    String fieldName,
    double percentage,
    num target,
  ) =>
      '${_displayName(fieldName)} debe estar dentro del $percentage% de $target';

  @override
  String invalidRange(String fieldName, num value, num min, num max) =>
      '${_displayName(fieldName)} debe estar entre $min y $max (tiene $value)';

  @override
  String invalidAllowedNumericValue(
    String fieldName,
    List<num> allowedValues,
  ) =>
      '${_displayName(fieldName)} debe ser uno de: ${allowedValues.join(', ')}';

  @override
  String invalidForbiddenNumericValue(
    String fieldName,
    List<num> forbiddenValues,
  ) =>
      '${_displayName(fieldName)} no debe ser uno de: ${forbiddenValues.join(', ')}';

  @override
  String nullField(String fieldName) =>
      '${_displayName(fieldName)} no puede ser nulo';

  @override
  String typeMismatch(String fieldName, Type expectedType) =>
      '${_displayName(fieldName)} debe ser de tipo $expectedType';
}
