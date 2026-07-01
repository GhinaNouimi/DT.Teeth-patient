import 'package:dt_teeth/core/app/app.dart';
import 'package:dt_teeth/core/localization/locale_bloc/locale_bloc.dart';
import 'package:dt_teeth/core/theme/theme_bloc/theme_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  testWidgets('MyApp builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ThemeBloc(),
          ),
          BlocProvider(
            create: (_) => LocaleBloc(),
          ),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.byType(MyApp), findsOneWidget);
  });
}