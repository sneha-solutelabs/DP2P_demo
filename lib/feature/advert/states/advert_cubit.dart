import 'package:bloc/bloc.dart';
import 'package:poc_with_p2p/core/drive_connection/binary_api_wrapper.dart';
import 'package:poc_with_p2p/feature/advert/states/advert.dart';
import 'package:poc_with_p2p/feature/advert/states/advert_state.dart';

import '../../../core/enums.dart';

class AdvertListCubit extends Cubit<AdvertListState>{
  AdvertListCubit({required this.api}) : super(AdvertListInitialState());

  BinaryAPIWrapper api;
  /// list of adverts
  final List<Advert> _advertsList = <Advert>[];

  /// fetch limit for pagination
  final int limit = 10;
  AdvertSortType sortType = AdvertSortType.rate ;
  String query = "" ;


  Future<void> fetchAdvertList() async {
    try {
      final int offset = _advertsList.length ;

      if(offset == 0){
        emit(AdvertListLoadingState());
      }
      final Map<String,dynamic> response = await api.p2pAdvertList(
          counterpartyType :'buy',
          limit :limit,
          offset:offset,
          sortBy: sortType,
          searchQuery: query
          );


      if (response ==  null) {
        emit(AdvertListErrorState('Something went wrong'));
      }else if(response['error'] != null){
        emit(AdvertListErrorState(response['error']));
      }else{
        final List<dynamic> list =
        response['p2p_advert_list']['list'];
        if (list.isNotEmpty) {
          if (offset == 0) {
            _advertsList.clear();
          }
          for (final Map<String, dynamic> response in list) {
            _advertsList.add(Advert.fromMap(response));
          }
          emit(AdvertListLoadedState(advertList: _advertsList,hasReachedMax: list.length < limit));
        }
      }
    } on Exception catch (e) {
      emit(AdvertListErrorState('$e'));
    }
  }

  Future<void> searchQuery({String queryString=""}) async{
      _advertsList.clear();
      query = queryString;
      fetchAdvertList();
  }


  Future<void> sortList({AdvertSortType type= AdvertSortType.rate}) async{
    _advertsList.clear();
    sortType = type;
    fetchAdvertList();
  }


}
