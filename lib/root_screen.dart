import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_with_p2p/core/states/connection/connection_cubit.dart';
import 'package:poc_with_p2p/core/states/connection/connection_state.dart';
import 'package:poc_with_p2p/feature/advert/presentation/widgets/adverts_list.dart';

///Connection checking screen
class RootScreen extends StatefulWidget {
  ///App screen key define
  const RootScreen({Key? key}) : super(key: key);

  ///App screen route name
  static const String routeName = 'app_screen_page';
  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen>{
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Drive Demo'),
    ),
    body: BlocProvider<NetworkConnectionCubit>(
      create: (BuildContext context) => NetworkConnectionCubit(),
      child: BlocBuilder<NetworkConnectionCubit, NetworkConnectionState>(
        builder: (BuildContext context, NetworkConnectionState state) {
          if (state is Connecting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is Connected) {
            return AdvertList(api : state.api);
          } else if(state is Disconnected){
            return Text(state.error.toString());
          }else{
            return const Text('else');
          }
        },
      ),
    ),
  );

}