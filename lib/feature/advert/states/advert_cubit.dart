import 'package:bloc/bloc.dart';
import 'package:poc_with_p2p/core/drive_connection/binary_api_wrapper.dart';
import 'package:poc_with_p2p/feature/advert/states/advert.dart';
import 'package:poc_with_p2p/feature/advert/states/advert_state.dart';

import '../../../core/enums.dart';
import 'dart:math' as math;

///Advert list cubit
class AdvertListCubit extends Cubit<AdvertListState>{
  /// Init
  AdvertListCubit({required this.api}) : super(AdvertListInitialState());

  ///APi
  BinaryAPIWrapper api;
  /// list of adverts
  final List<Advert> _advertsList = <Advert>[];

  /// fetch limit for pagination
  final int defaultLimit = 5;
  /// sort type
  AdvertSortType sortType = AdvertSortType.rate ;
  /// Query
  String query = '' ;


  /// Fetch advert list
  Future<void> fetchAdvertList({bool isPeriodic = false}) async {
    try {
      final int limit = isPeriodic
          ? math.max(_advertsList.length, defaultLimit)
          : defaultLimit;

      final int offset = isPeriodic ? 0 : _advertsList.length;

      if(offset == 0 && !isPeriodic){
        emit(AdvertListLoadingState());
      }
      final Map<String,dynamic> response = await api.p2pAdvertList(
          counterpartyType :'buy',
          limit :limit,
          offset:offset,
          sortBy: sortType,
          searchQuery: query
          );


      if(response['error'] != null){
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
          emit(AdvertListLoadedState(advertList: _advertsList,
              hasReachedMax: list.length < limit));
        }
      }
    } on Exception catch (e) {
      emit(AdvertListErrorState('$e'));
    }
  }

  ///Search list from query
  Future<void> searchQuery({String queryString=''}) async{
      _advertsList.clear();
      query = queryString;
      await fetchAdvertList();
  }


  /// Sort list
  Future<void> sortList({AdvertSortType type= AdvertSortType.rate}) async{
    _advertsList.clear();
    sortType = type;
    await fetchAdvertList();
  }


}
