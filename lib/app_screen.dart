
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_deriv_api/basic_api/generated/api.dart';
import 'package:flutter_deriv_api/basic_api/response.dart';
import 'package:flutter_deriv_api/services/connection/api_manager'
    '/binary_api.dart' as deriv_api;
import 'package:flutter_deriv_api/services/connection/api_manager/connection_information.dart';
import 'package:poc_with_p2p/core/states/connection/connection_cubit.dart';
import 'package:poc_with_p2p/core/states/connection/connection_state.dart';
import 'package:web_socket_channel/io.dart';

///Connection checking screen
class AppScreen extends StatefulWidget {
  ///App screen key define
  const AppScreen({Key? key}) : super(key: key);

  ///App screen route name
  static const String routeName = 'app_screen_page';
  @override
  State<AppScreen> createState() => _AppScreenState();
}


class _AppScreenState extends State<AppScreen> {
  late final NetworkConnectionCubit _connectionCubit  = NetworkConnectionCubit();
  final deriv_api.BinaryAPI _api = deriv_api.BinaryAPI(UniqueKey());

  @override
  void initState() {
    super.initState();
    _initializeBlocs();
  }

  @override
  Widget build(BuildContext context) {


    return BlocProvider<NetworkConnectionCubit>(
      create: (context) => NetworkConnectionCubit(),
      child: BlocBuilder<NetworkConnectionCubit, NetworkConnectionState>(
        builder: (context, state) {
          if (state is Connecting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is Connected) {
            return Center(
              child: Text('sneha'),
            );
          } else if(state is Disconnected){
            return Text(state.error.toString());
          }else{
            return Text('else');
          }
        },
      ),
    );
  }

  void _initializeBlocs() async{


    // await _api.close();
    await run(onOpen: (UniqueKey? uniqueKey) {
      dev.log('onOpen : $uniqueKey');
    }, onDone: (UniqueKey? uniqueKey) {
      dev.log('onDone : $uniqueKey');
    }, onError: (UniqueKey? uniqueKey) {
      dev.log('onError : $uniqueKey');

    });




    final Response response  = await _api.call<Response>(request: PingRequest());

    // final Map<String, dynamic> response =
    // await _api.ping().timeout(const Duration(seconds: 15));

    if (response.toJson()['ping'] != 'pong') {
      /// not connected
      dev.log('onError : Ping connection failed...');
    }

    final Response authResponse  = await _api.call<Response>(request: AuthorizeRequest(authorize: "9Oh9nWiaLe0mxd9"));
    final Map<String,dynamic> json = authResponse.toJson();
    if (json['error'] != null) {
      dev.log('Authorisation error...: ${json['error']}');
    }
    dev.log('success...');
  }

  Future<IOWebSocketChannel?> run({
    void Function(UniqueKey? uniqueKey)? onError,
    void Function(UniqueKey? uniqueKey)? onDone,
    void Function(UniqueKey? uniqueKey)? onOpen,
  }) async {
    final ConnectionInformation connectionInformation = ConnectionInformation(
        appId: '1089', brand: 'deriv', endpoint: 'frontend.binaryws.com');

    await _api.connect(connectionInformation,
        onOpen: onOpen?.call, onDone: onDone?.call, onError: onError?.call);
  }
}
