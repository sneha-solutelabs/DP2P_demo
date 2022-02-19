import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_deriv_api/basic_api/generated/authorize_receive.dart';
import 'package:poc_with_p2p/core/states/connection/connection_state.dart' ;

import '../../drive_connection/binary_api_wrapper.dart';

///Connection cubit
class NetworkConnectionCubit extends
  Cubit<NetworkConnectionState> {
  ///init
  NetworkConnectionCubit() : super(InitialConnectionState()){
    initialize();
  }

  late BinaryAPIWrapper _api ;

  /// Api wrapper
  BinaryAPIWrapper get binaryApi => _api;

  /// Initialize
  Future<void> initialize() async {
    _api = BinaryAPIWrapper();
    await connectToWebSocket();
  }

  /// Connection set up
  Future<void> connectToWebSocket() async {

    emit(Connecting(_api));
    await _api.close();
    await _api.run(
      onDone: (UniqueKey? uniqueKey) {
        emit(Connected(_api));
      },
      onOpen: (UniqueKey? uniqueKey) {
      },
      onError: (UniqueKey? uniqueKey) {
        emit(Disconnected());
      },
    );
    await _ping();
  }

  Future<void> _ping() async {
    try {
      final Map<String, dynamic> response = await _api
          .ping();

      if (response['ping'] == 'pong') {
        final AuthorizeResponse response =
        await _api.authorize('9Oh9nWiaLe0mxd9');

        if(response.error == null){
          emit(Connected(_api));
        }else{
          emit(Disconnected());
        }
      }
    }on Exception  catch(_){
      emit(Disconnected());
    }
  }
}