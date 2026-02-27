import 'package:contact_directory/resources/resource_export.dart';
import 'package:contact_directory/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../res/routes/route_paths.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Directory'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            NavigationService.navigateTo( RoutePaths.policeContactsPage);
                          },
                          child: Card(
                            child: Container(
                              width: 200.w,
                              height: 200.h,
                              child: Image.asset(
                                context
                                    .resources
                                    .drawable
                                    .bangladeshPoliceLogo,
                              ),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                  Expanded(child: Column(children: [],))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
