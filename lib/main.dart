import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/Views/homepage.dart';

import 'Controllers/todoController.dart';
import 'Views/splashScreen.dart';
import 'bindings/home_binding.dart';

void main() {
  Get.put(todoController());
  runApp(MyApp());
}

/// Main App
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter GetX App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(
          name: '/',
          page: () => Homepage(),
          binding: AnotherBinding(),
        ),
      ],
    );
  }
}






