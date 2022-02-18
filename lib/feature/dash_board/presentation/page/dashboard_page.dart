import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poc_with_p2p/feature/advert/presentation/widgets/adverts_list.dart';

///Home page where all component are integrate [ActiveSymbolsDropDown],
///[SelectedSymbolDetail],[AvailableContractList]
class DashboardPage extends StatefulWidget{
  /// Dashboard Page route name.
  static const String routeName = 'dashboard_page';

  @override
  State<StatefulWidget> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const<Widget> [
          Text('advert :'),
          SizedBox(height: 8,),
          // Expanded(child: AdvertList())
        ],
      )
  );

}