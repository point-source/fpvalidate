import 'package:test/test.dart';
import 'package:fpvalidate/fpvalidate.dart';
import 'package:fpvalidate/src/validation_result.dart';

void main() {
  group('Integration Tests', () {
    group('User Registration Form', () {
      test('should validate complete user registration form successfully', () {
        final email = 'user@example.com';
        final password = 'securePassword123';
        final age = 25;
        final phone = '+1234567890';

        final results = [
          email.field('Email').notEmpty().email(),
          password.field('Password').notEmpty().minLength(8),
          age.field('Age').min(13).max(120),
          phone.field('Phone').phone(),
        ].validate();

        expect(results, equals([email, password, age, phone]));
      });

      test('should fail validation for invalid user registration form', () {
        final email = 'invalid-email';
        final password = 'short';
        final age = 5;
        final phone = 'abc123';

        expect(
          () => [
            email.field('Email').notEmpty().email(),
            password.field('Password').notEmpty().minLength(8),
            age.field('Age').min(13).max(120),
            phone.field('Phone').phone(),
          ].validate(),
          throwsA(isA<ValidationError>()),
        );
      });

      test('should validate user registration with Either', () {
        final email = 'user@example.com';
        final password = 'securePassword123';

        final result = [
          email.field('Email').notEmpty().email(),
          password.field('Password').notEmpty().minLength(8),
        ].validateEither();

        expect(result.isRight(), isTrue);
        result.fold(
          (left) => fail('Should not be left'),
          (right) => expect(right, equals([email, password])),
        );
      });
    });

    group('Product Form', () {
      test('should validate product form with optional fields', () {
        final name = 'Product Name';
        final price = 29.99;
        final description = 'A great product';
        final sku = 'SKU123';
        final weight = 2.5;
        final category = null; // Optional field

        final categoryBuilder =
            category?.field('Category') ??
            // ignore: avoid-dynamic
            ValidationBuilder<dynamic>(null, 'Category');
        // ignore: avoid-dynamic
        final results = <ValidationBuilder<dynamic>>[
          name.field('Name').notEmpty().maxLength(100),
          price.field('Price').positive(),
          description.field('Description').maxLength(500),
          sku
              .field('SKU')
              .pattern(
                RegExp(r'^[A-Z]{3}\d{3}$'),
                'SKU format (3 letters + 3 digits)',
              ),
          weight.field('Weight').positive(),
          categoryBuilder,
        ].validate();

        expect(
          results,
          equals([name, price, description, sku, weight, category]),
        );
      });
    });

    group('Address Form', () {
      test('should validate address form with custom validators', () {
        final street = '123 Main St';
        final city = 'New York';
        final state = 'NY';
        final zipCode = '10001';
        final country = 'USA';

        final results = [
          street.field('Street').notEmpty().maxLength(100),
          city.field('City').notEmpty().maxLength(50),
          state.field('State').notEmpty().maxLength(2),
          zipCode.field('ZIP Code').postalCode(),
          country.field('Country').notEmpty().maxLength(50),
        ].validate();

        expect(results, equals([street, city, state, zipCode, country]));
      });
    });

    group('Async Validation', () {
      test('should validate with async custom validator', () async {
        final email = 'user@example.com';

        final result = await email
            .field('Email')
            .notEmpty()
            .email()
            .customAsync((val) async {
              // Simulate checking if email exists in database
              await Future.delayed(Duration(milliseconds: 10));
              if (val == 'existing@example.com') {
                return ValidationFailure('Email already registered');
              }

              return ValidationSuccess(val);
            })
            .validateAsync();

        expect(result, equals(email));
      });

      test('should fail async validation', () {
        final email = 'existing@example.com';

        expect(
          () async => await email.field('Email').notEmpty().email().customAsync(
            (val) async {
              await Future.delayed(Duration(milliseconds: 10));
              if (val == 'existing@example.com') {
                return ValidationFailure('Email already registered');
              }

              return ValidationSuccess(val);
            },
          ).validateAsync(),
          throwsA(isA<ValidationError>()),
        );
      });
    });

    group('Complex Validation Scenarios', () {
      test('should validate numeric fields with custom validators', () {
        final quantity = '10';
        final price = 25.50;
        final discount = '75';

        final results = [
          quantity.field('Quantity').custom((value) {
            final numValue = num.tryParse(value);
            if (numValue == null) return ValidationFailure('must be a number');
            final result = numValue
                .field('Quantity')
                .isInteger()
                .validateEither();

            return result.fold(
              (error) => ValidationFailure(error.message),
              (val) => ValidationSuccess(val.toString()),
            );
          }),
          price.field('Price').positive(),
          discount.field('Discount').custom((value) {
            final numValue = num.tryParse(value);
            if (numValue == null) return ValidationFailure('must be a number');
            final result = numValue
                .field('Discount')
                .withinPercentage(100, 50)
                .validateEither();

            return result.fold(
              (error) => ValidationFailure(error.message),
              (val) => ValidationSuccess(val.toString()),
            );
          }),
        ].validate();

        expect(results, equals([quantity, price, discount]));
      });

      test('should validate date and time fields', () {
        final date = '2023-12-25';
        final time = '14:30';

        final results = [
          date.field('Date').isoDate(),
          time.field('Time').time24Hour(),
        ].validate();

        expect(results, equals([date, time]));
      });

      test('should validate optional fields with conditional logic', () {
        final requiredField = 'required value';
        final optionalField = 'optional value';
        final nullField = null;

        final results = [
          requiredField.field('Required').notEmpty(),
          NullableValidationBuilderExtension(optionalField)
              .field('Optional')
              .custom((value) => NullableValidators.optionalNotEmpty()(value)),
          NullableValidationBuilderExtension(nullField)
              .field('Null')
              .custom(
                (value) =>
                    NullableValidators.optionalNotEmpty()(value as String?),
              ),
        ].validate();

        expect(results, equals([requiredField, optionalField, nullField]));
      });
    });

    group('Error Handling', () {
      test('should provide meaningful error messages', () {
        try {
          ''.field('Email').notEmpty().email().validate();
          fail('Should have thrown ValidationError');
        } catch (e) {
          expect(e, isA<ValidationError>());
          final error = e as ValidationError;
          expect(error.fieldName, equals('Email'));
          expect(error.message, equals('Email not provided'));
        }
      });

      test('should handle multiple validation failures in list', () {
        final builders = [
          'test'.field('Field1').notEmpty(),
          '123'.field('Field3').minLength(10),
        ];

        try {
          builders.validate();
          fail('Should have thrown ValidationError');
        } catch (e) {
          expect(e, isA<ValidationError>());
          expect((e as ValidationError).fieldName, equals('Field3'));
        }
      });
    });

    group('TaskEither Integration', () {
      test('should use TaskEither for async validation', () async {
        final email = 'user@example.com';
        final password = 'securePassword123';

        final result = [
          email.field('Email').notEmpty().email(),
          password.field('Password').notEmpty().minLength(8),
        ].validateTaskEither();

        final either = await result.run();
        expect(either.isRight(), isTrue);
        either.fold(
          (left) => fail('Should not be left'),
          (right) => expect(right, equals([email, password])),
        );
      });

      test('should handle TaskEither with async validation', () async {
        final email = 'user@example.com';

        final result = email.field('Email').notEmpty().email().customAsync((
          val,
        ) async {
          await Future.delayed(Duration(milliseconds: 10));

          return ValidationSuccess(val);
        }).validateTaskEither();

        final either = await result.run();
        expect(either.isRight(), isTrue);
        either.fold(
          (left) => fail('Should not be left'),
          (right) => expect(right, equals(email)),
        );
      });
    });
  });
}
