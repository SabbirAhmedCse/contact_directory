import 'package:flutter/material.dart';

import 'package:contact_directory/features/core/presentation/pages/home_screen.dart';
import 'package:contact_directory/features/core/presentation/routes/app_routes.dart';
import 'package:contact_directory/features/police_contacts/presentation/pages/contacts_page.dart';

class AppRouter {
  const AppRouter();

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return _buildMaterialRoute(const HomeScreen(), settings);
      case AppRoutes.policeContacts:
        return _buildMaterialRoute(const ContactsPage(), settings);
      default:
        return _buildMaterialRoute(const HomeScreen(), settings);
    }
  }

  Route<dynamic> _buildMaterialRoute(Widget child, RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      builder: (BuildContext context) => child,
      settings: settings,
    );
  }
}
