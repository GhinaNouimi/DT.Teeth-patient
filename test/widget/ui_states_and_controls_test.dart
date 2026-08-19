import 'package:dt_teeth/core/localization/app_localizations.dart';
import 'package:dt_teeth/features/doctors/presentation/widgets/doctor_search_field.dart';
import 'package:dt_teeth/features/medical_record/presentation/widgets/medical_record_empty_state.dart';
import 'package:dt_teeth/features/medical_record/presentation/widgets/medical_record_tab_bar.dart';
import 'package:dt_teeth/features/medical_record/presentation/widgets/treatment_progress_ring.dart';
import 'package:dt_teeth/features/medical_record/presentation/widgets/treatment_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child, {String language = 'en'}) => MaterialApp(
  locale: Locale(language),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('MedicalRecordEmptyState', () {
    testWidgets('WT-STATE-01 renders provided empty-state content', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const MedicalRecordEmptyState(
            title: 'No prescriptions',
            subtitle: 'Nothing was found',
            icon: Icons.receipt_long,
          ),
        ),
      );
      expect(find.text('No prescriptions'), findsOneWidget);
      expect(find.text('Nothing was found'), findsOneWidget);
      expect(find.byIcon(Icons.receipt_long), findsOneWidget);
    });

    testWidgets('WT-STATE-02 supports long failure messages without exception', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const SizedBox(
            width: 220,
            child: MedicalRecordEmptyState(
              title: 'Loading failed',
              subtitle:
                  'A long localized error message that should wrap safely on narrow screens.',
              icon: Icons.error_outline,
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('MedicalRecordTabBar', () {
    testWidgets('WT-STATE-03 displays every label and matching count', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          MedicalRecordTabBar(
            labels: const <String>['Current', 'History'],
            counts: const <int>[2, 5],
            currentIndex: 0,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Current'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('WT-STATE-04 tapping history emits index one', (tester) async {
      int? selected;
      await tester.pumpWidget(
        host(
          MedicalRecordTabBar(
            labels: const <String>['Current', 'History'],
            currentIndex: 0,
            onChanged: (value) => selected = value,
          ),
        ),
      );
      await tester.tap(find.text('History'));
      expect(selected, 1);
    });

    testWidgets('WT-STATE-05 missing or short counts remain safe', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          MedicalRecordTabBar(
            labels: const <String>['One', 'Two'],
            counts: const <int>[1],
            currentIndex: 1,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('1'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('DoctorSearchFieldWidget', () {
    testWidgets('WT-STATE-06 displays localized search field and icon', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        host(
          DoctorSearchFieldWidget(controller: controller, onChanged: (_) {}),
        ),
      );
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.decoration?.hintText, isNotEmpty);
    });

    testWidgets('WT-STATE-07 typing forwards the complete query', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      String? query;
      await tester.pumpWidget(
        host(
          DoctorSearchFieldWidget(
            controller: controller,
            onChanged: (value) => query = value,
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'Lina');
      expect(query, 'Lina');
      expect(controller.text, 'Lina');
    });

    testWidgets('WT-STATE-08 clear control clears text and emits empty query', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'Lina');
      addTearDown(controller.dispose);
      String? query;
      await tester.pumpWidget(
        host(
          DoctorSearchFieldWidget(
            controller: controller,
            onChanged: (value) => query = value,
          ),
        ),
      );
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close_rounded));
      expect(controller.text, isEmpty);
      expect(query, '');
    });

    testWidgets('WT-STATE-09 Arabic host provides RTL direction', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        host(
          DoctorSearchFieldWidget(controller: controller, onChanged: (_) {}),
          language: 'ar',
        ),
      );
      expect(
        Directionality.of(tester.element(find.byType(TextField))),
        TextDirection.rtl,
      );
    });
  });

  group('TreatmentStatusChip', () {
    for (final status in <String>[
      'ongoing',
      'completed',
      'cancelled',
      'unknown',
    ]) {
      testWidgets('WT-STATE-STATUS-$status renders localized $status state', (
        tester,
      ) async {
        await tester.pumpWidget(host(TreatmentStatusChip(status: status)));
        expect(find.byType(TreatmentStatusChip), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
        expect((tester.widget<Text>(find.byType(Text))).data, isNotEmpty);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('WT-STATE-14 status matching ignores spaces and case', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(const TreatmentStatusChip(status: ' COMPLETED ')),
      );
      final normalizedText = (tester.widget<Text>(find.byType(Text))).data;
      await tester.pumpWidget(
        host(const TreatmentStatusChip(status: 'completed')),
      );
      expect((tester.widget<Text>(find.byType(Text))).data, normalizedText);
    });
  });

  group('TreatmentProgressRing', () {
    testWidgets('WT-STATE-15 renders zero, partial, and complete percentages', (
      tester,
    ) async {
      for (final percent in <int>[0, 40, 100]) {
        await tester.pumpWidget(host(TreatmentProgressRing(percent: percent)));
        expect(find.text('$percent%'), findsOneWidget);
        expect(find.byType(CustomPaint), findsWidgets);
      }
    });

    testWidgets('WT-STATE-16 respects custom component size', (tester) async {
      await tester.pumpWidget(
        host(const TreatmentProgressRing(percent: 50, size: 80)),
      );
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      expect(
        sizedBoxes.any((box) => box.width == 80 && box.height == 80),
        isTrue,
      );
    });
  });
}
