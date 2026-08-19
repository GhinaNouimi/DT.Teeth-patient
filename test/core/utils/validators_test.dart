import 'package:dt_teeth/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppValidators.requiredField', () {
    test('returns an error for null, empty, and whitespace-only values', () {
      expect(AppValidators.requiredField(null), isNotNull);
      expect(AppValidators.requiredField(''), isNotNull);
      expect(AppValidators.requiredField('   '), isNotNull);
    });

    test('returns null for a non-empty value', () {
      expect(AppValidators.requiredField('value'), isNull);
    });

    test('uses the provided localized message', () {
      expect(AppValidators.requiredField('', message: 'Required'), 'Required');
    });
  });

  group('AppValidators.email', () {
    test('rejects missing and malformed email addresses', () {
      expect(AppValidators.email(null), isNotNull);
      expect(AppValidators.email('not-an-email'), isNotNull);
      expect(AppValidators.email('user@domain'), isNotNull);
    });

    test('accepts a valid email and trims surrounding whitespace', () {
      expect(AppValidators.email(' patient@example.com '), isNull);
    });
  });

  group('AppValidators.phone', () {
    test('rejects numbers shorter than 9 or longer than 15 characters', () {
      expect(AppValidators.phone('12345678'), isNotNull);
      expect(AppValidators.phone('1234567890123456'), isNotNull);
    });

    test('accepts a valid number and ignores spaces', () {
      expect(AppValidators.phone('0951 000 001'), isNull);
    });
  });

  group('AppValidators.strongPassword', () {
    test('reports each missing password requirement', () {
      expect(AppValidators.strongPassword(null), contains('required'));
      expect(AppValidators.strongPassword('Aa1!'), contains('8'));
      expect(
        AppValidators.strongPassword('lowercase1!'),
        contains('uppercase'),
      );
      expect(
        AppValidators.strongPassword('UPPERCASE1!'),
        contains('lowercase'),
      );
      expect(AppValidators.strongPassword('NoNumber!'), contains('number'));
      expect(AppValidators.strongPassword('NoSpecial1'), contains('special'));
    });

    test('accepts a password satisfying all requirements', () {
      expect(AppValidators.strongPassword('Strong1!'), isNull);
    });
  });

  group('password strength', () {
    test('score stays between zero and one', () {
      expect(AppValidators.passwordStrength(''), 0);
      expect(AppValidators.passwordStrength('Strong1!'), 1);
    });

    test('maps representative passwords to the expected levels', () {
      expect(
        AppValidators.passwordStrengthLevel('a'),
        PasswordStrengthLevel.weak,
      );
      expect(
        AppValidators.passwordStrengthLevel('abcdefgh'),
        PasswordStrengthLevel.medium,
      );
      expect(
        AppValidators.passwordStrengthLevel('Strong1!'),
        PasswordStrengthLevel.strong,
      );
    });
  });
}
