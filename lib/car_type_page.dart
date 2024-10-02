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
  final feul = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
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
                enableSearch: true,
                enableFilter: true,
                requestFocusOnTap: true,
                hintText: 'select your car',
                leadingIcon: Icon(Icons.car_repair),
                controller: carController,
                onSelected: (value) {
                  car.value = value!;
                  // print('${car.value}');
                },
              ),
            );
          }),
          SizedBox(
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
              leadingIcon: Icon(Icons.local_gas_station_outlined),
              onSelected: (Value) {
                feul.value = Value!;
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () {
                // print('${car.value}');
                if (carValidation() && feulValidation()) {
                  Get.to(AreaName(),
                      arguments: {'type': car.value, 'feul': feul.value});
                  // print('${car.value}');
                }
              },
              child: Text('Next'))
        ],
      )),
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
    } else
      flag = true;

    return flag;
  }

  bool feulValidation() {
    var flag = false;
    if (feul.value.isEmpty) {
      Fluttertoast.showToast(
          msg: 'select feul',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
    } else
      flag = true;

    return flag;
  }
}
