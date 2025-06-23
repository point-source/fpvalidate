part of '../validation_step.dart';

extension StringExtension on ValidationStep<String> {
  ValidationStep<String> notEmpty() => bind(
    (value) =>
        value.isEmpty ? _fail('Field $fieldName is empty') : _success(value),
  );

  ValidationStep<int> toInt() => bind((value) {
    final parsed = int.tryParse(value);

    return parsed != null
        ? _success<int>(parsed)
        : _fail<int>('Value $value for field $fieldName is not a number');
  });
}
