class Rental {
  final String id;
  final String userId;
  final String bikeId;
  final DateTime startTime;
  final DateTime? endTime;
  final double? totalCost;
  final String status; // active, completed, cancelled

  Rental({
    required this.id,
    required this.userId,
    required this.bikeId,
    required this.startTime,
    this.endTime,
    this.totalCost,
    required this.status,
  });

  factory Rental.fromJson(Map<String, dynamic> json) {
    return Rental(
      id: json['id'],
      userId: json['userId'],
      bikeId: json['bikeId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      totalCost: json['totalCost']?.toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'bikeId': bikeId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'totalCost': totalCost,
      'status': status,
    };
  }
}