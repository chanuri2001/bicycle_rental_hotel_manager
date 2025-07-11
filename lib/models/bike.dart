class Bike {
  final String id;
  final String name;
  final String type;
  final bool isAvailable;
  final double pricePerHour;
  final String? imageUrl;
  final String location;

  Bike({
    required this.id,
    required this.name,
    required this.type,
    required this.isAvailable,
    required this.pricePerHour,
    this.imageUrl,
    required this.location,
  });

  factory Bike.fromJson(Map<String, dynamic> json) {
    return Bike(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      isAvailable: json['isAvailable'],
      pricePerHour: json['pricePerHour'].toDouble(),
      imageUrl: json['imageUrl'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'isAvailable': isAvailable,
      'pricePerHour': pricePerHour,
      'imageUrl': imageUrl,
      'location': location,
    };
  }
}