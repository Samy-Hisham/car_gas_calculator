import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'coordinate_and_route_data.dart';

class ResultPage extends StatefulWidget {
  final List<String> locations;
  final String carType;
  final String fuelType;

  ResultPage({
    required this.locations,
    required this.carType,
    required this.fuelType,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final RxList<double> distances = <double>[].obs;

  late double fuelConsumptionPerKm;

  late double fuelPricePerLiter;

  @override
  void initState() {
    super.initState();
    setupFuelAndCarData();
  }

  void setupFuelAndCarData() {
    switch (widget.carType) {
      case "Toyota":
        fuelConsumptionPerKm = 5.9 / 100;
        break;
      case "Hyundai":
        fuelConsumptionPerKm = 6.5 / 100;
        break;
      case "BMW":
        fuelConsumptionPerKm = 8.0 / 100;
        break;
      case "Mercedes":
        fuelConsumptionPerKm = 12.0 / 100;
        break;
      default:
        fuelConsumptionPerKm = 0.08; // Default
        break;
    }

    switch (widget.fuelType) {
      case "80":
        fuelPricePerLiter = 12.25;
        break;
      case "90":
        fuelPricePerLiter = 13.75;
        break;
      case "92":
        fuelPricePerLiter = 15.00;
        break;
      case "95":
        fuelPricePerLiter = 17.00;
        break;
      case "solar":
        fuelPricePerLiter = 11.50;
        break;
      case "gas":
        fuelPricePerLiter = 3.75;
        break;
      default:
        fuelPricePerLiter = 15.0; // Default
        break;
    }
  }

  // Method to calculate total route distance
  List<double> calculateDistances(List<LocationCoordinate> coordinates) {
    List<double> distances = [];
    for (var i = 0; i < coordinates.length - 1; i++) {
      double distance = Geolocator.distanceBetween(
            coordinates[i].latitude,
            coordinates[i].longitude,
            coordinates[i + 1].latitude,
            coordinates[i + 1].longitude,
          ) /
          1000; // Convert meters to kilometers
      distances.add(distance);
    }
    return distances;
  }

  double calculateTotalDistance(List<double> distances) {
    return distances.reduce((a, b) => a + b);
  }

  // Method to optimize the route by reordering locations based on proximity
  List<LocationCoordinate> calculateOptimalRoute(
      List<LocationCoordinate> coordinates) {
    List<LocationCoordinate> optimizedRoute = [];
    Set<LocationCoordinate> visited = {};

    LocationCoordinate currentLocation = coordinates.first;
    optimizedRoute.add(currentLocation);
    visited.add(currentLocation);

    while (visited.length < coordinates.length) {
      LocationCoordinate? nearestLocation;
      double shortestDistance = double.infinity;

      for (var location in coordinates) {
        if (!visited.contains(location)) {
          double distance = Geolocator.distanceBetween(
            currentLocation.latitude,
            currentLocation.longitude,
            location.latitude,
            location.longitude,
          );

          if (distance < shortestDistance) {
            shortestDistance = distance;
            nearestLocation = location;
          }
        }
      }

      currentLocation = nearestLocation!;
      optimizedRoute.add(currentLocation);
      visited.add(currentLocation);
    }

    return optimizedRoute;
  }

  Future<List<LocationCoordinate>> getCoordinates(
      List<String> locations) async {
    List<LocationCoordinate> coordinates = [];
    for (var location in locations) {
      var placemarks = await locationFromAddress(location);
      coordinates.add(LocationCoordinate(
          location, placemarks.first.latitude, placemarks.first.longitude));
    }
    return coordinates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade100,
        title: const Text('Route Suggestions'),
        centerTitle: true,
      ),
      body: Stack(children: [
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur effect
            child: Image.asset(
              'assets/images/background_3.jpeg', // Path to your background image
              fit: BoxFit.cover, // Cover the entire background
            ),
          ),
        ),
        FutureBuilder(
          future: calculateOptimalRouteAndCost(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final data = snapshot.data as RouteData;
              final userCostPerKm = fuelConsumptionPerKm * fuelPricePerLiter;
              final optimizedCostPerKm =
                  fuelConsumptionPerKm * fuelPricePerLiter;

              // Ensure the total cost and savings calculation
              double userTotalCost =
                  data.userRouteTotalDistance * userCostPerKm;
              double optimizedTotalCost =
                  data.optimizedRouteTotalDistance * optimizedCostPerKm;
              final savings = userTotalCost - optimizedTotalCost;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // User-entered route
                      buildRouteDetailsCard(
                        'Your Route:',
                        data.userRouteNames,
                        data.userRouteDistances,
                        data.userRouteTotalDistance,
                        userCostPerKm,
                      ),

                      const SizedBox(height: 20),

                      // Optimized route
                      buildRouteDetailsCard(
                        'Optimized Route:',
                        data.optimizedRouteNames,
                        data.optimizedRouteDistances,
                        data.optimizedRouteTotalDistance,
                        optimizedCostPerKm,
                      ),

                      const SizedBox(height: 20),

                      // Display the savings
                      if (savings > 0)
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.green.shade100,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Savings:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'By taking the optimized route, you will save ${savings.toStringAsFixed(2)} EGP',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ]),
    );
  }

  Widget buildRouteDetailsCard(
    String title,
    List<String> placeNames,
    List<double> distances,
    double totalDistance,
    double costPerKm,
  ) {
    double totalCost = totalDistance * costPerKm;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Display the order of places, distances, and costs between places
            for (var i = 0; i < placeNames.length - 1; i++) ...[
              Text(
                '${placeNames[i]} → ${placeNames[i + 1]}: ${distances[i].toStringAsFixed(2)} km, Cost: ${(distances[i] * costPerKm).toStringAsFixed(2)} EGP',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 5),
            ],

            const SizedBox(height: 10),

            // Display total distance and cost
            Text(
              'Total Distance: ${totalDistance.toStringAsFixed(2)} km',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Total Cost: ${totalCost.toStringAsFixed(2)} EGP',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Future<RouteData> calculateOptimalRouteAndCost() async {
    List<LocationCoordinate> coordinates =
        await getCoordinates(widget.locations);

    // User-entered route
    List<String> userRouteNames = coordinates.map((c) => c.name).toList();
    List<double> userRouteDistances = calculateDistances(coordinates);
    double userRouteTotalDistance = calculateTotalDistance(userRouteDistances);

    // Optimized route
    List<LocationCoordinate> optimalRoute = calculateOptimalRoute(coordinates);
    List<String> optimizedRouteNames = optimalRoute.map((c) => c.name).toList();
    List<double> optimizedRouteDistances = calculateDistances(optimalRoute);
    double optimizedRouteTotalDistance =
        calculateTotalDistance(optimizedRouteDistances);

    return RouteData(
      userRouteNames: userRouteNames,
      userRouteDistances: userRouteDistances,
      userRouteTotalDistance: userRouteTotalDistance,
      optimizedRouteNames: optimizedRouteNames,
      optimizedRouteDistances: optimizedRouteDistances,
      optimizedRouteTotalDistance: optimizedRouteTotalDistance,
    );
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

/*class LocationCoordinate {
  final String name;
  final double latitude;
  final double longitude;

  LocationCoordinate(this.name, this.latitude, this.longitude);
}

class RouteData {
  final double userRouteDistance;
  final double optimizedRouteDistance;

  RouteData(this.userRouteDistance, this.optimizedRouteDistance);
}*/
