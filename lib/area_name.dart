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
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Enter the areas',
                labelStyle: TextStyle(color: Colors.blue),
                hintText: 'exmaple: Maadi',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 5,
              ),
              child: Text('Add')),
          Expanded(child: Obx(() {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ListView.builder(
                  itemCount: locationList.length,
                  itemBuilder: (ctr, index) => Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ListTile(
                            title: Text(locationList[index]),
                            trailing: IconButton(
                              onPressed: () {
                                locationList.remove(locationList[index]);
                              },
                              icon: Icon(Icons.remove),
                              color: Colors.red,
                            )),
                      )),
            );
          })),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                Get.to(ResultPage(),
                    arguments: {'data': data, 'locations': locationList});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 5,
              ),
              child: Text('Next')),
          SizedBox(
            height: 10,
          )
        ],
      ),
    ));
  }
}
