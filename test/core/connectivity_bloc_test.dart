import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dt_teeth/core/connectivity/connectivity_bloc.dart';
import 'package:dt_teeth/core/connectivity/connectivity_event.dart';
import 'package:dt_teeth/core/connectivity/connectivity_state.dart';
import 'package:dt_teeth/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockNetworkInfo network;
  late StreamController<bool> changes;

  setUp(() {
    network = MockNetworkInfo();
    changes = StreamController<bool>.broadcast();
    when(() => network.onConnectionChanged).thenAnswer((_) => changes.stream);
  });
  tearDown(() => changes.close());

  blocTest<ConnectivityBloc, ConnectivityState>(
    'BT-CON-01 startup emits Online when initial check succeeds',
    setUp: () => when(() => network.isConnected).thenAnswer((_) async => true),
    build: () => ConnectivityBloc(networkInfo: network),
    act: (bloc) => bloc.add(const ConnectivityStarted()),
    expect: () => <dynamic>[isA<ConnectivityOnline>()],
  );

  blocTest<ConnectivityBloc, ConnectivityState>(
    'BT-CON-02 startup emits Offline when initial check fails',
    setUp: () => when(() => network.isConnected).thenAnswer((_) async => false),
    build: () => ConnectivityBloc(networkInfo: network),
    act: (bloc) => bloc.add(const ConnectivityStarted()),
    expect: () => <dynamic>[isA<ConnectivityOffline>()],
  );

  blocTest<ConnectivityBloc, ConnectivityState>(
    'BT-CON-03 reacts to offline then online stream changes',
    setUp: () => when(() => network.isConnected).thenAnswer((_) async => true),
    build: () => ConnectivityBloc(networkInfo: network),
    act: (bloc) async {
      bloc.add(const ConnectivityStarted());
      await Future<void>.delayed(Duration.zero);
      changes.add(false);
      changes.add(true);
    },
    expect: () => <dynamic>[
      isA<ConnectivityOnline>(),
      isA<ConnectivityOffline>(),
      isA<ConnectivityOnline>(),
    ],
  );

  blocTest<ConnectivityBloc, ConnectivityState>(
    'BT-CON-04 explicit connectivity event maps to correct state',
    build: () => ConnectivityBloc(networkInfo: network),
    act: (bloc) => bloc.add(const ConnectivityChanged(isConnected: false)),
    expect: () => <dynamic>[isA<ConnectivityOffline>()],
  );
}
