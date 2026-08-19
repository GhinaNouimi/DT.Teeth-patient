import 'package:dt_teeth/core/app/app.dart';
import 'package:dt_teeth/core/localization/locale_bloc/locale_bloc.dart';
import 'package:dt_teeth/core/theme/theme_bloc/theme_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  testWidgets('MyApp builds successfully', (WidgetTester tester) async {
    final storage = MockStorage();

    when<dynamic>(() => storage.read(any())).thenReturn(null);

    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});

    when(() => storage.delete(any())).thenAnswer((_) async {});

    when(storage.clear).thenAnswer((_) async {});

    HydratedBloc.storage = storage;

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeBloc()),
          BlocProvider(create: (_) => LocaleBloc()),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.byType(MyApp), findsOneWidget);

    // إنهاء مؤقت Splash قبل انتهاء الاختبار.
    await tester.pump(const Duration(milliseconds: 3700));

    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(MyApp), findsOneWidget);

    expect(tester.takeException(), isNull);

    // تنظيف شجرة التطبيق.
    await tester.pumpWidget(const SizedBox.shrink());

    await tester.pump();
  });
}
