import 'translations/english_validation_messages.dart';
import 'validation_messages.dart';

/// Global configuration for validation messages.
///
/// This class provides a singleton pattern for managing the current validation
/// messages implementation used throughout the package. It defaults to the
/// English implementation but can be configured with custom implementations.
///
/// Example:
/// ```dart
/// // Set custom messages
/// ValidationI18n.setMessages(CustomValidationMessages());
///
/// // Reset to defaults
/// ValidationI18n.resetToDefaults();
///
/// // Get current messages
/// final messages = ValidationI18n.messages;
/// ```
class ValidationI18n {
  static ValidationMessages _messages = EnglishValidationMessages();

  /// Set the global validation messages implementation.
  ///
  /// This method allows you to configure the entire package to use your custom
  /// validation messages. The messages will be used for all validation operations
  /// until changed again.
  ///
  /// [validationMessages] is the implementation to use for all validation messages.
  static void setMessages(ValidationMessages validationMessages) {
    _messages = validationMessages;
  }

  /// Get the current validation messages implementation.
  ///
  /// Returns the currently configured validation messages implementation.
  /// This is used internally by the validation extensions to get formatted messages.
  static ValidationMessages get messages => _messages;

  /// Reset to default validation messages.
  ///
  /// This method resets the global configuration to use the default English
  /// validation messages.
  static void resetToDefaults() {
    _messages = EnglishValidationMessages();
  }
}
