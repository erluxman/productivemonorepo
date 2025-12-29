import 'package:flutter_test/flutter_test.dart';
import 'package:productive_flutter/utils/extensions/string_extensions.dart';

void main() {
  group('StringExtension', () {
    group('isValidEmail', () {
      test('should return true for valid email addresses', () {
        expect('test@example.com'.isValidEmail(), true);
        expect('user.name@example.co.uk'.isValidEmail(), true);
        expect('user+tag@example.com'.isValidEmail(), true);
        expect('user123@example123.com'.isValidEmail(), true);
      });

      test('should return false for invalid email addresses', () {
        expect('invalid'.isValidEmail(), false);
        expect('invalid@'.isValidEmail(), false);
        expect('@example.com'.isValidEmail(), false);
        expect('invalid@example'.isValidEmail(), false);
        expect('invalid.example.com'.isValidEmail(), false);
        expect(''.isValidEmail(), false);
      });
    });

    group('isValidUsername', () {
      test('should return true for valid usernames', () {
        expect('username'.isValidUsername(), true);
        expect('user123'.isValidUsername(), true);
        expect('user_name'.isValidUsername(), true);
        expect('User123'.isValidUsername(), true);
        expect('user_name_123'.isValidUsername(), true);
      });

      test('should return false for invalid usernames', () {
        expect('use'.isValidUsername(), false); // Too short
        expect('user-name'.isValidUsername(), false); // Contains hyphen
        expect('user name'.isValidUsername(), false); // Contains space
        expect('user@name'.isValidUsername(), false); // Contains special char
        expect(''.isValidUsername(), false); // Empty
        expect('123'.isValidUsername(), false); // Too short
      });

      test('should require minimum 4 characters', () {
        expect('abc'.isValidUsername(), false);
        expect('abcd'.isValidUsername(), true);
      });
    });
  });
}

