import 'package:contact_directory/resources/resource_export.dart';
import 'package:contact_directory/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../routes/route_paths.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final actions = <_HomeAction>[
      _HomeAction(
        title: 'Police Contacts',
        subtitle: 'Find stations & hotlines',
        accent: context.resources.color.appBlue,
        leading: Image.asset(
          context.resources.drawable.bangladeshPoliceLogo,
          fit: BoxFit.contain,
        ),
        onTap: () => NavigationService.navigateTo(RoutePaths.policeContactsPage),
      ),
      _HomeAction(
        title: 'Fire Service',
        subtitle: 'Coming soon',
        accent: context.resources.color.appRed,
        leading: const Icon(Icons.local_fire_department_rounded),
        onTap: null,
      ),
      _HomeAction(
        title: 'Ambulance',
        subtitle: 'Coming soon',
        accent: context.resources.color.appGreen,
        leading: const Icon(Icons.emergency_rounded),
        onTap: null,
      ),
      _HomeAction(
        title: 'Helplines',
        subtitle: 'Coming soon',
        accent: context.resources.color.statePurple,
        leading: const Icon(Icons.support_agent_rounded),
        onTap: null,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Directory',
          style: context.resources.style.appBarTextStyle,
        ),
        centerTitle: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: context.resources.color.mainBgGradient,
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
                sliver: SliverToBoxAdapter(
                  child: _HomeHeader(
                    titleStyle: context.resources.style.w800s26(context.resources.color.primaryTextColor),
                    subtitleStyle: context.resources.style.w400s14(context.resources.color.tertiaryTextColor),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 240.w,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 1.08,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = actions[index];
                      return _HomeActionCard(
                        title: item.title,
                        subtitle: item.subtitle,
                        leading: item.leading,
                        accent: item.accent,
                        onTap: item.onTap,
                        titleStyle: context.resources.style.w700s16(context.resources.color.primaryTextColor),
                        subtitleStyle:
                            context.resources.style.w400s12(context.resources.color.secondaryTextColor),
                        surfaceColor: context.resources.color.white,
                        borderColor: context.resources.color.primaryColorBorder,
                      );
                    },
                    childCount: actions.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.titleStyle,
    required this.subtitleStyle,
  });

  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome', style: titleStyle),
        SizedBox(height: 6.h),
        Text(
          'Select a directory to get started.',
          style: subtitleStyle,
        ),
      ],
    );
  }
}

class _HomeAction {
  const _HomeAction({
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Widget leading;
  final Color accent;
  final VoidCallback? onTap;
}

class _HomeActionCard extends StatelessWidget {
  const _HomeActionCard({
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.accent,
    required this.onTap,
    required this.titleStyle,
    required this.subtitleStyle,
    required this.surfaceColor,
    required this.borderColor,
  });

  final String title;
  final String subtitle;
  final Widget leading;
  final Color accent;
  final VoidCallback? onTap;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final Color surfaceColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16.r);
    final isEnabled = onTap != null;

    return Opacity(
      opacity: isEnabled ? 1 : 0.55,
      child: Material(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44.r,
                      height: 44.r,
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: IconTheme(
                        data: IconThemeData(color: accent, size: 22.r),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: leading,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 20.r,
                      color: accent,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(title, style: titleStyle, maxLines: 1),
                SizedBox(height: 4.h),
                Text(subtitle, style: subtitleStyle, maxLines: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
