import 'bike_type.dart';

class BikeModel {
  final String id;
  final String name;
  final String brand;
  final BikeType type;
  final String location;
  final double pricePerHour;
  final int totalCount;
  final int availableCount;
  final int rentedCount;
  final String? imageUrl;
  final bool isAvailable;

  BikeModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.type,
    required this.location,
    required this.pricePerHour,
    required this.totalCount,
    required this.availableCount,
    required this.rentedCount,
    this.imageUrl,
  }) : isAvailable = availableCount > 0;

  String get fullName => '$brand $name';
  
  factory BikeModel.fromJson(Map<String, dynamic> json) {
    return BikeModel(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      type: BikeType.values.firstWhere((e) => e.name == json['type']),
      location: json['location'],
      pricePerHour: json['pricePerHour'].toDouble(),
      totalCount: json['totalCount'],
      availableCount: json['availableCount'],
      rentedCount: json['rentedCount'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'type': type.name,
      'location': location,
      'pricePerHour': pricePerHour,
      'totalCount': totalCount,
      'availableCount': availableCount,
      'rentedCount': rentedCount,
      'imageUrl': imageUrl,
    };
  }
}
