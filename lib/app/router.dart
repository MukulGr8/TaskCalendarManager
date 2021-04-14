import 'package:auto_route/auto_route_annotations.dart';
import 'package:demostacked/screens/home/homeview.dart';
import 'package:demostacked/screens/home/notifyscreen/notifyview.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    // initial route is named "/"
    MaterialRoute(
      page: HomeView,
    ),
    MaterialRoute(
      page: NotifyView,
    ),
  ],
)
class $Router {}
