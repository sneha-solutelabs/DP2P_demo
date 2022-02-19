import 'dart:async';

import 'package:flutter/material.dart';
import 'package:poc_with_p2p/core/drive_connection/binary_api_wrapper.dart';
import 'package:poc_with_p2p/core/enums.dart';
import 'package:poc_with_p2p/core/states/connection/connection_cubit.dart';
import 'package:poc_with_p2p/core/states/connection/connection_state.dart';
import 'package:poc_with_p2p/feature/advert/presentation/widgets/short_drop_down.dart';
import 'package:poc_with_p2p/feature/advert/states/advert.dart';
import 'package:poc_with_p2p/feature/advert/states/advert_cubit.dart';
import 'package:poc_with_p2p/feature/advert/states/advert_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Available contract list widget
class AdvertList extends StatefulWidget {
  ///Initializes
  const AdvertList({required this.api}) : super();

  ///Base api
  final BinaryAPIWrapper api;

  @override
  State<StatefulWidget> createState() => _AdvertList();
}

class _AdvertList extends State<AdvertList> {

  late final AdvertListCubit _advertListCubit ;
  final ScrollController _scrollController = ScrollController();
  final List<AdvertSortType> _shortList =
  <AdvertSortType>[AdvertSortType.rate,AdvertSortType.completion];
  StreamSubscription<void>? _periodicFetchSubscription;

  @override
  void initState() {
    _advertListCubit =  AdvertListCubit(api: widget.api);
    _advertListCubit.fetchAdvertList();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _advertListCubit.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //
    final NetworkConnectionCubit connectionCubit =
    context.read<NetworkConnectionCubit>();
    _periodicFetchSubscription?.cancel();

    _periodicFetchSubscription = Stream<void>.periodic(
      const Duration(minutes: 1),
    ).listen((_) {
      if (connectionCubit.state is Connected) {
        _advertListCubit.fetchAdvertList(isPeriodic: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) => BlocProvider<AdvertListCubit>(
    create: (BuildContext context) => _advertListCubit,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Row(
            children:<Widget> [
              Expanded(flex : 4,child: _searchBar()),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: DropDownMenu(
                  key: const Key('drop_down'),
                  items: _shortList,
                  initialItem: _shortList[0],
                  onItemSelected: <AdvertSortType>(dynamic item) {
                    _advertListCubit.sortList(type: item);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8,),
          Expanded(child: _listWidget())
        ],
      ),
    ),
  );

  Widget _searchBar() => Container(
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16)
    ),
    child: TextFormField(
      decoration: const InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search),

      ),
      onChanged: (String text) {
        _advertListCubit.searchQuery(queryString: text);
      },
    ),

  );

  Widget _listWidget() => BlocBuilder<AdvertListCubit, AdvertListState>(
    builder: (BuildContext context, AdvertListState state) {
      if (state is AdvertListInitialState || state is AdvertListLoadingState) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is AdvertListLoadedState) {
        return ListView.builder(
            controller: _scrollController,
            itemCount : state.hasReachedMax
                ? state.advertList?.length
                : state.advertList?.length??0 + 1,
            physics: const BouncingScrollPhysics(),
            itemBuilder:(BuildContext context, int index) {
              if(index >= state.advertList!.length){
                return const Center(child:CircularProgressIndicator());
              }else{
                return Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,8),
                    child: _listItem(state.advertList![index])
                );
              }

            });
      } else{
        return const Center(child: Text('connecting... :'));
      }
    },
  );

  Widget _listItem(Advert advert) => Container(
    padding: const EdgeInsets.all(12) ,
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8)
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _listRowItem(key: 'Name',value: advert.advertiserDetails?.name ?? ''),
        const SizedBox(height: 8),
        _listRowItem(key: 'ID',value: advert.id??''),
        const SizedBox(height: 8),
        _listRowItem(key: 'Price',value: advert.priceDisplay ?? ''),
        const SizedBox(height: 8),
        _listRowItem(key: 'Country',value: advert.country ?? ''),
        const SizedBox(height: 8),
        _listRowItem(key: 'Description',value: advert.description ?? ''),
      ],
    ),
  );

  Widget _listRowItem ({required String key,required String value }) => Row(
    children: <Widget>[
      Expanded(
        flex: 2,
          child: Text(key),
      ),
      Expanded(flex: 4,child: Text(value))
    ]
  );
  void _onScroll({AdvertListState? state}) {
    if (_scrollController.position.maxScrollExtent !=
        _scrollController.offset) {
      return;
    }
    _advertListCubit.fetchAdvertList();
  }
}