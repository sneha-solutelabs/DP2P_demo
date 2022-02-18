import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_deriv_api/basic_api/generated/authorize_receive.dart';
import 'package:poc_with_p2p/core/states/connection/connection_state.dart' as ConnectionState;
import 'package:poc_with_p2p/core/states/connection/connection_state.dart';

import '../../drive_connection/binary_api_wrapper.dart';

class NetworkConnectionCubit extends Cubit<ConnectionState.NetworkConnectionState> {
  NetworkConnectionCubit() : super(InitialConnectionState()){
    initialize();
  }

  late BinaryAPIWrapper _api ;

  BinaryAPIWrapper get binaryApi => _api;

  void initialize() async {
    _api = BinaryAPIWrapper();
    connectToWebSocket();
  }

  Future<void> connectToWebSocket() async {

    emit(Connecting(_api));
    await _api.close();
    await _api.run(
      onDone: (UniqueKey? uniqueKey) {
        emit(Connected(_api));
        print('done call back');
      },
      onOpen: (UniqueKey? uniqueKey) {
        print('open call back');
      },
      onError: (UniqueKey? uniqueKey) {
        emit(ConnectionState.Disconnected());
      },
    );
    _ping();
  }

  Future<void> _ping() async {
    try {
      final Map<String, dynamic> response = await _api
          .ping();

      if (response['ping'] == 'pong') {
        final AuthorizeResponse response = await _api.authorize("9Oh9nWiaLe0mxd9");

        if(response.error == null){
          emit(Connected(_api));
        }else{
          emit(Disconnected());
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}