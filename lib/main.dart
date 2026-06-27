import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'core/app/app.dart';
import 'core/config/locale_controller.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/theme/theme_bloc/theme_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getApplicationDocumentsDirectory()).path),
  );

  final token = await SecureStorageService.getToken();
  debugPrint('APP START TOKEN: $token');

  final localeController = LocaleController();
  await localeController.loadLocale();

  runApp(
    BlocProvider(
      create: (_) => ThemeBloc(),
      child: MyApp(
        localeController: localeController,
      ),
    ),
  );
}