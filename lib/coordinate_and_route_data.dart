class LocationCoordinate {
  String name;
  double latitude;
  double longitude;

  LocationCoordinate(this.name, this.latitude, this.longitude);
}

class RouteData {
  final List<String> userRouteNames;
  final List<double> userRouteDistances;
  final double userRouteTotalDistance;
  final List<String> optimizedRouteNames;
  final List<double> optimizedRouteDistances;
  final double optimizedRouteTotalDistance;

  RouteData({
    required this.userRouteNames,
    required this.userRouteDistances,
    required this.userRouteTotalDistance,
    required this.optimizedRouteNames,
    required this.optimizedRouteDistances,
    required this.optimizedRouteTotalDistance,
  });
}
