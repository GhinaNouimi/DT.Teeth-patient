import 'package:dt_teeth/core/app/app.dart';
import 'package:dt_teeth/core/config/locale_controller.dart';
import 'package:dt_teeth/core/theme/theme_bloc/theme_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  testWidgets('MyApp builds successfully', (WidgetTester tester) async {
    final localeController = LocaleController();

    await tester.pumpWidget(
      BlocProvider(
        create: (_) => ThemeBloc(),
        child: MyApp(
          localeController: localeController,
        ),
      ),
    );

    expect(find.byType(MyApp), findsOneWidget);
  });
}