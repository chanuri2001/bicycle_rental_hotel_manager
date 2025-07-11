enum BikeType {
  mountain,
  road,
  hybrid,
  electric,
  bmx,
}

extension BikeTypeExtension on BikeType {
  String get displayName {
    switch (this) {
      case BikeType.mountain:
        return 'Mountain Bike';
      case BikeType.road:
        return 'Road Bike';
      case BikeType.hybrid:
        return 'Hybrid Bike';
      case BikeType.electric:
        return 'Electric Bike';
      case BikeType.bmx:
        return 'BMX Bike';
    }
  }
}
