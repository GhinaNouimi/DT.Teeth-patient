enum PasswordStrengthLevel {
  weak,
  medium,
  strong,
}

abstract final class AppValidators {
  static String? requiredField(
      String? value, {
        String? message,
      }) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'هذا الحقل مطلوب';
    }

    return null;
  }

  static String? email(
      String? value, {
        String? requiredMessage,
        String? invalidMessage,
      }) {
    if (value == null || value.trim().isEmpty) {
      return requiredMessage ?? 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return invalidMessage ?? 'Invalid email address';
    }

    return null;
  }

  static String? phone(
      String? value, {
        String? requiredMessage,
        String? invalidMessage,
      }) {
    if (value == null || value.trim().isEmpty) {
      return requiredMessage ?? 'Phone number is required';
    }

    final cleaned = value.replaceAll(' ', '');

    if (cleaned.length < 9 || cleaned.length > 15) {
      return invalidMessage ?? 'Invalid phone number';
    }

    return null;
  }

  static String? strongPassword(
      String? value, {
        String? requiredMessage,
        String? minLengthMessage,
        String? uppercaseMessage,
        String? lowercaseMessage,
        String? numberMessage,
        String? specialCharacterMessage,
      }) {
    if (value == null || value.isEmpty) {
      return requiredMessage ?? 'Password is required';
    }

    if (value.length < 8) {
      return minLengthMessage ?? 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return uppercaseMessage ?? 'Password must contain an uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return lowercaseMessage ?? 'Password must contain a lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return numberMessage ?? 'Password must contain a number';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return specialCharacterMessage ??
          'Password must contain a special character';
    }

    return null;
  }

  static double passwordStrength(String value) {
    double score = 0;

    if (value.length >= 8) score += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(value)) score += 0.20;
    if (RegExp(r'[a-z]').hasMatch(value)) score += 0.20;
    if (RegExp(r'[0-9]').hasMatch(value)) score += 0.15;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) score += 0.20;

    return score.clamp(0, 1);
  }

  static PasswordStrengthLevel passwordStrengthLevel(String value) {
    final strength = passwordStrength(value);

    if (strength < 0.4) return PasswordStrengthLevel.weak;
    if (strength < 0.75) return PasswordStrengthLevel.medium;

    return PasswordStrengthLevel.strong;
  }
}