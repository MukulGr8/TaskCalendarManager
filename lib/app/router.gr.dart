// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../model/eventslist_model.dart';
import '../screens/home/homeview.dart';
import '../screens/home/notifyscreen/notifyview.dart';

class Routes {
  static const String homeView = '/home-view';
  static const String notifyView = '/notify-view';
  static const all = <String>{
    homeView,
    notifyView,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.notifyView, page: NotifyView),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeView(),
        settings: data,
      );
    },
    NotifyView: (data) {
      final args = data.getArgs<NotifyViewArguments>(
        orElse: () => NotifyViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => NotifyView(listEventsItem: args.listEventsItem),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// NotifyView arguments holder class
class NotifyViewArguments {
  final ListEvents listEventsItem;
  NotifyViewArguments({this.listEventsItem});
}
