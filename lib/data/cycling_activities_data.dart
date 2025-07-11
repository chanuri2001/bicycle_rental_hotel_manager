import '../models/cycling_activity.dart';

class CyclingActivitiesData {
  static List<CyclingActivity> getAllActivities() {
    return [
      CyclingActivity(
        id: '1',
        name: 'Morning City Tour',
        description: '2-hour guided tour through downtown',
        duration: '2 hours',
        difficulty: 'Easy',
        price: 25.99,
        imageUrl: 'city_tour',
        availableDates: ['daily'],
        location: 'Downtown Center',
        maxParticipants: 15,
        highlights: ['Historic landmarks', 'Local cafes', 'City parks', 'Photo stops'],
      ),
      CyclingActivity(
        id: '2',
        name: 'Park Trail Ride',
        description: 'Scenic 1-hour ride through Central Park',
        duration: '1 hour',
        difficulty: 'Easy',
        price: 18.99,
        imageUrl: 'park_trail',
        availableDates: ['daily'],
        location: 'Central Park',
        maxParticipants: 12,
        highlights: ['Nature trails', 'Wildlife spotting', 'Peaceful scenery', 'Fresh air'],
      ),
      CyclingActivity(
        id: '3',
        name: 'Beach Coastal Ride',
        description: '3-hour coastal adventure',
        duration: '3 hours',
        difficulty: 'Moderate',
        price: 35.99,
        imageUrl: 'beach_coastal',
        availableDates: ['daily'],
        location: 'Coastal Highway',
        maxParticipants: 10,
        highlights: ['Ocean views', 'Beach stops', 'Lighthouse visit', 'Seafood lunch'],
      ),
      CyclingActivity(
        id: '4',
        name: 'Mountain Adventure',
        description: '4-hour challenging mountain trail',
        duration: '4 hours',
        difficulty: 'Hard',
        price: 45.99,
        imageUrl: 'mountain_trail',
        availableDates: ['2024-01-15', '2024-01-16', '2024-01-20', '2024-01-22'],
        location: 'Mountain Ridge',
        maxParticipants: 8,
        highlights: ['Mountain peaks', 'Challenging terrain', 'Panoramic views', 'Adventure'],
      ),
      CyclingActivity(
        id: '5',
        name: 'Sunset Evening Ride',
        description: '2-hour romantic evening cycling',
        duration: '2 hours',
        difficulty: 'Easy',
        price: 28.99,
        imageUrl: 'sunset_ride',
        availableDates: ['daily'],
        location: 'Riverside Path',
        maxParticipants: 20,
        highlights: ['Golden hour', 'Romantic atmosphere', 'River views', 'Photography'],
      ),
      CyclingActivity(
        id: '6',
        name: 'Historic Heritage Tour',
        description: '3-hour cultural and historic exploration',
        duration: '3 hours',
        difficulty: 'Easy',
        price: 32.99,
        imageUrl: 'heritage_tour',
        availableDates: ['2024-01-14', '2024-01-17', '2024-01-19', '2024-01-21'],
        location: 'Old Town',
        maxParticipants: 15,
        highlights: ['Historic sites', 'Cultural stories', 'Architecture', 'Local guides'],
      ),
    ];
  }

  static List<CyclingActivity> getActivitiesForDate(DateTime date) {
    return getAllActivities().where((activity) => activity.isAvailableOnDate(date)).toList();
  }

  static List<String> getDifficultyLevels() {
    return ['All', 'Easy', 'Moderate', 'Hard'];
  }
}
