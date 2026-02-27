import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0E9D58),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Text(
              'The Total Food Safety And\nTraceability Software Solution',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
    
  }
}
