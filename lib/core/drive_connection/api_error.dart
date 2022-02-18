import 'package:equatable/equatable.dart';

import '../enums.dart';

/// Data model for server errors.
// ignore: must_be_immutable
class APIError extends Equatable implements Exception {
  /// Constructs a new APIError.
  APIError({
    this.code,
    this.message,
    this.errorType,
  });

  /// Constructs a new APIError from the given Map object.
  factory APIError.fromMap(Map<String, dynamic> data) => APIError(
    code: data['code'],
    message: data['message'],
    errorType: APIErrorType.serverError,
  );

  /// Contains the error code got from server.
  String? code;

  /// Contains the error message got from server.
  String? message;

  /// Determines the error type.
  APIErrorType? errorType;

  /// Checks if the error code is `P2PDisabled`.
  bool get isP2PDisabled => code == 'P2PDisabled';

  /// Checks if the error code is `InvalidToken`.
  bool get isTokenExpired => code == 'InvalidToken';

  /// Checks if the error code is `AccountDisabled`.
  bool get isAccountDisabled => code == 'AccountDisabled';

  /// Checks if the error code is `DisabledClient`.
  bool get isDisabledClient => code == 'DisabledClient';

  /// Checks if the error code is `AlreadySubscribed`.
  bool get isAlreadySubscribed => code == 'AlreadySubscribed';

  /// Checks if the error code is `AdvertiserNotFound`.
  bool get isAdvertiserNotFound => code == 'AdvertiserNotFound';

  /// Checks if the error code is `PermissionDenied`.
  bool get isPermissionDenied => code == 'PermissionDenied';

  /// Checks if the error code is `AdvertSameLimits`.
  bool get isAdvertSameLimits => code == 'AdvertSameLimits';

  /// Checks if the error code is `DuplicateAdvert`.
  bool get isDuplicateAdvert => code == 'DuplicateAdvert';

  /// Checks if the error code is `AdvertMaxExceededSameType`.
  bool get isAdvertMaxExceededSameType => code == 'AdvertMaxExceededSameType';

  /// Checks if the error code is `isUserDisabled` or `DisabledClient`.
  bool get isUserDisabled => isAccountDisabled || isDisabledClient;

  @override
  List<String?> get props => <String?>[code, message];
}
