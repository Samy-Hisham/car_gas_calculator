import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'car_type_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: false);
    super.initState();
    delay();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> delay() async {
    await Future.delayed(const Duration(seconds: 2));
    print('work');
    nextPage();
  }

  void nextPage() {
    Get.off(CarTypePage(), transition: Transition.leftToRight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 200.0, 0.0, 0.0),
              child: Image.asset(
                'assets/images/car_icon.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 200.0, 12, 0.0),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            child: LinearProgressIndicator(
              value: controller.value,
              minHeight: 5,
              backgroundColor: Colors.black12,
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      )),
    );
  }
}
