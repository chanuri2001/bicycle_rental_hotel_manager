import '../models/bike_model.dart';
import '../models/bike_type.dart';

class BikeData {
  static List<BikeModel> getAllBikes() {
    return [
      BikeModel(
        id: '1',
        name: 'Trek 520',
        brand: 'Mountain Bike',
        type: BikeType.mountain,
        location: 'Downtown Center',
        pricePerHour: 15.99,
        totalCount: 5,
        availableCount: 3,
        rentedCount: 2,
        imageUrl: 'assets/images/mountain_bike.png',
      ),
      BikeModel(
        id: '2',
        name: 'Specialized Allez',
        brand: 'Road Bike',
        type: BikeType.road,
        location: 'Park Center',
        pricePerHour: 18.99,
        totalCount: 4,
        availableCount: 2,
        rentedCount: 2,
        imageUrl: 'assets/images/road_bike.png',
      ),
      BikeModel(
        id: '3',
        name: 'Specialized Allez',
        brand: 'Road Bike',
        type: BikeType.road,
        location: 'Park Center',
        pricePerHour: 18.99,
        totalCount: 3,
        availableCount: 0,
        rentedCount: 3,
        imageUrl: 'assets/images/road_bike.png',
      ),
      BikeModel(
        id: '4',
        name: 'Kiross',
        brand: 'Road Bike',
        type: BikeType.road,
        location: 'City Center',
        pricePerHour: 25.99,
        totalCount: 6,
        availableCount: 4,
        rentedCount: 2,
        imageUrl: 'assets/images/road_bike_kiross.png',
      ),
      BikeModel(
        id: '5',
        name: 'GT Bike',
        brand: 'Road Bike',
        type: BikeType.road,
        location: 'Sports Complex',
        pricePerHour: 35.99,
        totalCount: 4,
        availableCount: 2,
        rentedCount: 2,
        imageUrl: 'assets/images/gt_bike.png',
      ),
      BikeModel(
        id: '6',
        name: 'Thunder X1',
        brand: 'Electric Bike',
        type: BikeType.electric,
        location: 'Tech Hub',
        pricePerHour: 45.99,
        totalCount: 3,
        availableCount: 1,
        rentedCount: 2,
        imageUrl: 'assets/images/electric_bike.png',
      ),
      BikeModel(
        id: '7',
        name: 'Urban Cruiser',
        brand: 'Hybrid Bike',
        type: BikeType.hybrid,
        location: 'Downtown Center',
        pricePerHour: 20.99,
        totalCount: 5,
        availableCount: 3,
        rentedCount: 2,
        imageUrl: 'assets/images/hybrid_bike.png',
      ),
    ];
  }

  static List<BikeModel> getAvailableBikes() {
    return getAllBikes().where((bike) => bike.isAvailable).toList();
  }

  static List<BikeModel> getBikesByLocation(String location) {
    return getAllBikes().where((bike) => bike.location == location).toList();
  }

  static List<String> getAllLocations() {
    return getAllBikes().map((bike) => bike.location).toSet().toList();
  }
}
