import 'package:car_gas_calculator/area_name.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CarTypePage extends StatelessWidget {
  CarTypePage({super.key});

  final carsList =
      <String>['Bmw', 'Toyota', 'Honda', 'Mercedes', 'Hyundai'].obs;
  final fuelList =
      <String>['80', '90', '92', '95', 'Gas', 'Auto Electricity'].obs;

  final carController = TextEditingController();

  var car = ''.obs;
  final fuel = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownMenu<String>(
                  dropdownMenuEntries: carsList
                      .map((car) => DropdownMenuEntry(value: car, label: car))
                      .toList(),
                  width: double.infinity,
                  // inputDecorationTheme: const InputDecorationTheme(
                  //   border: OutlineInputBorder(
                  //     borderSide: BorderSide(color: Colors.blue),
                  //   ),
                  //   labelStyle: TextStyle(color: Colors.blue),
                  // ),
                  enableSearch: true,
                  enableFilter: true,
                  requestFocusOnTap: true,
                  hintText: 'select your car',
                  leadingIcon: const Icon(Icons.car_repair),
                  controller: carController,
                  onSelected: (value) {
                    car.value = value!;
                    // print('${car.value}');
                  },
                ),
              );
            }),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownMenu<String>(
                dropdownMenuEntries: fuelList
                    .map((fuel) => DropdownMenuEntry(value: fuel, label: fuel))
                    .toList(),
                width: double.infinity,
                enableSearch: true,
                enableFilter: true,
                requestFocusOnTap: true,
                hintText: 'select your fuel',
                leadingIcon: const Icon(Icons.local_gas_station_outlined),
                onSelected: (value) {
                  fuel.value = value!;
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  // print('${car.value}');
                  if (carValidation() && fuelValidation()) {
                    Get.to(AreaName(),
                        arguments: {'type': car.value, 'fuel': fuel.value});
                    // print('${car.value}');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 5,
                ),
                child: const Text('Next'))
          ],
        ),
      ),
    );
  }

  bool carValidation() {
    var flag = false;
    if (car.value.isEmpty) {
      Fluttertoast.showToast(
          msg: 'select car',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
    } else {
      flag = true;
    }
    return flag;
  }

  bool fuelValidation() {
    var flag = false;
    if (fuel.value.isEmpty) {
      Fluttertoast.showToast(
          msg: 'select fuel',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
    } else {
      flag = true;
    }
    return flag;
  }
}
