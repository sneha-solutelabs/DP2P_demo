import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poc_with_p2p/feature/advert/states/advert.dart';

import 'advert_data.dart';

void main() {
  group('Advert list page test =>', () {
    testWidgets('list view', (WidgetTester tester) async {
      Widget _listRowItem ({required String key,required String value }) => Row(
          children:<Widget> [
            Expanded(
              flex: 2,
              child: Text(key),
            ),
            Expanded(flex: 4,child: Text(value))
          ]
      );
      await tester.pumpWidget(MaterialApp(
          home: ListView.builder(
              itemCount : adverts.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder:(BuildContext context, int index) {
                final Advert advert = adverts[index];
                return Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,8),
                    child: Container(
                      padding: const EdgeInsets.all(12) ,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _listRowItem(key: 'Name',
                              value: advert.advertiserDetails?.name ?? ''),
                          const SizedBox(height: 8),
                          _listRowItem(key: 'ID',
                              value: advert.id??''),
                          const SizedBox(height: 8),
                          _listRowItem(key: 'Price',
                              value: advert.priceDisplay ?? ''),
                          const SizedBox(height: 8),
                          _listRowItem(key: 'Country',
                              value: advert.country ?? ''),
                          const SizedBox(height: 8),
                          _listRowItem(key: 'Description',
                              value: advert.description ?? ''),
                        ],
                      ),
                    )
                );
              }
          )
      ),);

      await tester.idle();
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Scrollable), findsOneWidget);
    });

    testWidgets('Search bar view', (WidgetTester tester) async {
      String quary = '';
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(16)
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (String text) {
                  quary = text;
                },
              ),

            ),
          )
      ),
      );

      await tester.idle();
      // await tester.pumpAndSettle();
      expect(quary, '');
      expect(find.byType(TextFormField), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), 'Sneha');
      expect(quary, 'Sneha');

    });

  });


}