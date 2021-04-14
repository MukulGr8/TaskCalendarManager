import 'dart:async';

import 'package:demostacked/app/locator.dart';
import 'package:demostacked/app/router.gr.dart' as Router;
import 'package:demostacked/services/shared_perfernces_services.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked_services/stacked_services.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await SharedPrefrenceService
      .initPref(); // to intialise the shared perference variable

  Logger.level = Level.verbose;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: Router.Routes.homeView,
      onGenerateRoute: Router.Router().onGenerateRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: StartupView(),
    );
  }
}
