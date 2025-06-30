import 'package:test/test.dart';
import 'package:fpvalidate/src/constants/regex/regex.dart';

void main() {
  group('Email Regex', () {
    test('should match valid email addresses', () {
      final validEmails = [
        'test@example.com',
        'user.name@domain.co.uk',
        'user+tag@example.org',
        '123@example.com',
        'user@subdomain.example.com',
        'user@example-domain.com',
        'user@example.com',
        'user123@example.com',
        'user_name@example.com',
        'user-name@example.com',
        'user.name@example.com',
        'user+name@example.com',
        'user%name@example.com',
        'user_name@example.co.uk',
        'user@example.co.uk',
        'user@example.org',
        'user@example.net',
        'user@example.edu',
        'user@example.gov',
        'user@example.mil',
      ];

      for (final email in validEmails) {
        expect(
          RegExp(kEmailRegex).hasMatch(email),
          isTrue,
          reason: '$email should be valid',
        );
      }
    });

    test('should not match invalid email addresses', () {
      final invalidEmails = [
        '',
        'invalid',
        '@example.com',
        'user@',
        'user..name@example.com',
        'user@.com',
        'user@example.',
        'user@example..com',
        'user@example.com.',
        'user@example.com..',
        'user@example.com...',
        'user@example.com....',
        'user@example.com.....',
        'user@example.com......',
        'user@example.com.......',
        'user@example.com........',
        'user@example.com.........',
      ];

      for (final email in invalidEmails) {
        expect(
          RegExp(kEmailRegex).hasMatch(email),
          isFalse,
          reason: '$email should be invalid',
        );
      }
    });
  });

  group('URL Regex', () {
    test('should match valid URLs', () {
      final validUrls = [
        'http://example.com',
        'https://example.com',
        'http://www.example.com',
        'https://www.example.com',
        'http://example.com/path',
        'https://example.com/path',
        'http://example.com/path?param=value',
        'https://example.com/path?param=value',
        'http://example.com/path#fragment',
        'https://example.com/path#fragment',
        'http://example.com/path?param=value#fragment',
        'https://example.com/path?param=value#fragment',
        'http://subdomain.example.com',
        'https://subdomain.example.com',
        'http://example.co.uk',
        'https://example.co.uk',
        'http://example.org',
        'https://example.org',
        'http://example.net',
        'https://example.net',
        'ftp://example.com',
        'sftp://example.com',
        'file://example.com',
      ];

      for (final url in validUrls) {
        expect(
          RegExp(kUrlRegex).hasMatch(url),
          isTrue,
          reason: '$url should be valid',
        );
      }
    });

    test('should not match invalid URLs', () {
      final invalidUrls = [
        '',
        'invalid',
        'example.com',
        'www.example.com',
        'http://',
        'https://',
        'http://.com',
        'https://.com',
        'http://example.',
        'https://example.',
      ];

      for (final url in invalidUrls) {
        expect(
          RegExp(kUrlRegex).hasMatch(url),
          isFalse,
          reason: '$url should be invalid',
        );
      }
    });
  });

  group('Phone Regex', () {
    test('should match valid phone numbers', () {
      final validPhones = [
        '1234567890',
        '123-456-7890',
        '123.456.7890',
        '123 456 7890',
        '(123) 456-7890',
        '+1 123-456-7890',
        '+1 (123) 456-7890',
        '+1-123-456-7890',
        '+1.123.456.7890',
        '+1 123 456 7890',
        '12345678901',
        '123-456-78901',
        '123.456.78901',
        '123 456 78901',
        '(123) 456-78901',
        '+1 123-456-78901',
        '+1 (123) 456-78901',
        '+1-123-456-78901',
        '+1.123.456.78901',
        '+1 123 456 78901',
        '123456789012',
        '123-456-789012',
        '123.456.789012',
        '123 456 789012',
        '(123) 456-789012',
        '+1 123-456-789012',
        '+1 (123) 456-789012',
        '+1-123-456-789012',
        '+1.123.456.789012',
        '+1 123 456 789012',
      ];

      for (final phone in validPhones) {
        expect(
          RegExp(kPhoneRegex).hasMatch(phone),
          isTrue,
          reason: '$phone should be valid',
        );
      }
    });

    test('should not match invalid phone numbers', () {
      final invalidPhones = [
        '',
        'invalid',
        '123',
        '12345',
        '123456',
        'abcdefghij',
        '123-abc-7890',
        '123.abc.7890',
        '123 abc 7890',
        '(123) abc-7890',
        '+1 abc-def-7890',
        '+1 (abc) def-7890',
        '+1-abc-def-7890',
        '+1.abc.def.7890',
        '+1 abc def 7890',
      ];

      for (final phone in invalidPhones) {
        expect(
          RegExp(kPhoneRegex).hasMatch(phone),
          isFalse,
          reason: '$phone should be invalid',
        );
      }
    });
  });

  group('UUID Regex', () {
    test('should match valid UUIDs', () {
      final validUuids = [
        '123e4567-e89b-12d3-a456-426614174000',
        '550e8400-e29b-41d4-a716-446655440000',
        '6ba7b810-9dad-11d1-80b4-00c04fd430c8',
        '6ba7b811-9dad-11d1-80b4-00c04fd430c8',
        '6ba7b812-9dad-11d1-80b4-00c04fd430c8',
        '6ba7b814-9dad-11d1-80b4-00c04fd430c8',
        '00000000-0000-0000-0000-000000000000',
        'ffffffff-ffff-ffff-ffff-ffffffffffff',
        'a1a2a3a4-b1b2-c1c2-d1d2-d3d4d5d6d7d8',
        '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
      ];

      for (final uuid in validUuids) {
        expect(
          RegExp(kUuidRegex).hasMatch(uuid),
          isTrue,
          reason: '$uuid should be valid',
        );
      }
    });

    test('should not match invalid UUIDs', () {
      final invalidUuids = [
        '',
        'invalid',
        '123e4567-e89b-12d3-a456-42661417400',
        '123e4567-e89b-12d3-a456-4266141740000',
        '123e4567-e89b-12d3-a456-42661417400g',
        '123e4567-e89b-12d3-a456-42661417400G',
        '123e4567-e89b-12d3-a456-42661417400-',
        '123e4567-e89b-12d3-a456-42661417400_',
        '123e4567-e89b-12d3-a456-42661417400.',
        '123e4567-e89b-12d3-a456-42661417400 ',
        '123e4567e89b12d3a456426614174000',
        '123e4567_e89b_12d3_a456_426614174000',
        '123e4567.e89b.12d3.a456.426614174000',
        '123e4567 e89b 12d3 a456 426614174000',
        '123e4567-e89b-12d3-a456',
        '123e4567-e89b-12d3',
        '123e4567-e89b',
        '123e4567',
        '123e4567-e89b-12d3-a456-426614174000-extra',
      ];

      for (final uuid in invalidUuids) {
        expect(
          RegExp(kUuidRegex).hasMatch(uuid),
          isFalse,
          reason: '$uuid should be invalid',
        );
      }
    });
  });

  group('Credit Card Regex', () {
    test('should match valid credit card numbers', () {
      final validCards = [
        '4111111111111111', // Visa
        '5555555555554444', // MasterCard
        '378282246310005', // American Express
        '6011111111111117', // Discover
        '3530111333300000', // JCB
        '3566002020360505', // JCB
      ];

      for (final card in validCards) {
        expect(
          RegExp(kCreditCardRegex).hasMatch(card),
          isTrue,
          reason: '$card should be valid',
        );
      }
    });

    test('should not match invalid credit card numbers', () {
      final invalidCards = [
        '',
        'invalid',
        '123456789012345',
        '12345678901234567',
        '123456789012345678',
        '1234567890123456789',
        '12345678901234567890',
        '123456789012345678901',
        '1234567890123456789012',
        '12345678901234567890123',
        '123456789012345678901234',
        '1234567890123456789012345',
        '12345678901234567890123456',
        '123456789012345678901234567',
        '1234567890123456789012345678',
        '12345678901234567890123456789',
        '123456789012345678901234567890',
        'abcdefghijklmnop',
        '1234-5678-9012-3456',
        '1234 5678 9012 3456',
        '1234.5678.9012.3456',
        '1234_5678_9012_3456',
        '1234.5678.9012.3456.',
        '1234-5678-9012-3456-',
        '1234 5678 9012 3456 ',
      ];

      for (final card in invalidCards) {
        expect(
          RegExp(kCreditCardRegex).hasMatch(card),
          isFalse,
          reason: '$card should be invalid',
        );
      }
    });
  });

  group('Postal Code Regex', () {
    test('should match valid postal codes', () {
      final validPostalCodes = [
        '12345',
        '12345-6789',
        'A1A 1A1',
        'A1A1A1',
        'SW1A 1AA',
        'M1 1AA',
        'B33 8TH',
        'CR2 6XH',
        'DN55 1PT',
      ];

      for (final postalCode in validPostalCodes) {
        expect(
          RegExp(kPostalCodeRegex).hasMatch(postalCode),
          isTrue,
          reason: '$postalCode should be valid',
        );
      }
    });

    test('should not match invalid postal codes', () {
      final invalidPostalCodes = [
        '',
        'invalid',
        '1234',
        '1234567',
        '12345678',
        '123456789',
        '1234567890',
        '12345678901',
        '123456789012',
        '1234567890123',
        '12345678901234',
        '123456789012345',
        '1234567890123456',
        '12345678901234567',
        '123456789012345678',
        '1234567890123456789',
        '12345678901234567890',
        'abcdef',
        'abcdefg',
        'abcdefgh',
        'abcdefghi',
        'abcdefghij',
        'abcdefghijk',
        'abcdefghijkl',
        'abcdefghijklm',
        'abcdefghijklmn',
        'abcdefghijklmno',
        'abcdefghijklmnop',
        'abcdefghijklmnopq',
        'abcdefghijklmnopqr',
        'abcdefghijklmnopqrs',
        'abcdefghijklmnopqrst',
        'abcdefghijklmnopqrstu',
        'abcdefghijklmnopqrstuv',
        'abcdefghijklmnopqrstuvw',
        'abcdefghijklmnopqrstuvwx',
        'abcdefghijklmnopqrstuvwxy',
        'abcdefghijklmnopqrstuvwxyz',
      ];

      for (final postalCode in invalidPostalCodes) {
        expect(
          RegExp(kPostalCodeRegex).hasMatch(postalCode),
          isFalse,
          reason: '$postalCode should be invalid',
        );
      }
    });
  });

  group('ISO Date Regex', () {
    test('should match valid ISO date format', () {
      final validDates = [
        '2023-01-01',
        '2023-12-31',
        '2023-02-28',
        '2024-02-29',
        '2023-03-31',
        '2023-04-30',
        '2023-05-31',
        '2023-06-30',
        '2023-07-31',
        '2023-08-31',
        '2023-09-30',
        '2023-10-31',
        '2023-11-30',
        '2023-12-31',
        '2000-01-01',
        '2000-12-31',
        '2000-02-29',
        '2000-03-31',
        '2000-04-30',
        '2000-05-31',
        '2000-06-30',
        '2000-07-31',
        '2000-08-31',
        '2000-09-30',
        '2000-10-31',
        '2000-11-30',
        '2000-12-31',
        '2100-01-01',
        '2100-12-31',
        '2100-02-28',
        '2100-03-31',
        '2100-04-30',
        '2100-05-31',
        '2100-06-30',
        '2100-07-31',
        '2100-08-31',
        '2100-09-30',
        '2100-10-31',
        '2100-11-30',
        '2100-12-31',
        // These are valid format but invalid dates (regex only checks format)
        '2023-13-01',
        '2023-00-01',
        '2023-01-00',
        '2023-01-32',
        '2023-02-30',
        '2023-04-31',
        '2023-06-31',
        '2023-09-31',
        '2023-11-31',
        '2023-02-29', // Not leap year
        '2023-02-30',
        '2023-02-31',
        '2023-03-32',
        '2023-04-32',
        '2023-05-32',
        '2023-06-32',
        '2023-07-32',
        '2023-08-32',
        '2023-09-32',
        '2023-10-32',
        '2023-11-32',
        '2023-12-32',
      ];

      for (final date in validDates) {
        expect(
          RegExp(kIsoDateRegex).hasMatch(date),
          isTrue,
          reason: '$date should be valid format',
        );
      }
    });

    test('should not match invalid ISO date format', () {
      final invalidDates = [
        '',
        'invalid',
        '2023',
        '2023-01',
        '2023-01-01T00:00:00Z',
        '2023-01-01 00:00:00',
        '01/01/2023',
        '01-01-2023',
        '2023/01/01',
        '2023.01.01',
        '2023_01_01',
        '2023 01 01',
        '2023-01-01.',
        '2023-01-01-',
        '2023-01-01_',
        '2023-01-01 ',
        '.2023-01-01',
        '-2023-01-01',
        '_2023-01-01',
        ' 2023-01-01',
      ];

      for (final date in invalidDates) {
        expect(
          RegExp(kIsoDateRegex).hasMatch(date),
          isFalse,
          reason: '$date should be invalid format',
        );
      }
    });
  });

  group('Time 24-Hour Regex', () {
    test('should match valid 24-hour times', () {
      final validTimes = [
        '00:00',
        '00:01',
        '00:30',
        '00:59',
        '01:00',
        '01:01',
        '01:30',
        '01:59',
        '12:00',
        '12:01',
        '12:30',
        '12:59',
        '13:00',
        '13:01',
        '13:30',
        '13:59',
        '23:00',
        '23:01',
        '23:30',
        '23:59',
      ];

      for (final time in validTimes) {
        expect(
          RegExp(kTime24HourRegex).hasMatch(time),
          isTrue,
          reason: '$time should be valid',
        );
      }
    });

    test('should not match invalid 24-hour times', () {
      final invalidTimes = [
        '',
        'invalid',
        '00:60',
        '00:99',
        '24:00',
        '24:01',
        '25:00',
        '99:00',
        '99:99',
        '00:00:00',
        '00:00.000',
        '00:00,000',
        '00:00 000',
        '00:00-000',
        '00:00_000',
        '00:00.',
        '00:00,',
        '00:00 ',
        '00:00-',
        '00:00_',
        '.00:00',
        ',00:00',
        ' 00:00',
        '-00:00',
        '_00:00',
        '00:00:',
        '00:00.',
        '00:00,',
        '00:00 ',
        '00:00-',
        '00:00_',
        ':00:00',
        '.00:00',
        ',00:00',
        ' 00:00',
        '-00:00',
        '_00:00',
      ];

      for (final time in invalidTimes) {
        expect(
          RegExp(kTime24HourRegex).hasMatch(time),
          isFalse,
          reason: '$time should be invalid',
        );
      }
    });
  });

  group('Alphanumeric Regex', () {
    test('should match valid alphanumeric strings', () {
      final validAlphanumeric = [
        'abc123',
        '123abc',
        'abc',
        '123',
        'a1b2c3',
        '1a2b3c',
        'abcdefghijklmnopqrstuvwxyz',
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        '0123456789',
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
        'a',
        'A',
        '0',
        '1',
        '9',
        'z',
        'Z',
      ];

      for (final alphanumeric in validAlphanumeric) {
        expect(
          RegExp(kAlphanumericRegex).hasMatch(alphanumeric),
          isTrue,
          reason: '$alphanumeric should be valid',
        );
      }
    });

    test('should not match invalid alphanumeric strings', () {
      final invalidAlphanumeric = [
        '',
        'abc-123',
        'abc_123',
        'abc 123',
        'abc.123',
        'abc,123',
        'abc!123',
        'abc@123',
        'abc#123',
        'abc\$123',
        'abc%123',
        'abc^123',
        'abc&123',
        'abc*123',
        'abc(123',
        'abc)123',
        'abc+123',
        'abc=123',
        'abc[123',
        'abc]123',
        'abc{123',
        'abc}123',
        'abc|123',
        'abc\\123',
        'abc/123',
        'abc?123',
        'abc<123',
        'abc>123',
        'abc~123',
        'abc`123',
        'abc\'123',
        'abc"123',
        'abc;123',
        'abc:123',
        'abc"123',
        'abc\'123',
        'abc`123',
        'abc~123',
        'abc>123',
        'abc<123',
        'abc?123',
        'abc/123',
        'abc\\123',
        'abc|123',
        'abc}123',
        'abc{123',
        'abc]123',
        'abc[123',
        'abc=123',
        'abc+123',
        'abc)123',
        'abc(123',
        'abc*123',
        'abc&123',
        'abc^123',
        'abc%123',
        'abc\$123',
        'abc#123',
        'abc@123',
        'abc!123',
        'abc,123',
        'abc.123',
        'abc 123',
        'abc_123',
        'abc-123',
      ];

      for (final alphanumeric in invalidAlphanumeric) {
        expect(
          RegExp(kAlphanumericRegex).hasMatch(alphanumeric),
          isFalse,
          reason: '$alphanumeric should be invalid',
        );
      }
    });
  });

  group('Letters Regex', () {
    test('should match valid letter strings', () {
      final validLetters = [
        'abc',
        'ABC',
        'abcdefghijklmnopqrstuvwxyz',
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'a',
        'A',
        'z',
        'Z',
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
      ];

      for (final letters in validLetters) {
        expect(
          RegExp(kLettersOnlyRegex).hasMatch(letters),
          isTrue,
          reason: '$letters should be valid',
        );
      }
    });

    test('should not match invalid letter strings', () {
      final invalidLetters = [
        '',
        'abc123',
        '123abc',
        'a1b2c3',
        '1a2b3c',
        '0123456789',
        'abc-123',
        'abc_123',
        'abc 123',
        'abc.123',
        'abc,123',
        'abc!123',
        'abc@123',
        'abc#123',
        'abc\$123',
        'abc%123',
        'abc^123',
        'abc&123',
        'abc*123',
        'abc(123',
        'abc)123',
        'abc+123',
        'abc=123',
        'abc[123',
        'abc]123',
        'abc{123',
        'abc}123',
        'abc|123',
        'abc\\123',
        'abc/123',
        'abc?123',
        'abc<123',
        'abc>123',
        'abc~123',
        'abc`123',
        'abc\'123',
        'abc"123',
        'abc;123',
        'abc:123',
        'abc"123',
        'abc\'123',
        'abc`123',
        'abc~123',
        'abc>123',
        'abc<123',
        'abc?123',
        'abc/123',
        'abc\\123',
        'abc|123',
        'abc}123',
        'abc{123',
        'abc]123',
        'abc[123',
        'abc=123',
        'abc+123',
        'abc)123',
        'abc(123',
        'abc*123',
        'abc&123',
        'abc^123',
        'abc%123',
        'abc\$123',
        'abc#123',
        'abc@123',
        'abc!123',
        'abc,123',
        'abc.123',
        'abc 123',
        'abc_123',
        'abc-123',
      ];

      for (final letters in invalidLetters) {
        expect(
          RegExp(kLettersOnlyRegex).hasMatch(letters),
          isFalse,
          reason: '$letters should be invalid',
        );
      }
    });
  });

  group('Digits Regex', () {
    test('should match valid digit strings', () {
      final validDigits = [
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '01',
        '12',
        '123',
        '1234',
        '12345',
        '123456',
        '1234567',
        '12345678',
        '123456789',
        '1234567890',
        '0123456789',
        '9876543210',
        '0000000000',
        '1111111111',
        '2222222222',
        '3333333333',
        '4444444444',
        '5555555555',
        '6666666666',
        '7777777777',
        '8888888888',
        '9999999999',
      ];

      for (final digits in validDigits) {
        expect(
          RegExp(kDigitsOnlyRegex).hasMatch(digits),
          isTrue,
          reason: '$digits should be valid',
        );
      }
    });

    test('should not match invalid digit strings', () {
      final invalidDigits = [
        '',
        'abc',
        'ABC',
        'abcdefghijklmnopqrstuvwxyz',
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'abc123',
        '123abc',
        'a1b2c3',
        '1a2b3c',
        'abc-123',
        'abc_123',
        'abc 123',
        'abc.123',
        'abc,123',
        'abc!123',
        'abc@123',
        'abc#123',
        'abc\$123',
        'abc%123',
        'abc^123',
        'abc&123',
        'abc*123',
        'abc(123',
        'abc)123',
        'abc+123',
        'abc=123',
        'abc[123',
        'abc]123',
        'abc{123',
        'abc}123',
        'abc|123',
        'abc\\123',
        'abc/123',
        'abc?123',
        'abc<123',
        'abc>123',
        'abc~123',
        'abc`123',
        'abc\'123',
        'abc"123',
        'abc;123',
        'abc:123',
        'abc"123',
        'abc\'123',
        'abc`123',
        'abc~123',
        'abc>123',
        'abc<123',
        'abc?123',
        'abc/123',
        'abc\\123',
        'abc|123',
        'abc}123',
        'abc{123',
        'abc]123',
        'abc[123',
        'abc=123',
        'abc+123',
        'abc)123',
        'abc(123',
        'abc*123',
        'abc&123',
        'abc^123',
        'abc%123',
        'abc\$123',
        'abc#123',
        'abc@123',
        'abc!123',
        'abc,123',
        'abc.123',
        'abc 123',
        'abc_123',
        'abc-123',
      ];

      for (final digits in invalidDigits) {
        expect(
          RegExp(kDigitsOnlyRegex).hasMatch(digits),
          isFalse,
          reason: '$digits should be invalid',
        );
      }
    });
  });
}
