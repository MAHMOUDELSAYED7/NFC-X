import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({super.key, required this.errorMessage});
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Text(
        errorMessage,
        style: TextStyle(
          color: Colors.red,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
