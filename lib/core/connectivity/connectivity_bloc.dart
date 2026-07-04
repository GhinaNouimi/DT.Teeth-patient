import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../network/network_info.dart';
import 'connectivity_event.dart';
import 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final NetworkInfo networkInfo;

  StreamSubscription<bool>? _subscription;

  ConnectivityBloc({
    required this.networkInfo,
  }) : super(const ConnectivityInitial()) {
    on<ConnectivityStarted>(_onStarted);
    on<ConnectivityChanged>(_onChanged);
  }

  Future<void> _onStarted(
      ConnectivityStarted event,
      Emitter<ConnectivityState> emit,
      ) async {
    final isConnected = await networkInfo.isConnected;

    emit(
      isConnected
          ? const ConnectivityOnline()
          : const ConnectivityOffline(),
    );

    await _subscription?.cancel();

    _subscription = networkInfo.onConnectionChanged.listen((isConnected) {
      add(
        ConnectivityChanged(
          isConnected: isConnected,
        ),
      );
    });
  }

  void _onChanged(
      ConnectivityChanged event,
      Emitter<ConnectivityState> emit,
      ) {
    emit(
      event.isConnected
          ? const ConnectivityOnline()
          : const ConnectivityOffline(),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}