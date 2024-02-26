import 'package:fire_app/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/routing/routing.dart';

class MyApp extends StatelessWidget {
  final AppRouter router;

  const MyApp({super.key, required this.router});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        title: 'Flutter Fire',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        initialRoute: Routes.loginScreen,
        onGenerateRoute: router.generateRoute,
      ),
    );
  }
}
