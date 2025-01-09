import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class NfcMainButton extends StatelessWidget {
  const NfcMainButton(
      {super.key,
      required this.title,
      required this.icon,
      required this.route});
  final String title;
  final IconData icon;
  final String route;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: FilledButton.tonal(
          style: FilledButton.styleFrom(
            fixedSize: Size(double.maxFinite, 80.h),
            backgroundColor: Colors.blue[100],
          ),
          onPressed: () => Navigator.pushNamed(context, route),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 30.sp),
              SizedBox(width: 10.w),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                  color: Colors.black,
                ),
              ),
            ],
          )),
    );
  }
}
