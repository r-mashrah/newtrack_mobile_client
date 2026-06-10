import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/providers/api_client_provider.dart';

/// نموذج الحدث (Event) من السيرفر
class EventItem {
  final String id;
  final String type;
  final String message;
  final String deviceName;
  final DateTime timestamp;
  final bool isRead;

  EventItem({
    required this.id,
    required this.type,
    required this.message,
    required this.deviceName,
    required this.timestamp,
    this.isRead = false,
  });

  factory EventItem.fromGpswoxJson(Map<String, dynamic> json) {
    return EventItem(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? json['alert_type']?.toString() ?? 'info',
      message: json['message']?.toString() ?? json['description']?.toString() ?? '',
      deviceName: json['device_name']?.toString() ?? json['name']?.toString() ?? '',
      timestamp: DateTime.tryParse(json['time']?.toString() ?? json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

/// مزود للأحداث (Events) - يجلبها من السيرفر الحقيقي
class EventsNotifier extends StateNotifier<AsyncValue<List<EventItem>>> {
  final ApiClient _apiClient;

  EventsNotifier(this._apiClient) : super(const AsyncValue.loading()) {
    loadEvents();
  }

  Future<void> loadEvents() async {
    state = const AsyncValue.loading();
    try {
      final response = await _apiClient.get(
        ApiConstants.getEvents,
        queryParameters: {'lang': 'ar'},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        List<dynamic> itemsList = [];

        if (data is List) {
          itemsList = data;
        } else if (data is Map) {
          if (data.containsKey('items')) {
            final itemsField = data['items'];
            if (itemsField is List) {
              itemsList = itemsField;
            } else if (itemsField is Map && itemsField.containsKey('data')) {
              final dataField = itemsField['data'];
              if (dataField is List) {
                itemsList = dataField;
              }
            }
          } else if (data.containsKey('data')) {
            final dataField = data['data'];
            if (dataField is List) {
              itemsList = dataField;
            }
          }
        }

        final events = itemsList
            .map((json) {
              try {
                return EventItem.fromGpswoxJson(json as Map<String, dynamic>);
              } catch (e) {
                return null;
              }
            })
            .whereType<EventItem>()
            .toList();

        // ترتيب حسب الأحدث أولاً
        events.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        state = AsyncValue.data(events);
      } else {
        state = const AsyncValue.data([]);
      }
    } catch (e, st) {
      // إذا لم يكن الـ endpoint موجوداً نعرض قائمة فارغة
      state = const AsyncValue.data([]);
    }
  }
}

final eventsNotifierProvider = StateNotifierProvider<EventsNotifier, AsyncValue<List<EventItem>>>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EventsNotifier(apiClient);
});

/// ============ واجهة درج الإشعارات ============

class NotificationsDrawer extends ConsumerWidget {
  const NotificationsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsNotifierProvider);

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
            child: Row(
              children: [
                const Icon(Icons.notifications, color: Colors.white, size: 24),
                const SizedBox(width: 16),
                const Text(
                  'الإشعارات',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    ref.read(eventsNotifierProvider.notifier).loadEvents();
                  },
                  child: const Text(
                    'تحديث',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          // المحتوى
          Expanded(
            child: eventsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.grey[400], size: 48),
                    const SizedBox(height: 12),
                    const Text('فشل في تحميل الإشعارات'),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.read(eventsNotifierProvider.notifier).loadEvents(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
              data: (events) {
                if (events.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_outlined, color: Colors.grey[400], size: 48),
                        const SizedBox(height: 12),
                        Text('لا توجد إشعارات', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return _NotificationItem(
                      title: event.deviceName.isNotEmpty ? event.deviceName : event.type,
                      message: event.message,
                      type: event.type,
                      timestamp: event.timestamp,
                      isRead: event.isRead,
                      onTap: () {},
                    );
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
    final t = type.toLowerCase();
    if (t.contains('geofence') || t.contains('zone')) return Colors.purple;
    if (t.contains('speed') || t.contains('overspeed')) return Colors.red;
    if (t.contains('offline') || t.contains('connection')) return Colors.grey;
    if (t.contains('ignition') || t.contains('engine')) return Colors.green;
    if (t.contains('battery') || t.contains('power')) return Colors.orange;
    if (t.contains('sos') || t.contains('alarm')) return Colors.red;
    return Colors.blue;
  }

  IconData _getTypeIcon(String type) {
    final t = type.toLowerCase();
    if (t.contains('geofence') || t.contains('zone')) return Icons.map;
    if (t.contains('speed') || t.contains('overspeed')) return Icons.speed;
    if (t.contains('offline') || t.contains('connection')) return Icons.signal_wifi_off;
    if (t.contains('ignition') || t.contains('engine')) return Icons.power_settings_new;
    if (t.contains('battery') || t.contains('power')) return Icons.battery_alert;
    if (t.contains('sos') || t.contains('alarm')) return Icons.warning;
    return Icons.notifications;
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
