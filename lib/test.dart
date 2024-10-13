// 1
// Widget createTextFiled(TextEditingController controller) {
//   return TextField(
//     controller: controller,
//     onChanged: (v) {
//       handelText(v);
//     },
//     decoration: InputDecoration(hintText: 'add text'),
//   );
// }

// void handelText(String s) {
//   if (s.length > 3) {
//     print('current input ${s}');
//   }
//   // if (s.isNotEmpty) locati
//
//  onList.add(s);
// }

// --------------------------------------------

// ListView.builder(
// itemCount: locationList.length,
// itemBuilder: (ctr, index) => ListTile(
// title: Text(locationList[index]),
// )));

import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  Test({super.key});

  List<String> list = ['s', 'a', "s", 'a', 'c'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('${check(list)}'),
    );
  }

  List<dynamic> check(List<dynamic> list) {
    // Create a new list to store the result
    List<dynamic> result = [];

    for (int i = 0; i < list.length; i++) {
      // Check if the result list is empty or if the last element is different
      if (result.isEmpty || result.last != list[i]) {
        result.add(list[i]); // Add the current element to the result
      }
    }
    return result; // Return the modified list
  }
}
