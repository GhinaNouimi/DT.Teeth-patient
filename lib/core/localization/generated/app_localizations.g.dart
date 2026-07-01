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
