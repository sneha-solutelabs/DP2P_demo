import 'package:flutter/material.dart';
import 'package:flutter_deriv_api/services/connection/api_manager/binary_api.dart';
import 'package:poc_with_p2p/core/drive_connection/binary_api_wrapper.dart';

import '../../drive_connection/api_error.dart';

@immutable
abstract class NetworkConnectionState {}


class InitialConnectionState extends NetworkConnectionState {}

class Connecting extends NetworkConnectionState {
  final BinaryAPIWrapper api;

  Connecting(this.api);
}


class Connected extends NetworkConnectionState {
  final BinaryAPIWrapper api;
  Connected(this.api);
}

/// This state represents that the WebSocket is disconnect.
class Disconnected extends NetworkConnectionState {
  /// Will emit `Disconnected` state with given parameters.
  Disconnected({
    this.isInternetLost = false,
    this.error,
  });

  /// connected to a Wi-Fi or MobileData.
  final bool isInternetLost;

  /// The error object returned from the server.
  final APIError? error;
}

/// This state represents that the WebSocket is trying to reconnect.
class Reconnecting extends NetworkConnectionState {
  /// Will emit `Reconnecting` state with given parameters.
  Reconnecting({
    this.isInternetLost = false,
  });

  /// If true, That means the connection was closed because the device is not
  /// connected to a Wi-Fi or MobileData.
  final bool isInternetLost;
}