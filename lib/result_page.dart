import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class ResultPage extends StatefulWidget {
  ResultPage({super.key});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final RxList<double> distances = <double>[].obs;
  bool isLoading = true; // To track loading state

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    final locationsList = arguments['locations'] ?? [];

    if (locationsList.isNotEmpty) {
      calculateDistances(locationsList).then((_) {
        setState(() {
          isLoading = false; // Stop loading after calculation
        });
      });
    } else {
      setState(() {
        isLoading = false; // No locations, stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;

    final carType = arguments['data']['type'] ?? 'Unknown Car Type';
    final fuelType = arguments['data']['fuel'] ?? 'Unknown Fuel Type';
    final locationsList = arguments['locations'] ?? [];
    final newLocationList = validateList(locationsList);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Distance Calculation'),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(), // Show loader while calculating
              )
            : Column(
                children: [
                  Expanded(
                    child: newLocationList.isNotEmpty && distances.isNotEmpty
                        ? Obx(
                            () {
                              return ListView.builder(
                                itemCount: distances.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      'Distance between ${newLocationList[index]} and ${newLocationList[index + 1]}:'
                                      ' ${distances[index].toStringAsFixed(2)} km',
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : const Center(
                            child: Text('No locations provided.'),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    if (distances.isNotEmpty) {
                      final totalDistance = distances.reduce((a, b) => a + b);
                      return Text(
                        'Total Distance: ${totalDistance.toStringAsFixed(2)} km',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
      ),
    );
  }

  Future<void> calculateDistances(List<String> locations) async {
    distances.clear();
    for (var i = 0; i < locations.length - 1; i++) {
      final startAddress = locations[i];
      final endAddress = locations[i + 1];

      try {
        // Get the coordinates of both locations
        List<Location> startPlacemark = await locationFromAddress(startAddress);
        List<Location> endPlacemark = await locationFromAddress(endAddress);

        double startLatitude = startPlacemark.first.latitude;
        double startLongitude = startPlacemark.first.longitude;
        double endLatitude = endPlacemark.first.latitude;
        double endLongitude = endPlacemark.first.longitude;

        // Calculate the distance between two locations
        double distanceInMeters = Geolocator.distanceBetween(
          startLatitude,
          startLongitude,
          endLatitude,
          endLongitude,
        );
        double distanceInKilometers = distanceInMeters / 1000;

        distances.add(distanceInKilometers);
      } catch (e) {
        // Handle errors like address not found
        Get.snackbar('Error',
            'Failed to calculate distance for $startAddress and $endAddress');
      }
    }
  }

  List<String> validateList(List<String> locationsList) {
    List<String> result = [];

    for (int i = 0; i < locationsList.length; i++) {
      // Check if the result list is empty or if the last element is different
      if (result.isEmpty || result.last != locationsList[i]) {
        result.add(locationsList[i]); // Add the current element to the result
      }
    }
    return result; // Return the modified list
  }
}
