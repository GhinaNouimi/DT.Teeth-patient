import 'package:dt_teeth/core/localization/app_localizations.dart';
import 'package:dt_teeth/features/auth/presentation/pages/signup/widgets/health_yes_no_question.dart';
import 'package:dt_teeth/features/auth/presentation/pages/signup/widgets/teeth_cleaning_selector.dart';
import 'package:dt_teeth/features/auth/presentation/pages/widgets/app_text_field.dart';
import 'package:dt_teeth/features/auth/presentation/pages/widgets/gender_selector_card.dart';
import 'package:dt_teeth/features/auth/presentation/pages/widgets/password_strength_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child, {String language = 'en'}) {
  return MaterialApp(
    locale: Locale(language),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

void main() {
  group('AppTextField validation and behavior', () {
    testWidgets('WT-HARD-01 form rejects empty value', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        host(
          Form(
            key: formKey,
            child: AppTextField(
              controller: controller,
              label: 'Email',
              hint: 'name@example.com',
              prefixIcon: Icons.mail,
              validator: (value) {
                if ((value ?? '').isEmpty) {
                  return 'Email is required';
                }
                return null;
              },
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('WT-HARD-02 valid input removes validation error', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        host(
          Form(
            key: formKey,
            child: AppTextField(
              controller: controller,
              label: 'Email',
              hint: 'email',
              prefixIcon: Icons.mail,
              validator: (value) {
                return (value ?? '').contains('@') ? null : 'Invalid email';
              },
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Invalid email'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'user@test.com');

      expect(formKey.currentState!.validate(), isTrue);
      await tester.pump();

      expect(find.text('Invalid email'), findsNothing);
    });

    testWidgets('WT-HARD-03 password visibility can be toggled', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'Secret123!');
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        host(
          AppTextField(
            controller: controller,
            label: 'Password',
            hint: '********',
            prefixIcon: Icons.lock,
            obscureText: true,
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility_rounded), findsOneWidget);

      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isTrue,
      );

      await tester.tap(find.byIcon(Icons.visibility_rounded));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off_rounded), findsOneWidget);

      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isFalse,
      );
    });

    testWidgets('WT-HARD-04 multiline field uses multiline settings', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        host(
          AppTextField(
            controller: controller,
            label: 'Notes',
            hint: 'Details',
            prefixIcon: Icons.notes,
            maxLines: 4,
          ),
        ),
      );

      final editableText = tester.widget<EditableText>(
        find.byType(EditableText),
      );

      expect(editableText.maxLines, 4);
      expect(editableText.textInputAction, TextInputAction.newline);
      expect(editableText.keyboardType, TextInputType.multiline);
    });

    testWidgets('WT-HARD-05 readonly field invokes onTap', (tester) async {
      final controller = TextEditingController(text: 'Selected');
      addTearDown(controller.dispose);

      var tapCount = 0;

      await tester.pumpWidget(
        host(
          AppTextField(
            controller: controller,
            label: 'Choice',
            hint: 'Choose',
            prefixIcon: Icons.list,
            readOnly: true,
            onTap: () => tapCount++,
          ),
        ),
      );

      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);

      expect(
        tester.widget<EditableText>(find.byType(EditableText)).readOnly,
        isTrue,
      );

      await tester.tap(find.byType(TextFormField));

      expect(tapCount, 1);
      expect(controller.text, 'Selected');
    });

    testWidgets('WT-HARD-06 onChanged receives latest text', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      final receivedValues = <String>[];

      await tester.pumpWidget(
        host(
          AppTextField(
            controller: controller,
            label: 'Name',
            hint: 'Name',
            prefixIcon: Icons.person,
            onChanged: receivedValues.add,
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Ghina');

      expect(receivedValues, <String>['Ghina']);
    });
  });

  group('PasswordStrengthCard', () {
    testWidgets('WT-HARD-07 empty password has zero strength', (tester) async {
      await tester.pumpWidget(host(const PasswordStrengthCard(password: '')));

      await tester.pumpAndSettle();

      final progress = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      expect(progress.value, 0);

      expect(find.byIcon(Icons.check_circle_rounded), findsNothing);

      expect(
        find.byIcon(Icons.radio_button_unchecked_rounded),
        findsNWidgets(4),
      );
    });

    testWidgets('WT-HARD-08 weak password passes one rule', (tester) async {
      await tester.pumpWidget(
        host(const PasswordStrengthCard(password: 'abcdefgh')),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

      expect(
        find.byIcon(Icons.radio_button_unchecked_rounded),
        findsNWidgets(3),
      );
    });

    testWidgets('WT-HARD-09 strong password passes all rules', (tester) async {
      await tester.pumpWidget(
        host(const PasswordStrengthCard(password: 'Strong123!')),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle_rounded), findsNWidgets(4));

      expect(find.byIcon(Icons.radio_button_unchecked_rounded), findsNothing);

      final strength = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      expect(strength.value, greaterThanOrEqualTo(0.75));
    });

    testWidgets('WT-HARD-10 title can be hidden', (tester) async {
      await tester.pumpWidget(
        host(
          const PasswordStrengthCard(password: 'Strong123!', showTitle: false),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.shield_rounded), findsNothing);

      expect(find.byIcon(Icons.check_circle_rounded), findsNWidgets(4));
    });
  });

  group('Gender and health controls', () {
    testWidgets('WT-HARD-11 selected gender shows check icon', (tester) async {
      await tester.pumpWidget(
        host(
          GenderSelectorCard(
            selectedGender: 'Male',
            options: const <String>['Male', 'Female'],
            showError: false,
            onSelected: (_) {},
            delay: Duration.zero,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);

      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });

    testWidgets('WT-HARD-12 selecting female returns correct value', (
      tester,
    ) async {
      String? selectedGender;

      await tester.pumpWidget(
        host(
          GenderSelectorCard(
            selectedGender: null,
            options: const <String>['Male', 'Female'],
            showError: false,
            onSelected: (value) {
              selectedGender = value;
            },
            delay: Duration.zero,
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Female'));

      expect(selectedGender, 'Female');
    });

    testWidgets('WT-HARD-13 gender validation error appears', (tester) async {
      await tester.pumpWidget(
        host(
          GenderSelectorCard(
            selectedGender: null,
            options: const <String>['Male', 'Female'],
            showError: true,
            onSelected: (_) {},
            delay: Duration.zero,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Please select your gender'), findsOneWidget);
    });

    testWidgets('WT-HARD-14 health question sends yes and no values', (
      tester,
    ) async {
      final receivedValues = <bool>[];

      await tester.pumpWidget(
        host(
          HealthYesNoQuestion(
            title: 'Smoker',
            subtitle: 'Do you smoke?',
            icon: Icons.smoking_rooms,
            value: false,
            onChanged: receivedValues.add,
          ),
        ),
      );

      await tester.tap(find.text('Yes'));
      await tester.tap(find.text('No'));

      expect(receivedValues, <bool>[true, false]);
    });

    testWidgets(
      'WT-HARD-15 health selection exposes semantics',
          (tester) async {
        final semanticsHandle = tester.ensureSemantics();

        await tester.pumpWidget(
          host(
            HealthYesNoQuestion(
              title: 'Question',
              subtitle: 'Subtitle',
              icon: Icons.health_and_safety,
              value: true,
              onChanged: (_) {},
            ),
          ),
        );

        expect(
          find.byWidgetPredicate(
                (widget) {
              return widget is Semantics &&
                  widget.properties.label == 'Yes' &&
                  widget.properties.selected == true;
            },
          ),
          findsOneWidget,
        );

        semanticsHandle.dispose();
      },
    );
  });

  group('TeethCleaningSelector', () {
    testWidgets('WT-HARD-16 renders all cleaning options', (tester) async {
      await tester.pumpWidget(
        host(TeethCleaningSelector(value: 'once', onChanged: (_) {})),
      );

      expect(find.byIcon(Icons.looks_one_rounded), findsOneWidget);

      expect(find.byIcon(Icons.looks_two_rounded), findsOneWidget);

      expect(find.byIcon(Icons.auto_awesome_rounded), findsOneWidget);
    });

    testWidgets('WT-HARD-17 cleaning choices return API values', (
      tester,
    ) async {
      final receivedValues = <String>[];

      await tester.pumpWidget(
        host(
          TeethCleaningSelector(value: 'once', onChanged: receivedValues.add),
        ),
      );

      await tester.tap(find.byIcon(Icons.looks_two_rounded));

      await tester.tap(find.byIcon(Icons.auto_awesome_rounded));

      expect(receivedValues, <String>['twice', 'rarely']);
    });

    testWidgets('WT-HARD-18 Arabic selector is RTL and interactive', (
      tester,
    ) async {
      String? selectedValue;

      await tester.pumpWidget(
        host(
          TeethCleaningSelector(
            value: 'once',
            onChanged: (value) {
              selectedValue = value;
            },
          ),
          language: 'ar',
        ),
      );

      expect(
        Directionality.of(tester.element(find.byType(TeethCleaningSelector))),
        TextDirection.rtl,
      );

      await tester.tap(find.byIcon(Icons.looks_two_rounded));

      expect(selectedValue, 'twice');
    });
  });
}
