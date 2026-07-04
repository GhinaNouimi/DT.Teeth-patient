import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'core/app/app.dart';
import 'core/connectivity/connectivity_bloc.dart';
import 'core/connectivity/connectivity_event.dart';
import 'core/localization/locale_bloc/locale_bloc.dart';
import 'core/network/network_info.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/theme/theme_bloc/theme_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );

  final token = await SecureStorageService.getToken();
  debugPrint('APP START TOKEN: $token');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeBloc(),
        ),
        BlocProvider(
          create: (_) => LocaleBloc(),
        ),
        BlocProvider(
          create: (_) => ConnectivityBloc(
            networkInfo: NetworkInfo(
              connectivity: Connectivity(),
            ),
          )..add(const ConnectivityStarted()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}