enum NotificationType {
  rental,
  payment,
  promotion,
  system,
  reminder,
  activity,
  emergency,
}

enum NotificationPriority { low, medium, high, urgent }

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final DateTime createdAt;
  final DateTime? readAt;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final String? actionUrl;
  final bool isActionable;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.createdAt,
    this.readAt,
    this.data,
    this.imageUrl,
    this.actionUrl,
    this.isActionable = false,
  });

  bool get isRead => readAt != null;
  bool get isUnread => readAt == null;

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    }
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final notificationDate = DateTime(
      createdAt.year,
      createdAt.month,
      createdAt.day,
    );

    if (notificationDate == today) {
      return 'Today ${_formatTime(createdAt)}';
    } else if (notificationDate == yesterday) {
      return 'Yesterday ${_formatTime(createdAt)}';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year} ${_formatTime(createdAt)}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    NotificationPriority? priority,
    DateTime? createdAt,
    DateTime? readAt,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
    bool? isActionable,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      data: data ?? this.data,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      isActionable: isActionable ?? this.isActionable,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.system,
      ),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => NotificationPriority.medium,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
      data: json['data'],
      imageUrl: json['imageUrl'],
      actionUrl: json['actionUrl'],
      isActionable: json['isActionable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.name,
      'priority': priority.name,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'data': data,
      'imageUrl': imageUrl,
      'actionUrl': actionUrl,
      'isActionable': isActionable,
    };
  }
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.rental:
        return 'Rental';
      case NotificationType.payment:
        return 'Payment';
      case NotificationType.promotion:
        return 'Promotion';
      case NotificationType.system:
        return 'System';
      case NotificationType.reminder:
        return 'Reminder';
      case NotificationType.activity:
        return 'Activity';
      case NotificationType.emergency:
        return 'Emergency';
    }
  }

  String get description {
    switch (this) {
      case NotificationType.rental:
        return 'Bike rental updates and status changes';
      case NotificationType.payment:
        return 'Payment confirmations and billing updates';
      case NotificationType.promotion:
        return 'Special offers and promotional content';
      case NotificationType.system:
        return 'System updates and maintenance notices';
      case NotificationType.reminder:
        return 'Important reminders and deadlines';
      case NotificationType.activity:
        return 'Cycling activities and event updates';
      case NotificationType.emergency:
        return 'Emergency alerts and safety notices';
    }
  }
}

extension NotificationPriorityExtension on NotificationPriority {
  String get displayName {
    switch (this) {
      case NotificationPriority.low:
        return 'Low';
      case NotificationPriority.medium:
        return 'Medium';
      case NotificationPriority.high:
        return 'High';
      case NotificationPriority.urgent:
        return 'Urgent';
    }
  }
}
