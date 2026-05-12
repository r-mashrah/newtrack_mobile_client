import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsDrawer extends StatelessWidget {
  const NotificationsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // بيانات وهمية للإشعارات
    final notifications = [
      {
        'id': '1',
        'title': 'دخول منطقة محظورة',
        'message': 'الجهاز Toyota Camry دخل منطقة محظورة في الساعة 2:30 م',
        'type': 'geofence',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
        'isRead': false,
      },
      {
        'id': '2',
        'title': 'تجاوز السرعة',
        'message': 'الجهاز Honda Civic تجاوز السرعة المحددة (120 كم/س)',
        'type': 'overspeed',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
        'isRead': false,
      },
      {
        'id': '3',
        'title': 'انقطاع الاتصال',
        'message': 'فقدنا الاتصال بالجهاز Ford Ranger منذ 30 دقيقة',
        'type': 'offline',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
        'isRead': true,
      },
      {
        'id': '4',
        'title': 'تشغيل المحرك',
        'message': 'تم تشغيل محرك Nissan Patrol',
        'type': 'ignition',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
        'isRead': true,
      },
      {
        'id': '5',
        'title': 'انخفاض البطارية',
        'message': 'بطارية Hyundai Elantra منخفضة (20%)',
        'type': 'battery',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'isRead': true,
      },
    ];

    return Drawer(
      child: Column(
        children: [
          // رأس القائمة
          Container(
            padding: const EdgeInsets.only(
              top: 40,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            //          color: colorScheme.primary,
            child: Row(
              children: [
                const Icon(Icons.notifications, color: Colors.white, size: 24),
                const SizedBox(width: 16),
                const Text(
                  'الإشعارات',
                  style: TextStyle(
                    // color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // مسح جميع الإشعارات
                  },
                  child: const Text(
                    'مسح الكل',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          // عدد الإشعارات غير المقروءة
          Container(
            padding: const EdgeInsets.all(16),
            // color: Colors.grey[100],
            child: Row(
              children: [
                const Icon(Icons.markunread, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  '${notifications.where((n) => !(n['isRead'] as bool)).length} إشعارات غير مقروءة',
                  // style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          // قائمة الإشعارات
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationItem(
                  title: notification['title'] as String,
                  message: notification['message'] as String,
                  type: notification['type'] as String,
                  timestamp: notification['timestamp'] as DateTime,
                  isRead: notification['isRead'] as bool,
                  onTap: () {
                    // معالجة النقر على الإشعار
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String type;
  final DateTime timestamp;
  final bool isRead;
  final VoidCallback onTap;

  const _NotificationItem({
    Key? key,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colorScheme.primary)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // أيقونة الإشعار
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getTypeColor(type).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getTypeIcon(type),
                color: _getTypeColor(type),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // محتوى الإشعار
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: isRead
                                ? FontWeight.normal
                                : FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTime(timestamp),
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'geofence':
        return Colors.purple;
      case 'overspeed':
        return Colors.red;
      case 'offline':
        return Colors.grey;
      case 'ignition':
        return Colors.green;
      case 'battery':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'geofence':
        return Icons.map;
      case 'overspeed':
        return Icons.speed;
      case 'offline':
        return Icons.signal_wifi_off;
      case 'ignition':
        return Icons.power_settings_new;
      case 'battery':
        return Icons.battery_alert;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return DateFormat('yyyy-MM-dd HH:mm').format(time);
    }
  }
}
