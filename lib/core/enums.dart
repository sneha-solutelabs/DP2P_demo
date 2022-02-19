/// Api error type
enum APIErrorType {
  /// server error
  serverError,
  ///Restricted Country
  restrictedCountry,
  ///Disable Account
  disableAccount,
  ///Unwelcome Account
  unwelcomeAccount,
  ///Expired Account
  expiredAccount,
  ///Unsupported Currency
  unsupportedCurrency,
  ///NotAvailable Country
  notAvailableCountry,
  ///Account Not Loaded
  accountNotLoaded,
  ///Unknown Error
  unknownError,
}
///Advert type
enum AdvertType {
  ///buy
  buy,
  /// sell
  sell,
}

/// Advert sort type
enum AdvertSortType {
  ///rate
  rate,
  ///completion
  completion,
}