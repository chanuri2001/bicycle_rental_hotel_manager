class CyclingActivity {
  final String id;
  final String name;
  final String description;
  final String duration;
  final String difficulty;
  final double price;
  final String imageUrl;
  final List<String> availableDates;
  final String location;
  final int maxParticipants;
  final List<String> highlights;

  CyclingActivity({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.price,
    required this.imageUrl,
    required this.availableDates,
    required this.location,
    required this.maxParticipants,
    required this.highlights,
  });

  bool isAvailableOnDate(DateTime date) {
    String dateString =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return availableDates.contains(dateString) ||
        availableDates.contains('daily');
  }

  factory CyclingActivity.fromJson(Map<String, dynamic> json) {
    return CyclingActivity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      duration: json['duration'],
      difficulty: json['difficulty'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      availableDates: List<String>.from(json['availableDates']),
      location: json['location'],
      maxParticipants: json['maxParticipants'],
      highlights: List<String>.from(json['highlights']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'duration': duration,
      'difficulty': difficulty,
      'price': price,
      'imageUrl': imageUrl,
      'availableDates': availableDates,
      'location': location,
      'maxParticipants': maxParticipants,
      'highlights': highlights,
    };
  }
}
