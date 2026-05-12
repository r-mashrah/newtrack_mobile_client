import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/map_controller_provider.dart';
import '../widgets/map_view.dart';
import '../widgets/map_drawer.dart';
import '../widgets/notifications_drawer.dart';
import '../widgets/map_settings_bottom_sheet.dart';
import '../providers/devices_provider.dart';

class MainMapScreen extends ConsumerStatefulWidget {
  const MainMapScreen({Key? key}) : super(key: key);

  static const routeName = '/main-map';

  @override
  ConsumerState<MainMapScreen> createState() => _MainMapScreenState();
}

class _MainMapScreenState extends ConsumerState<MainMapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(devicesNotifierProvider.notifier).loadDevices();
    });
  }

  void _openLeftDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _openRightDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _handleAddDevice() {
    context.push('/add-device');
  }

  void _handleSearch() {
    showSearch(context: context, delegate: DeviceSearchDelegate());
  }

  void _showMapSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MapSettingsBottomSheet(),
    );
  }

  // ignore: unused_element
  void _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد تسجيل الخروج'),
        content: const Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      ref.read(authNotifierProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // الخريطة تغطي كامل الشاشة
          const MapView(),

          // زر القائمة (Drawer) العلوي الأيمن (أو الأيسر حسب اللغة)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: _buildFloatingButton(
              icon: Icons.menu,
              onPressed: _openLeftDrawer,
              colorScheme: colorScheme,
            ),
          ),

          // زر التنبيهات العلوي الأيسر (أو الأيمن حسب اللغة)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: Stack(
              children: [
                _buildFloatingButton(
                  icon: Icons.notifications_none,
                  onPressed: _openRightDrawer,
                  colorScheme: colorScheme,
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // أزرار التحكم بالخريطة في الأسفل - تم نقلها لليمين لتناسب تصميم الصور
          Positioned(
            bottom: 38,
            right: 16,
            child: Column(
              children: [
                _buildFloatingButton(
                  icon: Icons.add,
                  onPressed: () {
                    ref.read(mapControllerProvider.notifier).zoomIn();
                  },
                  colorScheme: colorScheme,
                  mini: true,
                ),
                const SizedBox(height: 8),
                _buildFloatingButton(
                  icon: Icons.remove,
                  onPressed: () {
                    ref.read(mapControllerProvider.notifier).zoomOut();
                  },
                  colorScheme: colorScheme,
                  mini: true,
                ),
                const SizedBox(height: 8),
                _buildFloatingButton(
                  icon: Icons.layers_outlined,
                  onPressed: _showMapSettings,
                  colorScheme: colorScheme,
                  mini: true,
                ),
              ],
            ),
          ),
        ],
      ),
      // في حالة RTL، الـ drawer يظهر من اليمين تلقائياً عند استخدام drawer
      drawer: const MapDrawer(),
      endDrawer: const NotificationsDrawer(),
    );
  }

  Widget _buildFloatingButton({
    required IconData icon,
    required VoidCallback onPressed,
    required ColorScheme colorScheme,
    bool mini = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.blueGrey[800]),
        onPressed: onPressed,
        iconSize: mini ? 20 : 24,
        constraints: mini
            ? const BoxConstraints(minWidth: 40, minHeight: 40)
            : const BoxConstraints(minWidth: 48, minHeight: 48),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    // final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10)),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class DeviceSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final devicesAsync = ref.watch(devicesNotifierProvider);

        return devicesAsync.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (devices, isRefreshing, filterQuery, statusFilter) {
            final filteredDevices = devices.where((device) {
              return device.name.toLowerCase().contains(query.toLowerCase()) ||
                  device.plateNumber?.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ==
                      true;
            }).toList();

            return ListView.builder(
              itemCount: filteredDevices.length,
              itemBuilder: (context, index) {
                final device = filteredDevices[index];
                return ListTile(
                  leading: Icon(
                    Icons.directions_car,
                    color: _getStatusColor(device.displayStatus),
                  ),
                  title: Text(device.name),
                  subtitle: Text(device.plateNumber ?? device.imei),
                  trailing: _buildStatusIcon(device.displayStatus),
                  onTap: () {
                    close(context, device);
                  },
                );
              },
            );
          },
          error: (message, previousDevices) =>
              Center(child: Text('خطأ: $message')),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text('ابحث عن جهاز بالاسم أو رقم اللوحة'));
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'moving':
        return Colors.green;
      case 'stopped':
        return Colors.orange;
      case 'offline':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatusIcon(String status) {
    switch (status) {
      case 'moving':
        return const Icon(Icons.circle, color: Colors.green, size: 12);
      case 'stopped':
        return const Icon(Icons.circle, color: Colors.orange, size: 12);
      case 'offline':
        return const Icon(Icons.circle, color: Colors.red, size: 12);
      default:
        return const Icon(Icons.circle, color: Colors.grey, size: 12);
    }
  }
}
