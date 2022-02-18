


import 'api_error.dart';

/// This class will intercept all web socket communications and raise the
/// relevant callback.
/// Base abstract class for interceptor.
abstract class BaseInterceptor {
  /// This callback will be called when the response is received.
  bool handleResponse(Map<String, dynamic> response);

  /// This callback will be called before the request is sent.
  void onRequest(Map<String, dynamic> req);

  /// This callback will be called when the response does not contain errors.
  bool onSuccess(Map<String, dynamic> success) => true;

  /// This callback will be called when the response contains an error.
  bool onError(APIError error) => true;
}

class Interceptor extends BaseInterceptor {
  @override
  bool handleResponse(Map<String, dynamic> response) {
    throw UnimplementedError();
  }

  @override
  void onRequest(Map<String, dynamic> req) {

  }
}