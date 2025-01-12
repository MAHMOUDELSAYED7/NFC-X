import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/utils/routes.dart';
import 'presentation/view/landing_screen.dart';
import 'presentation/view/nfc_read_screen.dart';
import 'presentation/view/nfc_write_screen.dart';

void main() => runApp(ProviderScope(child: const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        builder: (context, widget) {
          final mediaQueryData = MediaQuery.of(context);
          final scaledMediaQueryData = mediaQueryData.copyWith(
            textScaler: TextScaler.noScaling,
          );
          return MediaQuery(
            data: scaledMediaQueryData,
            child: widget!,
          );
        },
        title: 'NFC X',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          brightness: Brightness.light,
        ),
        routes: _buildRoutes(),
        initialRoute: RoutesManager.landingScreen,
      ),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      RoutesManager.landingScreen: (context) => const LandingScreen(),
      RoutesManager.nfcWriteDataScreen: (context) => NfcWriteScreen(),
      RoutesManager.nfcReadDataScreen: (context) => NfcReadScreen(),
    };
  }
}
