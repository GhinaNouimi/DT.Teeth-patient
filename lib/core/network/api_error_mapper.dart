import 'api_error_messages.dart';

class ApiErrorMapper {
  const ApiErrorMapper._();

  static String validation({
    required String field,
    required String message,
    required String languageCode,
  }) {
    final normalizedField = field.toLowerCase();
    final lowerMessage = message.toLowerCase();

    if (normalizedField == 'email') {
      if (lowerMessage.contains('already') || lowerMessage.contains('taken')) {
        return ApiErrorMessages.text(
          languageCode,
          ar: 'هذا البريد الإلكتروني مستخدم مسبقاً.',
          en: 'This email address is already in use.',
        );
      }

      return ApiErrorMessages.text(
        languageCode,
        ar: 'يرجى إدخال بريد إلكتروني صحيح.',
        en: 'Please enter a valid email address.',
      );
    }

    if (normalizedField.contains('phone')) {
      if (lowerMessage.contains('already') || lowerMessage.contains('taken')) {
        return ApiErrorMessages.text(
          languageCode,
          ar: 'رقم الهاتف مستخدم مسبقاً.',
          en: 'This phone number is already in use.',
        );
      }

      return ApiErrorMessages.text(
        languageCode,
        ar: 'يرجى إدخال رقم هاتف صحيح.',
        en: 'Please enter a valid phone number.',
      );
    }

    if (normalizedField == 'password') {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'كلمة المرور غير مطابقة للشروط المطلوبة.',
        en: 'The password does not meet the required conditions.',
      );
    }

    if (normalizedField == 'password_confirmation') {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'تأكيد كلمة المرور غير مطابق.',
        en: 'Password confirmation does not match.',
      );
    }

    if (normalizedField == 'date_of_birth') {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'يرجى إدخال تاريخ ميلاد صحيح.',
        en: 'Please enter a valid date of birth.',
      );
    }

    if (normalizedField == 'name') {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'يرجى إدخال الاسم بشكل صحيح.',
        en: 'Please enter a valid name.',
      );
    }

    if (normalizedField == 'address') {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'يرجى إدخال العنوان.',
        en: 'Please enter the address.',
      );
    }

    if (normalizedField == 'gender') {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'يرجى اختيار الجنس بشكل صحيح.',
        en: 'Please select a valid gender.',
      );
    }

    if (normalizedField == 'profile_picture') {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'يرجى اختيار صورة شخصية صالحة.',
        en: 'Please choose a valid profile picture.',
      );
    }

    if (normalizedField == 'is_pregnant' ||
        normalizedField == 'is_breastfeeding' ||
        normalizedField == 'is_smoker' ||
        normalizedField == 'drinks_alcohol_frequently') {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'يرجى اختيار قيمة صحيحة.',
        en: 'Please select a valid value.',
      );
    }

    if (normalizedField == 'teeth_cleaning_frequency') {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'يرجى اختيار عدد مرات تنظيف الأسنان بشكل صحيح.',
        en: 'Please select a valid teeth cleaning frequency.',
      );
    }

    if (lowerMessage.contains('required')) {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'يرجى تعبئة الحقول المطلوبة.',
        en: 'Please fill in the required fields.',
      );
    }

    if (lowerMessage.contains('image')) {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'يرجى اختيار ملف صورة صالح.',
        en: 'Please choose a valid image file.',
      );
    }

    if (lowerMessage.contains('greater') ||
        lowerMessage.contains('too large') ||
        lowerMessage.contains('max')) {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'حجم الملف أو طول النص أكبر من المسموح.',
        en: 'The file size or text length exceeds the allowed limit.',
      );
    }

    return ApiErrorMessages.text(
      languageCode,
      ar: 'يرجى التأكد من صحة البيانات المدخلة.',
      en: 'Please make sure the entered data is correct.',
    );
  }

  static String common({
    required String message,
    required String languageCode,
  }) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('invalid credentials')) {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
        en: 'Email or password is incorrect.',
      );
    }

    if (lowerMessage.contains('unauthenticated')) {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'انتهت الجلسة. يرجى تسجيل الدخول مجدداً.',
        en: 'Your session has expired. Please log in again.',
      );
    }

    if (lowerMessage.contains('not found')) {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'العنصر المطلوب غير موجود.',
        en: 'The requested item was not found.',
      );
    }

    if (lowerMessage.contains('patient registered successfully')) {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'تم إنشاء الحساب بنجاح.',
        en: 'Account created successfully.',
      );
    }

    if (lowerMessage.contains('invalid or expired verification code')) {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'رمز التحقق غير صحيح أو منتهي الصلاحية.',
        en: 'The verification code is invalid or expired.',
      );
    }

    if (lowerMessage.contains('password reset successfully')) {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'تمت إعادة تعيين كلمة المرور بنجاح.',
        en: 'Password has been reset successfully.',
      );
    }

    if (lowerMessage.contains('code sent') ||
        lowerMessage.contains('verification code sent')) {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'تم إرسال رمز التحقق إلى بريدك الإلكتروني.',
        en: 'A verification code has been sent to your email.',
      );
    }

    if (lowerMessage.contains('profile') && lowerMessage.contains('updated')) {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'تم تحديث البروفايل بنجاح.',
        en: 'Profile updated successfully.',
      );
    }
    if (message.contains('يمكنك تقييم الطبيب فقط بعد إتمام موعد معه')) {
      return ApiErrorMessages.text(
        languageCode,
        ar: 'يمكنك تقييم طبيب الأسنان فقط بعد إتمام موعد معه.',
        en: 'You can rate the dentist only after completing an appointment with them.',
      );
    }

    return ApiErrorMessages.text(
      languageCode,
      ar: 'تعذر إكمال العملية. يرجى المحاولة مرة أخرى.',
      en: 'Could not complete the request. Please try again.',
    );
  }
}