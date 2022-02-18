import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poc_with_p2p/feature/advert/states/advert_cubit.dart';
import 'package:poc_with_p2p/feature/advert/states/advert_state.dart';

class MockAdvertListCubit extends MockCubit<AdvertListState>
    implements AdvertListCubit {}

class FakeAdvertStatusState extends Mock implements AdvertListState {}

void main() {
  late MockAdvertListCubit mockAdvertListCubit;

  setUpAll(() {
    registerFallbackValue(FakeAdvertStatusState());
    TestWidgetsFlutterBinding.ensureInitialized();
    mockAdvertListCubit = MockAdvertListCubit();
  });

  group('Advert List status cubit tests =>', () {
    testWidgets('fetch advert list', (WidgetTester tester) async {
      whenListen(mockAdvertListCubit,
          Stream<AdvertListState>.fromIterable(<AdvertListState>[
            AdvertListInitialState(),
            AdvertListLoadingState(),
            AdvertListLoadedState()
          ])
      );
      await expectLater(
        mockAdvertListCubit.stream,
        emitsInOrder(
          <TypeMatcher<AdvertListState>>[
            isA<AdvertListInitialState>(),
            isA<AdvertListLoadingState>(),
            isA<AdvertListLoadedState>(),
          ],
        ),
      );
      // expect(mockAccountStatusCubit.state, isA<AccountStatusState>());
    });

    // blocTest('check advert states',
    //   build: ()=> mockAdvertListCubit,
    //   act: (cubit) => cubit?.fetchAdvertList(),
    //   expect: () => [
    //     AdvertListLoadingState(),
    //     AdvertListLoadedState()
    //   ]
    // );
  });

}