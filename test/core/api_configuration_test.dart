import 'package:dt_teeth/core/network/api_constants.dart';
import 'package:dt_teeth/core/network/api_error_mapper.dart';
import 'package:dt_teeth/core/network/api_error_messages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('API endpoint construction', () {
    test('UT-API-01 appointment endpoints include selected identifiers', () {
      expect(
        ApiConstants.patientShowAppointmentDetails(23),
        '/patient/showAppointmentdetails/23',
      );
      expect(
        ApiConstants.patientUpdateAppointment(23),
        '/patient/updateAppointments/23',
      );
      expect(
        ApiConstants.patientCancelAppointment(23),
        '/patient/cancelAppointment/23',
      );
    });

    test(
      'UT-API-02 doctor endpoints include dentist and specialization ids',
      () {
        expect(
          ApiConstants.patientShowDentistDetails(4),
          '/patient/showDentistDetails/4',
        );
        expect(
          ApiConstants.patientShowDentistRate(4),
          '/patient/showDentistRate/4',
        );
        expect(
          ApiConstants.patientShowDentistsBySpecialization(2),
          '/patient/showDentistsBySpecialization/2',
        );
      },
    );

    test(
      'UT-API-03 treatment, prescription, invoice and offer paths are stable',
      () {
        expect(
          ApiConstants.patientShowPrescriptionDetails(7),
          '/patient/showPrescriptionDetails/7',
        );
        expect(
          ApiConstants.patientShowTreatmentDetails(8),
          '/patient/showTreatmentdetails/8',
        );
        expect(
          ApiConstants.invoiceForTreatment(9),
          '/patient/invoiceForTreatment/9',
        );
        expect(
          ApiConstants.patientApplyToOffer(10),
          '/patient/applyToOffer/10',
        );
      },
    );
  });

  group('localized error mapping', () {
    test('UT-ERR-01 language selector recognizes Arabic locale variants', () {
      expect(ApiErrorMessages.text('ar_SY', ar: 'عربي', en: 'English'), 'عربي');
      expect(ApiErrorMessages.text('en', ar: 'عربي', en: 'English'), 'English');
    });

    test('UT-ERR-02 maps duplicate email in both languages', () {
      expect(
        ApiErrorMapper.validation(
          field: 'email',
          message: 'already taken',
          languageCode: 'en',
        ),
        'This email address is already in use.',
      );
      expect(
        ApiErrorMapper.validation(
          field: 'email',
          message: 'already taken',
          languageCode: 'ar',
        ),
        contains('مستخدم'),
      );
    });

    test('UT-ERR-03 maps phone, password confirmation, and date fields', () {
      expect(
        ApiErrorMapper.validation(
          field: 'phone_number',
          message: 'invalid',
          languageCode: 'en',
        ),
        'Please enter a valid phone number.',
      );
      expect(
        ApiErrorMapper.validation(
          field: 'password_confirmation',
          message: 'invalid',
          languageCode: 'en',
        ),
        'Password confirmation does not match.',
      );
      expect(
        ApiErrorMapper.validation(
          field: 'date_of_birth',
          message: 'invalid',
          languageCode: 'en',
        ),
        'Please enter a valid date of birth.',
      );
    });

    test(
      'UT-ERR-04 generic validation recognizes required, image, and max errors',
      () {
        expect(
          ApiErrorMapper.validation(
            field: 'unknown',
            message: 'required',
            languageCode: 'en',
          ),
          contains('required fields'),
        );
        expect(
          ApiErrorMapper.validation(
            field: 'unknown',
            message: 'invalid image',
            languageCode: 'en',
          ),
          contains('valid image'),
        );
        expect(
          ApiErrorMapper.validation(
            field: 'unknown',
            message: 'too large',
            languageCode: 'en',
          ),
          contains('exceeds'),
        );
      },
    );

    test(
      'UT-ERR-05 common mapper handles credentials and expired sessions',
      () {
        expect(
          ApiErrorMapper.common(
            message: 'Invalid credentials',
            languageCode: 'en',
          ),
          'Email or password is incorrect.',
        );
        expect(
          ApiErrorMapper.common(message: 'Unauthenticated', languageCode: 'en'),
          contains('session has expired'),
        );
      },
    );

    test('UT-ERR-06 common mapper localizes appointment business rules', () {
      expect(
        ApiErrorMapper.common(
          message: 'لا يمكن إلغاء الموعد قبل أقل من 24 ساعة',
          languageCode: 'en',
        ),
        contains('less than 24 hours'),
      );
      expect(
        ApiErrorMapper.common(
          message: 'لا يمكن إلغاء هذا الموعد في حالته الحالية',
          languageCode: 'en',
        ),
        contains('current status'),
      );
    });
  });
}
