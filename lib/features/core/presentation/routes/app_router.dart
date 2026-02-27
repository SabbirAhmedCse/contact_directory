import 'dart:io';

import 'package:flutter/material.dart';

import '../../../police_contacts/presentation/pages/police_contacts_page.dart';
import '../pages/home_screen.dart';
import 'route_paths.dart';


class AppRouter {
 static Route generateRoute(RouteSettings settings) {
    Widget widget;

    switch (settings.name) {
      case RoutePaths.home:
        widget = const HomeScreen();
        break;
      case RoutePaths.policeContactsPage:
        widget = const PoliceContactsPage();
        break;
      default:
        widget = Container();
        break;
    }
    if (Platform.isIOS) {
      return MaterialPageRoute(
        builder: (context) {
          return PopScope(
            canPop: false,
            onPopInvoked: (didPop) => _onPop(context),
            child: widget,
          );
        },
        settings: RouteSettings(
          name: settings.name,
          arguments: settings.arguments,
        ),
      );
    }

    return _createRoute(settings, widget);
  }

 static Route _createRoute(final RouteSettings settings, final widget) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      barrierColor: Colors.black,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  static Future<bool> _onPop(BuildContext context) async {
    if (Navigator.of(context).userGestureInProgress) {
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);
  }
}
