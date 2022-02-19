import 'package:flutter/material.dart';
import 'package:poc_with_p2p/core/drive_connection/binary_api_wrapper.dart';

import '../../drive_connection/api_error.dart';

@immutable
///Network Connection State
abstract class NetworkConnectionState {}

///Initial Connection State
class InitialConnectionState extends NetworkConnectionState {}
///Connecting
class Connecting extends NetworkConnectionState {
  ///Init
  Connecting(this.api);
  ///api
  final BinaryAPIWrapper api;
}

///Connected
class Connected extends NetworkConnectionState {
  ///init
  Connected(this.api);
  ///api
  final BinaryAPIWrapper api;

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