import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class ResultPage extends StatelessWidget {
  ResultPage({super.key});

  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final data = Get.arguments as Map;

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          TextField(
            controller: addressController,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                final address = addressController.text;
                getLocation(address);
              },
              child: Text('show'))
        ],
      )),
    );
  }

  Future<void> getLocation(final s) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Get.snackbar('Error', 'Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Get.snackbar('Error', 'Location permissions are denied');
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        Get.snackbar('Error',
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      final fromAddress = await locationFromAddress(s);
      print('${fromAddress.first.latitude}/${fromAddress.first.longitude}');

      // final position = await Geolocator.getCurrentPosition();
      // print('${position.latitude} --- ${position.longitude}');

      //
      // final uri =
      //     Uri.parse('geo:0,0?q=${position.latitude},${position.longitude}');
      // launchUrl(uri);

//Unexpected null value.
//       final addresses = await placemarkFromCoordinates(
//           position.longitude, position.longitude);
//       print('${addresses.first.name}');
    }
  }
}
