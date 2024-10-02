import 'package:car_gas_calculator/result_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AreaName extends StatelessWidget {
  AreaName({super.key});

  final locationController = TextEditingController();

  var locationList = <String>[].obs;

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments;

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          TextField(
            controller: locationController,
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () {
                if (locationController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: 'add location',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 14.0);
                } else {
                  locationList.add(locationController.text);
                  locationController.clear();
                  // print('$locationList');
                }
              },
              child: Text('add')),
          Expanded(child: Obx(() {
            return ListView.builder(
                itemCount: locationList.length,
                itemBuilder: (ctr, index) => Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                          title: Text(locationList[index]),
                          trailing: IconButton(
                              onPressed: () {
                                locationList.remove(locationList[index]);
                              },
                              icon: Icon(Icons.remove))),
                    ));
          })),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                Get.to(ResultPage(),
                    arguments: {'data': data, 'locations': locationList});
              },
              child: Text('Next'))
        ],
      ),
    ));
  }
}
