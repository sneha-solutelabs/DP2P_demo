import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poc_with_p2p/root_screen.dart';

import 'feature/dash_board/presentation/page/dashboard_page.dart';

///poc app
class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
        title: 'DP2P Demo',
        theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryColor: Colors.grey,
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark().copyWith(
            primary: Colors.grey,
            secondary: Colors.grey,
          ),
          appBarTheme: AppBarTheme.of(context).copyWith(
            backgroundColor: const Color(0xFF6E6E6E),
            centerTitle: false,
          ),
        ),
        initialRoute: RootScreen.routeName,
        onUnknownRoute: (RouteSettings settings) => MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) => const RootScreen(),
        ),
        routes: <String, WidgetBuilder>{
          RootScreen.routeName: (BuildContext context) =>
              const RootScreen(),
          DashboardPage.routeName: (BuildContext context) =>
              DashboardPage()
        },
      );
  }
}