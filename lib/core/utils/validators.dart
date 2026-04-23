abstract final class AppValidators {
  static String? requiredField(String? value, {String fieldName = 'هذا الحقل'}) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال $fieldName';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال البريد الإلكتروني';
    }

    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'البريد الإلكتروني غير صالح';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال رقم الهاتف';
    }

    final cleaned = value.replaceAll(' ', '');
    if (cleaned.length < 9 || cleaned.length > 15) {
      return 'رقم الهاتف غير صالح';
    }
    return null;
  }

  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    }
    if (value.length < 8) {
      return 'يجب أن تكون 8 أحرف على الأقل';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'يجب أن تحتوي على حرف كبير';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'يجب أن تحتوي على حرف صغير';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'يجب أن تحتوي على رقم';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'يجب أن تحتوي على رمز خاص';
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

  static String passwordStrengthLabel(String value) {
    final strength = passwordStrength(value);
    if (strength < 0.4) return 'ضعيفة';
    if (strength < 0.75) return 'متوسطة';
    return 'قوية';
  }
}
