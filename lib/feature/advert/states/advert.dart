import 'package:poc_with_p2p/core/enums.dart';
import 'package:poc_with_p2p/feature/advert/states/advertiser.dart';

class Advert {
  /// Advert Const
  Advert(
      {this.counterpartyType,
        this.accountCurrency,
        this.amountDisplay,
        this.remainingAmountDisplay,
        this.country,
        this.isActive,
        this.description,
        this.id,
        this.sortBy,
        this.advertiserDetails});

  /// Advert Const
  factory Advert.fromMap(Map<String, dynamic> advert) => Advert(
      accountCurrency: advert['account_currency'],
      advertiserDetails: Advertiser.fromMap(
          advert['advertiser_details'] ?? <String, dynamic>{}),
      amountDisplay: advert['amount_display'],
      country: advert['country'],
      counterpartyType: advert['counterparty_type'] == 'sell'
          ? AdvertType.sell
          : AdvertType.buy,
      description: advert['description'],
      id: advert['id'],
      sortBy: _getAdvertSortType(advert['sort_by']),
      isActive: advert['is_active'] == 1,
      remainingAmountDisplay: advert['remaining_amount_display']);

  /// accountCurrency val
  final String? accountCurrency;

  /// amountDisplay val
  final String? amountDisplay;

  /// remainingAmountDisplay val
  final String? remainingAmountDisplay;

  /// country val
  final String? country;

  /// counterpartyType val
  final AdvertType? counterpartyType;

  /// description val
  final String? description;

  /// id val
  final String? id;

  /// isActive val
  final bool? isActive;

  /// advertiserDetails val
  final Advertiser? advertiserDetails;

  final AdvertSortType? sortBy;

  static AdvertSortType _getAdvertSortType(String? sortBy) {
    switch (sortBy) {
      case 'rate':
        return AdvertSortType.rate;
      case 'completion':
        return AdvertSortType.completion;
      default:
        return AdvertSortType.rate;
    }
  }
}