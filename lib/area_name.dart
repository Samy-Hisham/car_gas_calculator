import 'dart:ui';

import 'package:car_gas_calculator/result_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart'; // Reverse geocoding to get address
import 'package:geolocator/geolocator.dart'; // Location services
import 'package:get/get.dart';

class AreaName extends StatelessWidget {
  AreaName({super.key});

  final locationController = TextEditingController();
  var locationList = <String>[].obs;

  // Method to get the current location and translate it to a human-readable address
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
        msg: 'Location services are disabled. Please enable them.',
        backgroundColor: Colors.red,
      );
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
          msg: 'Location permission denied.',
          backgroundColor: Colors.red,
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
        msg:
            'Location permissions are permanently denied. Please enable them in settings.',
        backgroundColor: Colors.red,
      );
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Convert coordinates to a human-readable address (reverse geocoding)
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Get the first Placemark which contains the location details
    Placemark place = placemarks[0];
    String currentLocation = '${place.locality}';

    // Display the current location in the text field
    locationController.text = currentLocation;
  }

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments;
    final carType = data['type'] ?? 'Unknown Car Type';
    final fuelType = data['fuel'] ?? 'Unknown Fuel Type';

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter:
                  ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur effect
              child: Image.asset(
                'assets/images/background.jpeg', // Path to your background image
                fit: BoxFit.cover, // Cover the entire background
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: 'Enter the areas',
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: 'example: Maadi',
                      hintStyle: TextStyle(color: Colors.blueGrey),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan, width: 3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Button to get the current location
                ElevatedButton.icon(
                  onPressed: _getCurrentLocation,
                  icon: const Icon(Icons.my_location),
                  label: const Text('Get Current Location'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 5,
                  ),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    if (locationController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: 'Add location',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 14.0,
                      );
                    } else {
                      locationList.add(locationController.text);
                      locationController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 5,
                  ),
                  child: const Text('Add'),
                ),
                Expanded(
                  child: Obx(() {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: ReorderableListView(
                        onReorder: (int oldIndex, int newIndex) {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final item = locationList.removeAt(oldIndex);
                          locationList.insert(newIndex, item);
                        },
                        children: [
                          for (int index = 0;
                              index < locationList.length;
                              index++)
                            Card(
                              key: ValueKey(index),
                              // Unique key for each item
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.blue, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: ListTile(
                                title: Text(locationList[index]),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        locationList.removeAt(index);
                                      },
                                      icon: const Icon(Icons.remove),
                                      color: Colors.red,
                                    ),
                                    const Icon(Icons
                                        .drag_handle_sharp), // Reordering icon
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (locationList.isEmpty) {
                      Fluttertoast.showToast(
                        msg: 'Please add at least one location',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 14.0,
                      );
                    } else {
                      Get.to(
                        ResultPage(
                          locations: locationList,
                          carType: carType,
                          fuelType: fuelType,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 5,
                  ),
                  child: const Text('Next'),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
