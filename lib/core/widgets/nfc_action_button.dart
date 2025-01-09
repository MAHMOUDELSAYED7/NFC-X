import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NfcActionButton extends StatelessWidget {
  final bool isScanning;
  final void Function() onPressed;
  const NfcActionButton(
      {super.key, required this.isScanning, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(double.maxFinite, 80.h),
          backgroundColor: isScanning ? Colors.blue : Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.nfc_rounded,
              size: 30.sp,
              color: isScanning ? Colors.white : Colors.black,
            ),
            SizedBox(width: 8.w),
            Text(
              isScanning ? 'Scanning...' : 'Tap to Read NFC',
              style: TextStyle(
                fontSize: 16.sp,
                color: isScanning ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
