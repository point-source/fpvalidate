## 0.1.1

- Added field extensions for Either and TaskEither types from fpdart
- You can now start validation chains directly from Right, Left, and TaskEither values

## 0.1.0

- Initial version with comprehensive validation library
- Support for functional programming with fpdart Either and TaskEither
- Fluent API for chaining validation rules
- Built-in validators for strings, numbers, and nullable types
- String validators: email, URL, phone, UUID, credit card, postal code, ISO date, 24-hour time
- Numeric validators: min/max, range, even/odd, positive/negative, power of 2, perfect square, port number
- Batch validation for multiple fields
- Async validation support
- Custom validation with check() and tryMap()
- Error handling with descriptive messages
- Nullable field support
