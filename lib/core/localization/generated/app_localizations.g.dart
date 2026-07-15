import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.g.dart';
import 'app_localizations_en.g.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of GeneratedAppLocalizations
/// returned by `GeneratedAppLocalizations.of(context)`.
///
/// Applications need to include `GeneratedAppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.g.dart';
///
/// return MaterialApp(
///   localizationsDelegates: GeneratedAppLocalizations.localizationsDelegates,
///   supportedLocales: GeneratedAppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the GeneratedAppLocalizations.supportedLocales
/// property.
abstract class GeneratedAppLocalizations {
  GeneratedAppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static GeneratedAppLocalizations of(BuildContext context) {
    return Localizations.of<GeneratedAppLocalizations>(
      context,
      GeneratedAppLocalizations,
    )!;
  }

  static const LocalizationsDelegate<GeneratedAppLocalizations> delegate =
      _GeneratedAppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @bottomNavHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get bottomNavHome;

  /// No description provided for @bottomNavDoctors.
  ///
  /// In ar, this message translates to:
  /// **'الأطباء'**
  String get bottomNavDoctors;

  /// No description provided for @bottomNavAppointments.
  ///
  /// In ar, this message translates to:
  /// **'مواعيدي'**
  String get bottomNavAppointments;

  /// No description provided for @bottomNavMedicalRecord.
  ///
  /// In ar, this message translates to:
  /// **'ملفي الطبي'**
  String get bottomNavMedicalRecord;

  /// No description provided for @bottomNavAccount.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get bottomNavAccount;

  /// No description provided for @splashTagline.
  ///
  /// In ar, this message translates to:
  /// **'رعاية أسنان حديثة تبدأ بتجربة رقمية أنيقة'**
  String get splashTagline;

  /// No description provided for @selectLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اختيار اللغة'**
  String get selectLanguage;

  /// No description provided for @arabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @ok.
  ///
  /// In ar, this message translates to:
  /// **'حسنًا'**
  String get ok;

  /// No description provided for @back.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get back;

  /// No description provided for @returnText.
  ///
  /// In ar, this message translates to:
  /// **'العودة'**
  String get returnText;

  /// No description provided for @continueText.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get continueText;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @createAccount.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء الحساب'**
  String get createAccount;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In ar, this message translates to:
  /// **'name@example.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get confirmPassword;

  /// No description provided for @phoneNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phoneNumber;

  /// No description provided for @fullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسمك الكامل'**
  String get fullNameHint;

  /// No description provided for @address.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get address;

  /// No description provided for @addressHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل عنوانك'**
  String get addressHint;

  /// No description provided for @profilePicture.
  ///
  /// In ar, this message translates to:
  /// **'الصورة الشخصية'**
  String get profilePicture;

  /// No description provided for @addProfilePictureOptional.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صورة شخصية اختياري'**
  String get addProfilePictureOptional;

  /// No description provided for @viewProfilePicture.
  ///
  /// In ar, this message translates to:
  /// **'عرض الصورة الشخصية'**
  String get viewProfilePicture;

  /// No description provided for @nameRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال الاسم الكامل'**
  String get nameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال البريد الإلكتروني'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني غير صالح'**
  String get emailInvalid;

  /// No description provided for @phoneRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال رقم الهاتف'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف غير صالح'**
  String get phoneInvalid;

  /// No description provided for @addressRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال العنوان'**
  String get addressRequired;

  /// No description provided for @birthDateRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار تاريخ الميلاد'**
  String get birthDateRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال كلمة المرور'**
  String get passwordRequired;

  /// No description provided for @passwordConfirmationRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء تأكيد كلمة المرور'**
  String get passwordConfirmationRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور غير متطابقة'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordMinLength.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن تكون كلمة المرور 8 أحرف على الأقل'**
  String get passwordMinLength;

  /// No description provided for @passwordUppercase.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن تحتوي كلمة المرور على حرف كبير'**
  String get passwordUppercase;

  /// No description provided for @passwordLowercase.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن تحتوي كلمة المرور على حرف صغير'**
  String get passwordLowercase;

  /// No description provided for @passwordNumber.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن تحتوي كلمة المرور على رقم'**
  String get passwordNumber;

  /// No description provided for @passwordSpecial.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن تحتوي كلمة المرور على رمز خاص'**
  String get passwordSpecial;

  /// No description provided for @passwordRules.
  ///
  /// In ar, this message translates to:
  /// **'شروط كلمة المرور'**
  String get passwordRules;

  /// No description provided for @passwordStrengthStart.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ بكتابة كلمة المرور'**
  String get passwordStrengthStart;

  /// No description provided for @passwordStrengthTitle.
  ///
  /// In ar, this message translates to:
  /// **'قوة كلمة المرور: {label}'**
  String passwordStrengthTitle(Object label);

  /// No description provided for @passwordRuleMinLength.
  ///
  /// In ar, this message translates to:
  /// **'8 أحرف على الأقل'**
  String get passwordRuleMinLength;

  /// No description provided for @passwordRuleUpperLower.
  ///
  /// In ar, this message translates to:
  /// **'حرف كبير وحرف صغير'**
  String get passwordRuleUpperLower;

  /// No description provided for @passwordRuleNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم واحد على الأقل'**
  String get passwordRuleNumber;

  /// No description provided for @passwordRuleSpecial.
  ///
  /// In ar, this message translates to:
  /// **'رمز خاص مثل ! @ # \$ %'**
  String get passwordRuleSpecial;

  /// No description provided for @passwordWeak.
  ///
  /// In ar, this message translates to:
  /// **'ضعيفة'**
  String get passwordWeak;

  /// No description provided for @passwordMedium.
  ///
  /// In ar, this message translates to:
  /// **'متوسطة'**
  String get passwordMedium;

  /// No description provided for @passwordStrong.
  ///
  /// In ar, this message translates to:
  /// **'قوية'**
  String get passwordStrong;

  /// No description provided for @signupTitle.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get signupTitle;

  /// No description provided for @signupSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ حسابك للوصول إلى مواعيدك وخدمات المركز'**
  String get signupSubtitle;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'لديك حساب بالفعل؟'**
  String get alreadyHaveAccount;

  /// No description provided for @birthDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الميلاد'**
  String get birthDate;

  /// No description provided for @birthDateHint.
  ///
  /// In ar, this message translates to:
  /// **'اختر تاريخ الميلاد'**
  String get birthDateHint;

  /// No description provided for @gender.
  ///
  /// In ar, this message translates to:
  /// **'الجنس'**
  String get gender;

  /// No description provided for @genderRequired.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار الجنس'**
  String get genderRequired;

  /// No description provided for @male.
  ///
  /// In ar, this message translates to:
  /// **'ذكر'**
  String get male;

  /// No description provided for @female.
  ///
  /// In ar, this message translates to:
  /// **'أنثى'**
  String get female;

  /// No description provided for @completePatientData.
  ///
  /// In ar, this message translates to:
  /// **'إكمال بيانات المريض'**
  String get completePatientData;

  /// No description provided for @patientHealthSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'هذه المعلومات تساعد المركز في التعامل مع الحالات الطارئة بشكل آمن'**
  String get patientHealthSubtitle;

  /// No description provided for @emergencyContactName.
  ///
  /// In ar, this message translates to:
  /// **'اسم شخص للطوارئ'**
  String get emergencyContactName;

  /// No description provided for @emergencyContactNameHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: محمد أحمد'**
  String get emergencyContactNameHint;

  /// No description provided for @emergencyContactRelation.
  ///
  /// In ar, this message translates to:
  /// **'صلة القرابة'**
  String get emergencyContactRelation;

  /// No description provided for @emergencyContactRelationHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: أخ، أب، أم'**
  String get emergencyContactRelationHint;

  /// No description provided for @emergencyPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتف الطوارئ'**
  String get emergencyPhone;

  /// No description provided for @doYouSmoke.
  ///
  /// In ar, this message translates to:
  /// **'هل تدخن؟'**
  String get doYouSmoke;

  /// No description provided for @smokingSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'يساعد الطبيب في تقييم صحة الفم والأسنان'**
  String get smokingSubtitle;

  /// No description provided for @drinkAlcohol.
  ///
  /// In ar, this message translates to:
  /// **'هل تشرب الكحول بشكل متكرر؟'**
  String get drinkAlcohol;

  /// No description provided for @alcoholSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'هذه المعلومة تبقى ضمن بياناتك الطبية'**
  String get alcoholSubtitle;

  /// No description provided for @isPregnant.
  ///
  /// In ar, this message translates to:
  /// **'هل أنتِ حامل؟'**
  String get isPregnant;

  /// No description provided for @pregnantSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'مهم قبل الأشعة أو بعض الأدوية'**
  String get pregnantSubtitle;

  /// No description provided for @isBreastfeeding.
  ///
  /// In ar, this message translates to:
  /// **'هل أنتِ مرضعة؟'**
  String get isBreastfeeding;

  /// No description provided for @breastfeedingSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'مهم قبل وصف بعض الأدوية'**
  String get breastfeedingSubtitle;

  /// No description provided for @yes.
  ///
  /// In ar, this message translates to:
  /// **'نعم'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In ar, this message translates to:
  /// **'لا'**
  String get no;

  /// No description provided for @teethCleaningFrequency.
  ///
  /// In ar, this message translates to:
  /// **'عدد مرات تنظيف الأسنان'**
  String get teethCleaningFrequency;

  /// No description provided for @teethCleaningOnce.
  ///
  /// In ar, this message translates to:
  /// **'مرة يومياً'**
  String get teethCleaningOnce;

  /// No description provided for @teethCleaningTwice.
  ///
  /// In ar, this message translates to:
  /// **'مرتين يومياً'**
  String get teethCleaningTwice;

  /// No description provided for @teethCleaningRarely.
  ///
  /// In ar, this message translates to:
  /// **'نادراً'**
  String get teethCleaningRarely;

  /// No description provided for @emergencyContactNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال اسم شخص للطوارئ'**
  String get emergencyContactNameRequired;

  /// No description provided for @emergencyContactRelationRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال صلة القرابة'**
  String get emergencyContactRelationRequired;

  /// No description provided for @loginTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بياناتك للوصول إلى حسابك بسهولة وأمان'**
  String get loginSubtitle;

  /// No description provided for @doNotHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟'**
  String get doNotHaveAccount;

  /// No description provided for @forgotPasswordQuestion.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forgotPasswordQuestion;

  /// No description provided for @loginButton.
  ///
  /// In ar, this message translates to:
  /// **'دخول'**
  String get loginButton;

  /// No description provided for @loggingIn.
  ///
  /// In ar, this message translates to:
  /// **'جاري تسجيل الدخول...'**
  String get loggingIn;

  /// No description provided for @loginSuccessTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الدخول'**
  String get loginSuccessTitle;

  /// No description provided for @loginSuccessMessage.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل دخولك بنجاح. يمكنك الآن متابعة استخدام التطبيق.'**
  String get loginSuccessMessage;

  /// No description provided for @loginFailedTitle.
  ///
  /// In ar, this message translates to:
  /// **'فشل تسجيل الدخول'**
  String get loginFailedTitle;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بريدك الإلكتروني لإرسال رمز التحقق'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendCode.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الرمز'**
  String get sendCode;

  /// No description provided for @sendingCode.
  ///
  /// In ar, this message translates to:
  /// **'جاري إرسال الرمز...'**
  String get sendingCode;

  /// No description provided for @codeSentTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال الرمز'**
  String get codeSentTitle;

  /// No description provided for @codeSentMessage.
  ///
  /// In ar, this message translates to:
  /// **'أرسلنا رمز التحقق إلى بريدك الإلكتروني.\nصلاحية الرمز دقيقتان.'**
  String get codeSentMessage;

  /// No description provided for @newCodeSentMessage.
  ///
  /// In ar, this message translates to:
  /// **'أرسلنا رمز تحقق جديد إلى بريدك الإلكتروني.\nصلاحية الرمز دقيقتان.'**
  String get newCodeSentMessage;

  /// No description provided for @enterCode.
  ///
  /// In ar, this message translates to:
  /// **'إدخال الرمز'**
  String get enterCode;

  /// No description provided for @backToLogin.
  ///
  /// In ar, this message translates to:
  /// **'العودة لتسجيل الدخول'**
  String get backToLogin;

  /// No description provided for @sendCodeFailedTitle.
  ///
  /// In ar, this message translates to:
  /// **'فشل إرسال الرمز'**
  String get sendCodeFailedTitle;

  /// No description provided for @verifyCodeTitle.
  ///
  /// In ar, this message translates to:
  /// **'التحقق من الرمز'**
  String get verifyCodeTitle;

  /// No description provided for @verifyCodeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الرمز المرسل إلى {email}'**
  String verifyCodeSubtitle(Object email);

  /// No description provided for @incompleteCodeTitle.
  ///
  /// In ar, this message translates to:
  /// **'رمز غير مكتمل'**
  String get incompleteCodeTitle;

  /// No description provided for @incompleteCodeMessage.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال رمز تحقق مكون من 6 أرقام.'**
  String get incompleteCodeMessage;

  /// No description provided for @codeVerifiedTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم التحقق من الرمز'**
  String get codeVerifiedTitle;

  /// No description provided for @codeVerifiedMessage.
  ///
  /// In ar, this message translates to:
  /// **'تم التحقق من الرمز بنجاح. يمكنك الآن إعادة تعيين كلمة المرور.'**
  String get codeVerifiedMessage;

  /// No description provided for @verifyCodeButton.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الرمز'**
  String get verifyCodeButton;

  /// No description provided for @verifying.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحقق...'**
  String get verifying;

  /// No description provided for @resendCode.
  ///
  /// In ar, this message translates to:
  /// **'إعادة إرسال الرمز'**
  String get resendCode;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين كلمة المرور'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل كلمة مرور جديدة لحساب {email}'**
  String resetPasswordSubtitle(Object email);

  /// No description provided for @newPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور الجديدة'**
  String get newPassword;

  /// No description provided for @savePassword.
  ///
  /// In ar, this message translates to:
  /// **'حفظ كلمة المرور'**
  String get savePassword;

  /// No description provided for @saving.
  ///
  /// In ar, this message translates to:
  /// **'جاري الحفظ...'**
  String get saving;

  /// No description provided for @passwordUpdatedTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث كلمة المرور'**
  String get passwordUpdatedTitle;

  /// No description provided for @passwordUpdatedMessage.
  ///
  /// In ar, this message translates to:
  /// **'تمت إعادة تعيين كلمة المرور بنجاح. يمكنك الآن تسجيل الدخول بكلمة المرور الجديدة.'**
  String get passwordUpdatedMessage;

  /// No description provided for @passwordUpdateFailedTitle.
  ///
  /// In ar, this message translates to:
  /// **'فشل تحديث كلمة المرور'**
  String get passwordUpdateFailedTitle;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء تأكيد كلمة المرور'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsNotMatching.
  ///
  /// In ar, this message translates to:
  /// **'كلمتا المرور غير متطابقتين'**
  String get passwordsNotMatching;

  /// No description provided for @passwordConfirmHint.
  ///
  /// In ar, this message translates to:
  /// **'أعد إدخال كلمة المرور للتأكيد'**
  String get passwordConfirmHint;

  /// No description provided for @passwordsMatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمتا المرور متطابقتان'**
  String get passwordsMatch;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الحساب بنجاح'**
  String get accountCreatedSuccessfully;

  /// No description provided for @verificationCodeSent.
  ///
  /// In ar, this message translates to:
  /// **'أرسلنا رمز التحقق إلى بريدك الإلكتروني. يرجى إدخال الرمز لتفعيل حسابك.'**
  String get verificationCodeSent;

  /// No description provided for @goToVerification.
  ///
  /// In ar, this message translates to:
  /// **'الانتقال للتحقق'**
  String get goToVerification;

  /// No description provided for @accountCreationFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل إنشاء الحساب'**
  String get accountCreationFailed;

  /// No description provided for @creatingAccount.
  ///
  /// In ar, this message translates to:
  /// **'جاري إنشاء الحساب...'**
  String get creatingAccount;

  /// No description provided for @accountVerificationTitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الحساب'**
  String get accountVerificationTitle;

  /// No description provided for @accountVerificationSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رمز التحقق المرسل إلى {email}'**
  String accountVerificationSubtitle(Object email);

  /// No description provided for @accountVerifiedTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم تأكيد الحساب'**
  String get accountVerifiedTitle;

  /// No description provided for @accountVerifiedMessage.
  ///
  /// In ar, this message translates to:
  /// **'تم تأكيد حسابك بنجاح. يمكنك الآن استخدام التطبيق.'**
  String get accountVerifiedMessage;

  /// No description provided for @verificationFailedTitle.
  ///
  /// In ar, this message translates to:
  /// **'فشل التحقق'**
  String get verificationFailedTitle;

  /// No description provided for @newVerificationCodeSentMessage.
  ///
  /// In ar, this message translates to:
  /// **'أرسلنا رمز تحقق جديد إلى بريدك الإلكتروني. الرمز صالح لمدة دقيقتين.'**
  String get newVerificationCodeSentMessage;

  /// No description provided for @genericErrorTitle.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ'**
  String get genericErrorTitle;

  /// No description provided for @featuredOffers.
  ///
  /// In ar, this message translates to:
  /// **'عروض مميزة'**
  String get featuredOffers;

  /// No description provided for @specialOffer.
  ///
  /// In ar, this message translates to:
  /// **'عرض خاص'**
  String get specialOffer;

  /// No description provided for @viewDetails.
  ///
  /// In ar, this message translates to:
  /// **'عرض التفاصيل'**
  String get viewDetails;

  /// No description provided for @offerWhiteningTitle.
  ///
  /// In ar, this message translates to:
  /// **'خصم 20% على التبييض'**
  String get offerWhiteningTitle;

  /// No description provided for @offerWhiteningSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'لفترة محدودة هذا الأسبوع'**
  String get offerWhiteningSubtitle;

  /// No description provided for @offerCleaningTitle.
  ///
  /// In ar, this message translates to:
  /// **'عرض تنظيف الأسنان'**
  String get offerCleaningTitle;

  /// No description provided for @offerCleaningSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'احجز موعدك الآن واستفد من العرض'**
  String get offerCleaningSubtitle;

  /// No description provided for @offerCheckupTitle.
  ///
  /// In ar, this message translates to:
  /// **'خصم على جلسة الفحص'**
  String get offerCheckupTitle;

  /// No description provided for @offerCheckupSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اطمئن على صحة أسنانك بسهولة'**
  String get offerCheckupSubtitle;

  /// No description provided for @nextAppointment.
  ///
  /// In ar, this message translates to:
  /// **'موعدك القادم'**
  String get nextAppointment;

  /// No description provided for @welcomePatient.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك 👋'**
  String get welcomePatient;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'نهتم بابتسامتك دائماً'**
  String get welcomeSubtitle;

  /// No description provided for @bookAppointment.
  ///
  /// In ar, this message translates to:
  /// **'حجز موعد'**
  String get bookAppointment;

  /// No description provided for @quickActions.
  ///
  /// In ar, this message translates to:
  /// **'إجراءات سريعة'**
  String get quickActions;

  /// No description provided for @emergencyAppointment.
  ///
  /// In ar, this message translates to:
  /// **'موعد طارئ'**
  String get emergencyAppointment;

  /// No description provided for @contact.
  ///
  /// In ar, this message translates to:
  /// **'التواصل'**
  String get contact;

  /// No description provided for @smartAssistant.
  ///
  /// In ar, this message translates to:
  /// **'المساعد الذكي'**
  String get smartAssistant;

  /// No description provided for @appointmentTypeTitle.
  ///
  /// In ar, this message translates to:
  /// **'نوع الموعد'**
  String get appointmentTypeTitle;

  /// No description provided for @appointmentTypeEmergencyDescription.
  ///
  /// In ar, this message translates to:
  /// **'موعد طارئ - سيتم معالجته فوراً'**
  String get appointmentTypeEmergencyDescription;

  /// No description provided for @appointmentTypeRegularDescription.
  ///
  /// In ar, this message translates to:
  /// **'حجز موعد عادي'**
  String get appointmentTypeRegularDescription;

  /// No description provided for @appointmentTypeFollowUpDescription.
  ///
  /// In ar, this message translates to:
  /// **'موعد متابعة'**
  String get appointmentTypeFollowUpDescription;

  /// No description provided for @noUpcomingAppointments.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مواعيد قادمة'**
  String get noUpcomingAppointments;

  /// No description provided for @noPastAppointments.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مواعيد سابقة'**
  String get noPastAppointments;

  /// No description provided for @bookFirstAppointment.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ بحجز موعدك الأول الآن'**
  String get bookFirstAppointment;

  /// No description provided for @noPastAppointmentsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'لم تسجل مواعيد سابقة بعد'**
  String get noPastAppointmentsSubtitle;

  /// No description provided for @noDoctorsAvailable.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد أطباء متاحون لهذه الخدمة'**
  String get noDoctorsAvailable;

  /// No description provided for @selectDoctor.
  ///
  /// In ar, this message translates to:
  /// **'اختر الطبيب'**
  String get selectDoctor;

  /// No description provided for @selectServiceType.
  ///
  /// In ar, this message translates to:
  /// **'اختر نوع الخدمة'**
  String get selectServiceType;

  /// No description provided for @emergency.
  ///
  /// In ar, this message translates to:
  /// **'طارئ'**
  String get emergency;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @logoutSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'سيتم إنهاء الجلسة الحالية والعودة إلى شاشة الدخول.'**
  String get logoutSubtitle;

  /// No description provided for @logoutConfirmationTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logoutConfirmationTitle;

  /// No description provided for @logoutConfirmationMessage.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد أنك تريد تسجيل الخروج من حسابك؟'**
  String get logoutConfirmationMessage;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @logoutButton.
  ///
  /// In ar, this message translates to:
  /// **'خروج'**
  String get logoutButton;

  /// No description provided for @logoutSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الخروج بنجاح.'**
  String get logoutSuccess;

  /// No description provided for @logoutFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل تسجيل الخروج'**
  String get logoutFailed;

  /// No description provided for @profile.
  ///
  /// In ar, this message translates to:
  /// **'البروفايل'**
  String get profile;

  /// No description provided for @patientProfile.
  ///
  /// In ar, this message translates to:
  /// **'ملف المريض'**
  String get patientProfile;

  /// No description provided for @editProfile.
  ///
  /// In ar, this message translates to:
  /// **'تعديل البروفايل'**
  String get editProfile;

  /// No description provided for @profileLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل بيانات البروفايل...'**
  String get profileLoading;

  /// No description provided for @profileLoadFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل تحميل البروفايل'**
  String get profileLoadFailed;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث البروفايل بنجاح.'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل تحديث البروفايل'**
  String get profileUpdateFailed;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @profileBasicInfo.
  ///
  /// In ar, this message translates to:
  /// **'البيانات الأساسية'**
  String get profileBasicInfo;

  /// No description provided for @profileEmergencyContact.
  ///
  /// In ar, this message translates to:
  /// **'جهة الاتصال للطوارئ'**
  String get profileEmergencyContact;

  /// No description provided for @profileAdditionalInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات إضافية'**
  String get profileAdditionalInfo;

  /// No description provided for @profileAccountSupport.
  ///
  /// In ar, this message translates to:
  /// **'الحساب والدعم'**
  String get profileAccountSupport;

  /// No description provided for @profilePreferences.
  ///
  /// In ar, this message translates to:
  /// **'التفضيلات'**
  String get profilePreferences;

  /// No description provided for @darkMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع الليلي'**
  String get darkMode;

  /// No description provided for @darkModeEnabled.
  ///
  /// In ar, this message translates to:
  /// **'مفعل حاليًا'**
  String get darkModeEnabled;

  /// No description provided for @darkModeDisabled.
  ///
  /// In ar, this message translates to:
  /// **'غير مفعل'**
  String get darkModeDisabled;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @complaintsAndSupport.
  ///
  /// In ar, this message translates to:
  /// **'الشكاوى والدعم'**
  String get complaintsAndSupport;

  /// No description provided for @complaintsAndSupportSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أرسل شكوى أو تواصل مع الدعم عند الحاجة.'**
  String get complaintsAndSupportSubtitle;

  /// No description provided for @changePassword.
  ///
  /// In ar, this message translates to:
  /// **'تغيير كلمة المرور'**
  String get changePassword;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'حدّث كلمة المرور للحفاظ على أمان حسابك.'**
  String get changePasswordSubtitle;

  /// No description provided for @saveChanges.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التعديلات'**
  String get saveChanges;

  /// No description provided for @savingChanges.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ الحفظ...'**
  String get savingChanges;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @confirmSave.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الحفظ'**
  String get confirmSave;

  /// No description provided for @confirmSaveMessage.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد أنك تريد حفظ التعديلات؟'**
  String get confirmSaveMessage;

  /// No description provided for @savedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم الحفظ بنجاح'**
  String get savedSuccessfully;

  /// No description provided for @excellent.
  ///
  /// In ar, this message translates to:
  /// **'ممتاز'**
  String get excellent;

  /// No description provided for @emailReadOnly.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن تعديل البريد الإلكتروني'**
  String get emailReadOnly;

  /// No description provided for @emergencyContact.
  ///
  /// In ar, this message translates to:
  /// **'جهة الاتصال للطوارئ'**
  String get emergencyContact;

  /// No description provided for @editMode.
  ///
  /// In ar, this message translates to:
  /// **'وضع التعديل'**
  String get editMode;

  /// No description provided for @viewMode.
  ///
  /// In ar, this message translates to:
  /// **'وضع الاستعراض'**
  String get viewMode;

  /// No description provided for @offlineCachedDataMessage.
  ///
  /// In ar, this message translates to:
  /// **'أنت غير متصل بالإنترنت، يتم عرض آخر بيانات محفوظة.'**
  String get offlineCachedDataMessage;

  /// No description provided for @prescriptions.
  ///
  /// In ar, this message translates to:
  /// **'الوصفات الطبية'**
  String get prescriptions;

  /// No description provided for @prescriptionDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الوصفة'**
  String get prescriptionDetails;

  /// No description provided for @current.
  ///
  /// In ar, this message translates to:
  /// **'الحالية'**
  String get current;

  /// No description provided for @previous.
  ///
  /// In ar, this message translates to:
  /// **'السابقة'**
  String get previous;

  /// No description provided for @noPrescriptionsTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد وصفات هنا'**
  String get noPrescriptionsTitle;

  /// No description provided for @noPrescriptionsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ستظهر وصفاتك الطبية في هذا القسم.'**
  String get noPrescriptionsSubtitle;

  /// No description provided for @prescriptionLoadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل الوصفات'**
  String get prescriptionLoadFailed;

  /// No description provided for @prescriptionDetailsLoadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل تفاصيل الوصفة'**
  String get prescriptionDetailsLoadFailed;

  /// No description provided for @doctor.
  ///
  /// In ar, this message translates to:
  /// **'الطبيب'**
  String get doctor;

  /// No description provided for @prescriptionDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الوصفة'**
  String get prescriptionDate;

  /// No description provided for @medications.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية'**
  String get medications;

  /// No description provided for @medicationName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الدواء'**
  String get medicationName;

  /// No description provided for @dosage.
  ///
  /// In ar, this message translates to:
  /// **'الجرعة'**
  String get dosage;

  /// No description provided for @frequency.
  ///
  /// In ar, this message translates to:
  /// **'التكرار'**
  String get frequency;

  /// No description provided for @duration.
  ///
  /// In ar, this message translates to:
  /// **'المدة'**
  String get duration;

  /// No description provided for @notes.
  ///
  /// In ar, this message translates to:
  /// **'الملاحظات'**
  String get notes;

  /// No description provided for @noNotes.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد ملاحظات'**
  String get noNotes;

  /// No description provided for @additionalInstructions.
  ///
  /// In ar, this message translates to:
  /// **'تعليمات إضافية'**
  String get additionalInstructions;

  /// No description provided for @doctors.
  ///
  /// In ar, this message translates to:
  /// **'أطباء الأسنان'**
  String get doctors;

  /// No description provided for @doctorProfile.
  ///
  /// In ar, this message translates to:
  /// **'ملف طبيب الأسنان'**
  String get doctorProfile;

  /// No description provided for @searchDoctorsHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن طبيب أسنان...'**
  String get searchDoctorsHint;

  /// No description provided for @noDoctorsTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد أطباء أسنان'**
  String get noDoctorsTitle;

  /// No description provided for @noDoctorsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد أطباء أسنان متاحون حالياً.'**
  String get noDoctorsSubtitle;

  /// No description provided for @doctorsLoadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل أطباء الأسنان'**
  String get doctorsLoadFailed;

  /// No description provided for @aboutDoctor.
  ///
  /// In ar, this message translates to:
  /// **'نبذة عن طبيب الأسنان'**
  String get aboutDoctor;

  /// No description provided for @yearsOfExperience.
  ///
  /// In ar, this message translates to:
  /// **'سنوات الخبرة'**
  String get yearsOfExperience;

  /// No description provided for @yearsValue.
  ///
  /// In ar, this message translates to:
  /// **'{count} سنة'**
  String yearsValue(Object count);

  /// No description provided for @rating.
  ///
  /// In ar, this message translates to:
  /// **'التقييم'**
  String get rating;

  /// No description provided for @specialization.
  ///
  /// In ar, this message translates to:
  /// **'التخصص'**
  String get specialization;

  /// No description provided for @rateDentist.
  ///
  /// In ar, this message translates to:
  /// **'قيّم طبيب الأسنان'**
  String get rateDentist;

  /// No description provided for @sendRating.
  ///
  /// In ar, this message translates to:
  /// **'إرسال التقييم'**
  String get sendRating;

  /// No description provided for @allDentists.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get allDentists;

  /// No description provided for @ratingSubmittedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال تقييمك بنجاح.'**
  String get ratingSubmittedSuccessfully;

  /// No description provided for @treatments.
  ///
  /// In ar, this message translates to:
  /// **'علاجاتي'**
  String get treatments;

  /// No description provided for @completed.
  ///
  /// In ar, this message translates to:
  /// **'المكتملة'**
  String get completed;

  /// No description provided for @noTreatmentsTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد عناصر هنا بعد'**
  String get noTreatmentsTitle;

  /// No description provided for @noTreatmentsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'بمجرد بدء خطة علاجية جديدة، ستظهر في هذا القسم.'**
  String get noTreatmentsSubtitle;

  /// No description provided for @treatmentDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل العلاج'**
  String get treatmentDetails;

  /// No description provided for @treatmentLoadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل العلاجات'**
  String get treatmentLoadFailed;

  /// No description provided for @treatmentDetailsLoadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل تفاصيل العلاج'**
  String get treatmentDetailsLoadFailed;

  /// No description provided for @lastCompletedSession.
  ///
  /// In ar, this message translates to:
  /// **'آخر جلسة مكتملة'**
  String get lastCompletedSession;

  /// No description provided for @nextSession.
  ///
  /// In ar, this message translates to:
  /// **'الجلسة القادمة'**
  String get nextSession;

  /// No description provided for @details.
  ///
  /// In ar, this message translates to:
  /// **'التفاصيل'**
  String get details;

  /// No description provided for @startedTreatment.
  ///
  /// In ar, this message translates to:
  /// **'بدأ العلاج'**
  String get startedTreatment;

  /// No description provided for @currentProgress.
  ///
  /// In ar, this message translates to:
  /// **'التقدم الحالي'**
  String get currentProgress;

  /// No description provided for @noScheduledSessions.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد جلسات مجدولة'**
  String get noScheduledSessions;

  /// No description provided for @treatmentJourney.
  ///
  /// In ar, this message translates to:
  /// **'الرحلة العلاجية'**
  String get treatmentJourney;

  /// No description provided for @treatmentSessions.
  ///
  /// In ar, this message translates to:
  /// **'جلسات العلاج'**
  String get treatmentSessions;

  /// No description provided for @sessionNumber.
  ///
  /// In ar, this message translates to:
  /// **'الجلسة {number}'**
  String sessionNumber(Object number);

  /// No description provided for @sessionCost.
  ///
  /// In ar, this message translates to:
  /// **'تكلفة الجلسة'**
  String get sessionCost;

  /// No description provided for @toothNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم السن'**
  String get toothNumber;

  /// No description provided for @procedure.
  ///
  /// In ar, this message translates to:
  /// **'الإجراء'**
  String get procedure;

  /// No description provided for @careNotes.
  ///
  /// In ar, this message translates to:
  /// **'الملاحظات'**
  String get careNotes;

  /// No description provided for @completedSessions.
  ///
  /// In ar, this message translates to:
  /// **'{completed} من {total} جلسات'**
  String completedSessions(Object completed, Object total);

  /// No description provided for @myTreatments.
  ///
  /// In ar, this message translates to:
  /// **'علاجاتي'**
  String get myTreatments;

  /// No description provided for @activeTreatments.
  ///
  /// In ar, this message translates to:
  /// **'علاجاتي الحالية'**
  String get activeTreatments;

  /// No description provided for @payments.
  ///
  /// In ar, this message translates to:
  /// **'الدفعات'**
  String get payments;

  /// No description provided for @viewAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get viewAll;

  /// No description provided for @noData.
  ///
  /// In ar, this message translates to:
  /// **'بدون بيانات'**
  String get noData;

  /// No description provided for @activeCases.
  ///
  /// In ar, this message translates to:
  /// **'{count} حالات نشطة'**
  String activeCases(int count);

  /// No description provided for @prescriptionsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} وصفات'**
  String prescriptionsCount(int count);

  /// No description provided for @completedTreatments.
  ///
  /// In ar, this message translates to:
  /// **'علاجات مكتملة'**
  String get completedTreatments;

  /// No description provided for @view.
  ///
  /// In ar, this message translates to:
  /// **'استعراض'**
  String get view;

  /// No description provided for @comingSoon.
  ///
  /// In ar, this message translates to:
  /// **'قريبًا'**
  String get comingSoon;

  /// No description provided for @myComplaints.
  ///
  /// In ar, this message translates to:
  /// **'شكواي'**
  String get myComplaints;

  /// No description provided for @newComplaint.
  ///
  /// In ar, this message translates to:
  /// **'شكوى جديدة'**
  String get newComplaint;

  /// No description provided for @addComplaint.
  ///
  /// In ar, this message translates to:
  /// **'تقديم شكوى'**
  String get addComplaint;

  /// No description provided for @complaintDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الشكوى'**
  String get complaintDetails;

  /// No description provided for @complaintsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تابع الشكاوى التي أرسلتها وردود الإدارة من مكان واحد.'**
  String get complaintsSubtitle;

  /// No description provided for @allComplaints.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get allComplaints;

  /// No description provided for @activeComplaints.
  ///
  /// In ar, this message translates to:
  /// **'قيد المتابعة'**
  String get activeComplaints;

  /// No description provided for @closedComplaints.
  ///
  /// In ar, this message translates to:
  /// **'المغلقة'**
  String get closedComplaints;

  /// No description provided for @noComplaintsTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد شكاوى بعد'**
  String get noComplaintsTitle;

  /// No description provided for @noComplaintsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك تقديم شكوى عند مواجهة مشكلة، وستظهر هنا بعد إرسالها.'**
  String get noComplaintsSubtitle;

  /// No description provided for @noFilteredComplaintsTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج'**
  String get noFilteredComplaintsTitle;

  /// No description provided for @noFilteredComplaintsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد شكاوى مطابقة للتصنيف المحدد.'**
  String get noFilteredComplaintsSubtitle;

  /// No description provided for @complaintsLoadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحميل الشكاوى'**
  String get complaintsLoadFailed;

  /// No description provided for @complaintsRefreshFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديث الشكاوى'**
  String get complaintsRefreshFailed;

  /// No description provided for @unknownErrorMessage.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع.'**
  String get unknownErrorMessage;

  /// No description provided for @complaintTitle.
  ///
  /// In ar, this message translates to:
  /// **'عنوان الشكوى'**
  String get complaintTitle;

  /// No description provided for @complaintTitleHint.
  ///
  /// In ar, this message translates to:
  /// **'اكتب عنوانًا مختصرًا وواضحًا'**
  String get complaintTitleHint;

  /// No description provided for @complaintDescription.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الشكوى'**
  String get complaintDescription;

  /// No description provided for @complaintDescriptionHint.
  ///
  /// In ar, this message translates to:
  /// **'اشرح المشكلة التي واجهتك بالتفصيل'**
  String get complaintDescriptionHint;

  /// No description provided for @complaintContactPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتف التواصل'**
  String get complaintContactPhone;

  /// No description provided for @complaintPhoneHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: 0999999999'**
  String get complaintPhoneHint;

  /// No description provided for @complaintPriority.
  ///
  /// In ar, this message translates to:
  /// **'أولوية الشكوى'**
  String get complaintPriority;

  /// No description provided for @complaintStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة الشكوى'**
  String get complaintStatus;

  /// No description provided for @complaintSubmissionDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الإرسال'**
  String get complaintSubmissionDate;

  /// No description provided for @complaintNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الشكوى'**
  String get complaintNumber;

  /// No description provided for @complaintAdminResponse.
  ///
  /// In ar, this message translates to:
  /// **'رد الإدارة'**
  String get complaintAdminResponse;

  /// No description provided for @complaintNoAdminResponse.
  ///
  /// In ar, this message translates to:
  /// **'لم تتم إضافة رد من الإدارة بعد.'**
  String get complaintNoAdminResponse;

  /// No description provided for @complaintBasicInformation.
  ///
  /// In ar, this message translates to:
  /// **'معلومات الشكوى'**
  String get complaintBasicInformation;

  /// No description provided for @complaintBasicInformationSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل معلومات واضحة تساعد الإدارة على متابعة المشكلة.'**
  String get complaintBasicInformationSubtitle;

  /// No description provided for @complaintContactInformation.
  ///
  /// In ar, this message translates to:
  /// **'معلومات التواصل'**
  String get complaintContactInformation;

  /// No description provided for @complaintContactInformationSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'سيُستخدم الرقم للتواصل معك عند الحاجة.'**
  String get complaintContactInformationSubtitle;

  /// No description provided for @complaintPrioritySectionSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر مستوى الأولوية المناسب للمشكلة.'**
  String get complaintPrioritySectionSubtitle;

  /// No description provided for @complaintPriorityLow.
  ///
  /// In ar, this message translates to:
  /// **'منخفضة'**
  String get complaintPriorityLow;

  /// No description provided for @complaintPriorityMedium.
  ///
  /// In ar, this message translates to:
  /// **'متوسطة'**
  String get complaintPriorityMedium;

  /// No description provided for @complaintPriorityHigh.
  ///
  /// In ar, this message translates to:
  /// **'مرتفعة'**
  String get complaintPriorityHigh;

  /// No description provided for @complaintPriorityUnknown.
  ///
  /// In ar, this message translates to:
  /// **'غير محددة'**
  String get complaintPriorityUnknown;

  /// No description provided for @complaintStatusPending.
  ///
  /// In ar, this message translates to:
  /// **'قيد الانتظار'**
  String get complaintStatusPending;

  /// No description provided for @complaintStatusInProgress.
  ///
  /// In ar, this message translates to:
  /// **'قيد المعالجة'**
  String get complaintStatusInProgress;

  /// No description provided for @complaintStatusResolved.
  ///
  /// In ar, this message translates to:
  /// **'تمت المعالجة'**
  String get complaintStatusResolved;

  /// No description provided for @complaintStatusRejected.
  ///
  /// In ar, this message translates to:
  /// **'مرفوضة'**
  String get complaintStatusRejected;

  /// No description provided for @complaintStatusUnknown.
  ///
  /// In ar, this message translates to:
  /// **'غير معروفة'**
  String get complaintStatusUnknown;

  /// No description provided for @submitComplaint.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الشكوى'**
  String get submitComplaint;

  /// No description provided for @submittingComplaint.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ إرسال الشكوى...'**
  String get submittingComplaint;

  /// No description provided for @complaintSubmittedTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال الشكوى'**
  String get complaintSubmittedTitle;

  /// No description provided for @complaintSubmittedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال شكواك بنجاح.'**
  String get complaintSubmittedSuccessfully;

  /// No description provided for @complaintSubmitFailedTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعذر إرسال الشكوى'**
  String get complaintSubmitFailedTitle;

  /// No description provided for @complaintTitleRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال عنوان الشكوى'**
  String get complaintTitleRequired;

  /// No description provided for @complaintTitleTooShort.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن يتكون العنوان من 3 أحرف على الأقل'**
  String get complaintTitleTooShort;

  /// No description provided for @complaintDescriptionRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال تفاصيل الشكوى'**
  String get complaintDescriptionRequired;

  /// No description provided for @complaintDescriptionTooShort.
  ///
  /// In ar, this message translates to:
  /// **'يرجى كتابة تفاصيل أوضح عن المشكلة'**
  String get complaintDescriptionTooShort;

  /// No description provided for @complaintPhoneRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال رقم هاتف التواصل'**
  String get complaintPhoneRequired;

  /// No description provided for @complaintPriorityRequired.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار أولوية الشكوى'**
  String get complaintPriorityRequired;

  /// No description provided for @complaintSubmitConfirmationTitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد إرسال الشكوى'**
  String get complaintSubmitConfirmationTitle;

  /// No description provided for @complaintSubmitConfirmationMessage.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من رغبتك في إرسال هذه الشكوى؟ بعد الإرسال ستتمكن من متابعة حالتها والاطلاع على رد الإدارة من قسم الشكاوى.'**
  String get complaintSubmitConfirmationMessage;

  /// No description provided for @confirmComplaintSubmission.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الإرسال'**
  String get confirmComplaintSubmission;

  /// No description provided for @cancelComplaintSubmission.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancelComplaintSubmission;
}

class _GeneratedAppLocalizationsDelegate
    extends LocalizationsDelegate<GeneratedAppLocalizations> {
  const _GeneratedAppLocalizationsDelegate();

  @override
  Future<GeneratedAppLocalizations> load(Locale locale) {
    return SynchronousFuture<GeneratedAppLocalizations>(
      lookupGeneratedAppLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_GeneratedAppLocalizationsDelegate old) => false;
}

GeneratedAppLocalizations lookupGeneratedAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return GeneratedAppLocalizationsAr();
    case 'en':
      return GeneratedAppLocalizationsEn();
  }

  throw FlutterError(
    'GeneratedAppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
