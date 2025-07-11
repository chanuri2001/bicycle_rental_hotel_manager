import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/notification_model.dart';
import '../data/notifications_data.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  List<NotificationModel> _notifications = [];
  List<NotificationModel> _filteredNotifications = [];
  NotificationType? _selectedFilter;
  bool _showUnreadOnly = false;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadNotifications();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadNotifications() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _notifications = NotificationsData.getAllNotifications();
          _applyFilters();
          _isLoading = false;
        });
      }
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredNotifications =
          _notifications.where((notification) {
            bool matchesType =
                _selectedFilter == null || notification.type == _selectedFilter;
            bool matchesReadStatus = !_showUnreadOnly || notification.isUnread;
            return matchesType && matchesReadStatus;
          }).toList();

      // Sort by creation date (newest first)
      _filteredNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  void _markAsRead(NotificationModel notification) {
    if (notification.isUnread) {
      setState(() {
        final index = _notifications.indexWhere((n) => n.id == notification.id);
        if (index != -1) {
          _notifications[index] = notification.copyWith(readAt: DateTime.now());
          _applyFilters();
        }
      });

      HapticFeedback.lightImpact();
    }
  }

  void _markAllAsRead() {
    setState(() {
      _notifications =
          _notifications.map((notification) {
            return notification.isUnread
                ? notification.copyWith(readAt: DateTime.now())
                : notification;
          }).toList();
      _applyFilters();
    });

    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteNotification(NotificationModel notification) {
    setState(() {
      _notifications.removeWhere((n) => n.id == notification.id);
      _applyFilters();
    });

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification deleted'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _notifications.add(notification);
              _applyFilters();
            });
          },
        ),
      ),
    );
  }

  void _handleNotificationTap(NotificationModel notification) {
    _markAsRead(notification);

    if (notification.isActionable && notification.actionUrl != null) {
      // Handle navigation to specific screen
      print('Navigate to: ${notification.actionUrl}');
      // Navigator.pushNamed(context, notification.actionUrl!);
    }

    _showNotificationDetails(notification);
  }

  void _showNotificationDetails(NotificationModel notification) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Notification header
                Row(
                  children: [
                    _getNotificationIcon(
                      notification.type,
                      notification.priority,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            notification.formattedDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildPriorityBadge(notification.priority),
                  ],
                ),

                const SizedBox(height: 16),

                // Notification message
                Text(
                  notification.message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                // Action buttons
                if (notification.isActionable) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Handle action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Take Action',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => n.isUnread).length;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (unreadCount > 0)
              Text(
                '$unreadCount unread',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  _showNotificationSettings();
                  break;
                case 'clear_all':
                  _showClearAllDialog();
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings, size: 20),
                        SizedBox(width: 12),
                        Text('Notification Settings'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'clear_all',
                    child: Row(
                      children: [
                        Icon(Icons.clear_all, size: 20),
                        SizedBox(width: 12),
                        Text('Clear All'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // Filter Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                  ),
                ),
                child: Column(
                  children: [
                    // Filter chips
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildFilterChip('All', null),
                          const SizedBox(width: 8),
                          ...NotificationType.values.map(
                            (type) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: _buildFilterChip(type.displayName, type),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Unread toggle
                    Row(
                      children: [
                        Switch(
                          value: _showUnreadOnly,
                          onChanged: (value) {
                            setState(() {
                              _showUnreadOnly = value;
                            });
                            _applyFilters();
                          },
                          activeColor: const Color(0xFF4CAF50),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Show unread only',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const Spacer(),
                        Text(
                          '${_filteredNotifications.length} notifications',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Notifications List
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF4CAF50),
                            ),
                          )
                          : _filteredNotifications.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredNotifications.length,
                            itemBuilder: (context, index) {
                              final notification =
                                  _filteredNotifications[index];
                              return _buildNotificationCard(
                                notification,
                                index,
                              );
                            },
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, NotificationType? type) {
    final isSelected = _selectedFilter == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = isSelected ? null : type;
        });
        _applyFilters();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFF4CAF50)
                  : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected
                    ? const Color(0xFF4CAF50)
                    : Colors.white.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification, int index) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 24),
      ),
      onDismissed: (direction) {
        _deleteNotification(notification);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: notification.isUnread ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                notification.isUnread
                    ? const Color(0xFF4CAF50).withOpacity(0.3)
                    : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => _handleNotificationTap(notification),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification icon
                _getNotificationIcon(notification.type, notification.priority),
                const SizedBox(width: 12),

                // Notification content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    notification.isUnread
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (notification.isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4CAF50),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            notification.timeAgo,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildTypeBadge(notification.type),
                          const Spacer(),
                          if (notification.priority ==
                                  NotificationPriority.urgent ||
                              notification.priority ==
                                  NotificationPriority.high)
                            _buildPriorityBadge(notification.priority),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getNotificationIcon(
    NotificationType type,
    NotificationPriority priority,
  ) {
    IconData iconData;
    Color backgroundColor;
    Color iconColor = Colors.white;

    switch (type) {
      case NotificationType.rental:
        iconData = Icons.directions_bike;
        backgroundColor = const Color(0xFF2196F3);
        break;
      case NotificationType.payment:
        iconData = Icons.payment;
        backgroundColor = const Color(0xFF4CAF50);
        break;
      case NotificationType.promotion:
        iconData = Icons.local_offer;
        backgroundColor = const Color(0xFFFF9800);
        break;
      case NotificationType.system:
        iconData = Icons.settings;
        backgroundColor = const Color(0xFF9E9E9E);
        break;
      case NotificationType.reminder:
        iconData = Icons.alarm;
        backgroundColor = const Color(0xFFE91E63);
        break;
      case NotificationType.activity:
        iconData = Icons.event;
        backgroundColor = const Color(0xFF9C27B0);
        break;
      case NotificationType.emergency:
        iconData = Icons.warning;
        backgroundColor = const Color(0xFFF44336);
        break;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(iconData, color: iconColor, size: 20),
    );
  }

  Widget _buildTypeBadge(NotificationType type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        type.displayName,
        style: TextStyle(
          fontSize: 10,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(NotificationPriority priority) {
    Color color;
    switch (priority) {
      case NotificationPriority.urgent:
        color = Colors.red;
        break;
      case NotificationPriority.high:
        color = Colors.orange;
        break;
      case NotificationPriority.medium:
        color = Colors.blue;
        break;
      case NotificationPriority.low:
        color = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        priority.displayName,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _showUnreadOnly ? Icons.mark_email_read : Icons.notifications_none,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _showUnreadOnly
                ? 'No unread notifications'
                : 'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _showUnreadOnly
                ? 'All caught up! Check back later for updates.'
                : 'We\'ll notify you when something important happens.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notification Settings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ...NotificationType.values.map(
                  (type) => CheckboxListTile(
                    title: Text(type.displayName),
                    subtitle: Text(type.description),
                    value: true, // This would come from user preferences
                    onChanged: (value) {
                      // Handle notification type toggle
                    },
                    activeColor: const Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Clear All Notifications'),
            content: const Text(
              'Are you sure you want to clear all notifications? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _notifications.clear();
                    _applyFilters();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All notifications cleared'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
