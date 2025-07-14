import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 1500), () {
      Get.offNamed('/home'); // Navigate to home after 1.5 seconds
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt, // Using the 'task_alt' icon which is similar to a todo icon
              size: 200,
              color: Colors.blue,
            ),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}