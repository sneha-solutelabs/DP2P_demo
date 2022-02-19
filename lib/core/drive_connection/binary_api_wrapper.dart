import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deriv_api/basic_api/generated/authorize_receive.dart';
import 'package:flutter_deriv_api/basic_api/generated/authorize_send.dart';
import 'package:flutter_deriv_api/basic_api/generated/p2p_advert_list_send.dart';
import 'package:flutter_deriv_api/basic_api/generated/ping_send.dart';
import 'package:flutter_deriv_api/basic_api/request.dart';
import 'package:flutter_deriv_api/basic_api/response.dart';
import 'package:flutter_deriv_api/services/connection/api_manager/binary_api.dart'
as deriv_api;
import 'package:flutter_deriv_api/services/connection/api_manager/connection_information.dart';
import 'package:poc_with_p2p/core/enums.dart';
import 'package:poc_with_p2p/core/helper/json_helper.dart';

///api wrapper
class BinaryAPIWrapper {
  /// Constructs a new BinaryAPIWrapper.
  BinaryAPIWrapper() {
    _derivAPI = deriv_api.BinaryAPI(UniqueKey());
  }

  // final Interceptor? interceptor;
  late final deriv_api.BinaryAPI _derivAPI;

  /// Do connection
  Future<void> run({required Function(UniqueKey) onOpen,
    required  Function(UniqueKey) onDone,
    required Function(UniqueKey) onError}) async{
    final ConnectionInformation connectionInformation =

    ConnectionInformation(
        appId: '1089',
        brand: 'deriv',
        endpoint: 'frontend.binaryws.com');

    await _derivAPI.connect(connectionInformation,
        onDone: onDone.call,
        onOpen:  onOpen.call,
        onError:  onError.call);
  }


  /// Disconnects from API
  Future<void> close() async {
    await _derivAPI.disconnect();
  }

  Future<Map<String, dynamic>> _derivAPICall(Request request) async {
    final Response response = await _derivAPI.call<Response>(request: request);

    return _normalizeErrorObject(response);
  }

  ///ping api
  Future<Map<String, dynamic>> ping() => _derivAPICall(const PingRequest());

  ///authorize api
  Future<AuthorizeResponse> authorize(String? token) async {
    AuthorizeResponse authObj;
    try {
      authObj = AuthorizeResponse.fromJson(
        await _derivAPICall(AuthorizeRequest(authorize: token)),
      );
    } on Exception catch (e) {
      throw Exception(e);
    }

    return authObj;
  }


  Map<String, dynamic> _normalizeErrorObject(Response response) {
    final Map<String, dynamic> rawResponse = JSONHelper.decode(
      JSONHelper.encode(response.toJson()),
      convertObjectToArrayKeys: <String>[
        'fields',
      ],
    );

    if (rawResponse['error'] == null) {
      rawResponse.remove('error');
    }

    return rawResponse;
  }


  ///advert  list api
  Future<Map<String, dynamic>> p2pAdvertList({
    String? counterpartyType,
    int? limit,
    int? offset,
    String? searchQuery,
    AdvertSortType? sortBy ,
  }) =>
      _derivAPICall(P2pAdvertListRequest(
        counterpartyType: counterpartyType,
        limit: limit,
        offset: offset,
        advertiserName: searchQuery,
        sortBy: describeEnum(sortBy?? AdvertSortType.rate),
      ));
}