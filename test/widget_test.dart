import 'package:dt_teeth/core/app/app.dart';
import 'package:dt_teeth/core/config/locale_controller.dart';
import 'package:dt_teeth/core/config/theme_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyApp builds successfully', (WidgetTester tester) async {
    final themeController = ThemeController();
    final localeController = LocaleController();

    await tester.pumpWidget(
      MyApp(
        themeController: themeController,
        localeController: localeController,
      ),
    );

    expect(find.byType(MyApp), findsOneWidget);
  });
}
