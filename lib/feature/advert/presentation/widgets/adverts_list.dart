import 'package:flutter/material.dart';
import 'package:poc_with_p2p/core/drive_connection/binary_api_wrapper.dart';
import 'package:poc_with_p2p/core/enums.dart';
import 'package:poc_with_p2p/feature/advert/presentation/widgets/short_drop_down.dart';
import 'package:poc_with_p2p/feature/advert/states/advert.dart';
import 'package:poc_with_p2p/feature/advert/states/advert_cubit.dart';
import 'package:poc_with_p2p/feature/advert/states/advert_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Available contract list widget
class AdvertList extends StatefulWidget {
  ///Initializes
  const AdvertList({required this.api}) : super();

  final BinaryAPIWrapper api;

  @override
  State<StatefulWidget> createState() => _AdvertList();
}

class _AdvertList extends State<AdvertList> {

  late final AdvertListCubit _advertListCubit ;
  final ScrollController _scrollController = ScrollController();
  final List<AdvertSortType> _shortList = <AdvertSortType>[AdvertSortType.rate,AdvertSortType.completion];

  @override
  void initState() {
    _advertListCubit =  AdvertListCubit(api: widget.api);
    _advertListCubit.fetchAdvertList();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _advertListCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider<AdvertListCubit>(
    create: (context) => _advertListCubit,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(flex : 4,child: _searchBar()),
              SizedBox(width: 8,),
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
          SizedBox(height: 8,),
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
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: const Icon(Icons.search),

      ),
      onChanged: (text) {
        _advertListCubit.searchQuery(queryString: text);
      },
    ),

  );
  Widget _listWidget() => BlocBuilder<AdvertListCubit, AdvertListState>(
    builder: (context, state) {
      if (state is AdvertListInitialState) {
        return Center(
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
                return Center(child:CircularProgressIndicator());
              }else{
                return Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,8),
                    child: _listItem(state.advertList![index])
                );
              }

            });
      } else{
        return Center(child: Text('connecting... :'));
      }
    },
  );

  _listItem(Advert advert) => Container(
    padding: const EdgeInsets.all(12) ,
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8)
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(advert.advertiserDetails?.name ?? ''),
        const SizedBox(height: 8),
        Text(advert.description ?? ''),
        const SizedBox(height: 8),
        Text('$advert : ID : ${advert.id}'),
        const SizedBox(height: 8),
        Text('amount : ${advert.amountDisplay }'),
      ],
    ),
  );

  _onScroll({AdvertListState? state}) {
    if (_scrollController.position.maxScrollExtent !=
        _scrollController.offset) {
      return;
    }
    _advertListCubit.fetchAdvertList();
  }


}