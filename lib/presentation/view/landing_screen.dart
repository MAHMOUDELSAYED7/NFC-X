import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/routes.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/nfc_landing_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'NFC X',
        icon: Icons.nfc_rounded,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NfcMainButton(
                title: 'NFC Read',
                icon: Icons.document_scanner_rounded,
                route: RoutesManager.nfcReadDataScreen),
            SizedBox(height: 15.h),
            NfcMainButton(
                title: 'NFC Write',
                icon: Icons.edit_note_rounded,
                route: RoutesManager.nfcWriteDataScreen),
          ],
        ),
      ),
    );
  }
}
