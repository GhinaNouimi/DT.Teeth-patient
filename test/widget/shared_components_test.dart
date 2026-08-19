import 'package:dt_teeth/core/widgets/common/app_filter_tabs.dart';
import 'package:dt_teeth/core/widgets/common/app_section_card.dart';
import 'package:dt_teeth/core/widgets/common/app_status_chip.dart';
import 'package:dt_teeth/core/widgets/feedback/error_bottom_sheet.dart';
import 'package:dt_teeth/core/widgets/feedback/offline_cached_banner.dart';
import 'package:dt_teeth/core/widgets/feedback/success_bottom_sheet.dart';
import 'package:dt_teeth/core/widgets/loading/app_skeleton.dart';
import 'package:dt_teeth/core/widgets/navigation/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child, {Brightness brightness = Brightness.light}) {
  return MaterialApp(
    theme: ThemeData(brightness: brightness, useMaterial3: true),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('OfflineCachedBanner', () {
    testWidgets('WT-CORE-01 shows offline icon and supplied message', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(const OfflineCachedBanner(message: 'Cached data')),
      );
      expect(find.text('Cached data'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
    });

    testWidgets('WT-CORE-02 hides close action when callback is absent', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(const OfflineCachedBanner(message: 'Offline')),
      );
      expect(find.byIcon(Icons.close_rounded), findsNothing);
    });

    testWidgets('WT-CORE-03 close action invokes callback once', (
      tester,
    ) async {
      var calls = 0;
      await tester.pumpWidget(
        host(OfflineCachedBanner(message: 'Offline', onClose: () => calls++)),
      );
      await tester.tap(find.byIcon(Icons.close_rounded));
      expect(calls, 1);
    });
  });

  for (final type in AppStatusType.values) {
    testWidgets(
      'WT-CORE-STATUS-${type.index + 1} renders ${type.name} status',
      (tester) async {
        await tester.pumpWidget(
          host(AppStatusChip(label: type.name, type: type, icon: Icons.circle)),
        );
        expect(find.text(type.name), findsOneWidget);
        expect(find.byIcon(Icons.circle), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('WT-CORE-09 compact chip uses smaller padding and icon', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const AppStatusChip(
          label: 'Compact',
          type: AppStatusType.success,
          icon: Icons.check,
          isCompact: true,
        ),
      ),
    );
    expect(tester.widget<Icon>(find.byIcon(Icons.check)).size, 14);
  });

  group('AppFilterTabs', () {
    testWidgets('WT-CORE-10 displays labels, icons, and counts', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          AppFilterTabs<int>(
            items: const <AppFilterTabItem<int>>[
              AppFilterTabItem(
                value: 1,
                label: 'Current',
                icon: Icons.today,
                count: 3,
              ),
              AppFilterTabItem(value: 2, label: 'Past', count: 5),
            ],
            selectedValue: 1,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Current'), findsOneWidget);
      expect(find.text('Past'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.byIcon(Icons.today), findsOneWidget);
    });

    testWidgets('WT-CORE-11 tapping another tab returns its typed value', (
      tester,
    ) async {
      int? selected;
      await tester.pumpWidget(
        host(
          AppFilterTabs<int>(
            items: const <AppFilterTabItem<int>>[
              AppFilterTabItem(value: 1, label: 'One'),
              AppFilterTabItem(value: 2, label: 'Two'),
            ],
            selectedValue: 1,
            onChanged: (value) => selected = value,
          ),
        ),
      );
      await tester.tap(find.text('Two'));
      expect(selected, 2);
    });

    testWidgets('WT-CORE-12 supports horizontally overflowing items', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(240, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        host(
          AppFilterTabs<int>(
            items: List<AppFilterTabItem<int>>.generate(
              10,
              (i) => AppFilterTabItem(value: i, label: 'Long filter $i'),
            ),
            selectedValue: 0,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('AppSectionCard', () {
    testWidgets('WT-CORE-13 displays child without interaction wrapper', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(const AppSectionCard(child: Text('Information'))),
      );
      expect(find.text('Information'), findsOneWidget);
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('WT-CORE-14 tappable card invokes action', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        host(
          AppSectionCard(onTap: () => tapped = true, child: const Text('Open')),
        ),
      );
      await tester.tap(find.text('Open'));
      expect(tapped, isTrue);
      expect(find.byType(InkWell), findsOneWidget);
    });
  });

  group('AppTopBar', () {
    testWidgets('WT-CORE-15 renders title, back, trailing and callback', (
      tester,
    ) async {
      var back = 0;
      await tester.pumpWidget(
        host(
          AppTopBar(
            title: 'Details',
            onBackTap: () => back++,
            trailing: const Icon(Icons.more_vert),
          ),
        ),
      );
      expect(find.text('Details'), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      expect(back, 1);
    });

    testWidgets('WT-CORE-16 hides back button when disabled', (tester) async {
      await tester.pumpWidget(
        host(const AppTopBar(title: 'Home', showBackButton: false)),
      );
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);
    });
  });

  testWidgets('WT-CORE-17 AppSkeleton forwards enabled state and child', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(const AppSkeleton(enabled: true, child: Text('Loading content'))),
    );

    expect(find.text('Loading content'), findsOneWidget);

    final appSkeleton = tester.widget<AppSkeleton>(find.byType(AppSkeleton));

    expect(appSkeleton.enabled, isTrue);
    expect(appSkeleton.child, isA<Text>());
    expect(tester.takeException(), isNull);
  });
  group('Feedback bottom sheets', () {
    testWidgets('WT-CORE-18 success sheet renders, closes, and calls action', (
      tester,
    ) async {
      var called = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showSuccessBottomSheet(
                  context,
                  title: 'Success',
                  message: 'Saved',
                  buttonText: 'Done',
                  onPressed: () => called = true,
                ),
                child: const Text('Open'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Success'), findsOneWidget);
      expect(find.text('Saved'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(called, isTrue);
      expect(find.text('Success'), findsNothing);
    });

    testWidgets('WT-CORE-19 error sheet renders, closes, and calls action', (
      tester,
    ) async {
      var called = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showErrorBottomSheet(
                  context,
                  title: 'Error',
                  message: 'Try again',
                  buttonText: 'Close',
                  onPressed: () => called = true,
                ),
                child: const Text('Open'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(called, isTrue);
      expect(find.text('Error'), findsNothing);
    });
  });
}
