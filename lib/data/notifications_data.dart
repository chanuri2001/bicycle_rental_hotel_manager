import '../models/notification_model.dart';

class NotificationsData {
  static List<NotificationModel> getAllNotifications() {
    return [
      NotificationModel(
        id: '1',
        title: 'Rental Confirmed',
        message: 'Your bike rental for Trek 520 Mountain Bike has been confirmed for today at 2:00 PM.',
        type: NotificationType.rental,
        priority: NotificationPriority.high,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        isActionable: true,
        actionUrl: '/rental/details/1',
        data: {
          'rentalId': 'R001',
          'bikeId': '1',
          'bikeName': 'Trek 520 Mountain Bike',
        },
      ),
      NotificationModel(
        id: '2',
        title: 'Payment Successful',
        message: 'Your payment of \$25.99 for the Morning City Tour has been processed successfully.',
        type: NotificationType.payment,
        priority: NotificationPriority.medium,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        readAt: DateTime.now().subtract(const Duration(minutes: 45)),
        data: {
          'paymentId': 'PAY001',
          'amount': 25.99,
          'activityId': '1',
        },
      ),
      NotificationModel(
        id: '3',
        title: '🎉 Special Weekend Offer!',
        message: 'Get 20% off on all bike rentals this weekend. Use code WEEKEND20 at checkout.',
        type: NotificationType.promotion,
        priority: NotificationPriority.medium,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isActionable: true,
        actionUrl: '/promotions/weekend20',
        data: {
          'promoCode': 'WEEKEND20',
          'discount': 20,
          'validUntil': '2024-01-21',
        },
      ),
      NotificationModel(
        id: '4',
        title: 'Rental Reminder',
        message: 'Don\'t forget! Your bike rental starts in 30 minutes. Location: Downtown Center.',
        type: NotificationType.reminder,
        priority: NotificationPriority.high,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        data: {
          'rentalId': 'R002',
          'location': 'Downtown Center',
          'startTime': '14:00',
        },
      ),
      NotificationModel(
        id: '5',
        title: 'New Activity Available',
        message: 'Beach Coastal Ride is now available for booking. Join us for a scenic 3-hour coastal adventure!',
        type: NotificationType.activity,
        priority: NotificationPriority.medium,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        readAt: DateTime.now().subtract(const Duration(hours: 4)),
        isActionable: true,
        actionUrl: '/activities/beach-coastal',
        data: {
          'activityId': '3',
          'activityName': 'Beach Coastal Ride',
          'duration': '3 hours',
        },
      ),
      NotificationModel(
        id: '6',
        title: 'System Maintenance',
        message: 'Scheduled maintenance will occur tonight from 2:00 AM to 4:00 AM. Some features may be temporarily unavailable.',
        type: NotificationType.system,
        priority: NotificationPriority.low,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        readAt: DateTime.now().subtract(const Duration(hours: 7)),
        data: {
          'maintenanceStart': '02:00',
          'maintenanceEnd': '04:00',
          'affectedServices': ['booking', 'payments'],
        },
      ),
      NotificationModel(
        id: '7',
        title: 'Rental Completed',
        message: 'Thank you for using our service! Your rental of Specialized Allez Road Bike has been completed.',
        type: NotificationType.rental,
        priority: NotificationPriority.medium,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        readAt: DateTime.now().subtract(const Duration(hours: 20)),
        isActionable: true,
        actionUrl: '/rental/feedback/7',
        data: {
          'rentalId': 'R003',
          'bikeId': '2',
          'duration': '2 hours',
          'totalCost': 37.98,
        },
      ),
      NotificationModel(
        id: '8',
        title: 'Emergency Alert',
        message: 'Weather alert: Heavy rain expected in your area. Please return your bike to the nearest station safely.',
        type: NotificationType.emergency,
        priority: NotificationPriority.urgent,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        readAt: DateTime.now().subtract(const Duration(days: 2)),
        data: {
          'alertType': 'weather',
          'severity': 'high',
          'area': 'downtown',
        },
      ),
      NotificationModel(
        id: '9',
        title: 'Profile Updated',
        message: 'Your profile information has been successfully updated.',
        type: NotificationType.system,
        priority: NotificationPriority.low,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        readAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      NotificationModel(
        id: '10',
        title: 'Welcome to BikeRental!',
        message: 'Welcome aboard! Explore our wide range of bikes and exciting cycling activities.',
        type: NotificationType.system,
        priority: NotificationPriority.medium,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        readAt: DateTime.now().subtract(const Duration(days: 6)),
        isActionable: true,
        actionUrl: '/onboarding/tour',
        data: {
          'isWelcome': true,
          'userId': 'user123',
        },
      ),
    ];
  }

  static List<NotificationModel> getUnreadNotifications() {
    return getAllNotifications().where((notification) => notification.isUnread).toList();
  }

  static List<NotificationModel> getNotificationsByType(NotificationType type) {
    return getAllNotifications().where((notification) => notification.type == type).toList();
  }

  static List<NotificationModel> getNotificationsByPriority(NotificationPriority priority) {
    return getAllNotifications().where((notification) => notification.priority == priority).toList();
  }

  static int getUnreadCount() {
    return getUnreadNotifications().length;
  }

  static Map<NotificationType, int> getNotificationCountsByType() {
    final notifications = getAllNotifications();
    final Map<NotificationType, int> counts = {};
    
    for (final type in NotificationType.values) {
      counts[type] = notifications.where((n) => n.type == type).length;
    }
    
    return counts;
  }

  static List<NotificationModel> getRecentNotifications({int limit = 5}) {
    final notifications = getAllNotifications();
    notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notifications.take(limit).toList();
  }
}
