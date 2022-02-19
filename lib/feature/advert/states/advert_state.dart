import 'package:poc_with_p2p/feature/advert/states/advert.dart';

///Base state of Tick state
abstract class AdvertListState {}
///Loading state for ticks
class AdvertListInitialState extends AdvertListState {}

/// AdvertList Loading State
class AdvertListLoadingState extends AdvertListState {}

///Loaded state for ticks
class AdvertListLoadedState extends AdvertListState {
  ///initialize
  AdvertListLoadedState({
    this.advertList,
    this.hasReachedMax = false
  });

  ///tick object
  final List<Advert>? advertList;
  /// reach max index
  final bool hasReachedMax;

}

/// Error state for advert list
class AdvertListErrorState extends AdvertListState {
  ///Initialize
  AdvertListErrorState(this.errorMessage);
  ///Error message
  final String errorMessage;
}
