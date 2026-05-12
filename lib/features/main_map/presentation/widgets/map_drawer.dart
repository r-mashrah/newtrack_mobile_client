import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/devices_provider.dart';
import '../../../../domain/entities/device_entity.dart';

class MapDrawer extends ConsumerStatefulWidget {
  const MapDrawer({Key? key}) : super(key: key);

  @override
  ConsumerState<MapDrawer> createState() => _MapDrawerState();
}

class _MapDrawerState extends ConsumerState<MapDrawer> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header with Tabs
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.primaryColor,
              indicatorWeight: 2,
              labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'الخيارات'),
                Tab(text: 'المجموعات'),
                Tab(text: 'الأجهزة'),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOptionsTab(),
                _buildGroupsTab(),
                _buildDevicesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevicesTab() {
    final devicesAsync = ref.watch(devicesNotifierProvider);
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            height: 40,
            child: TextField(
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'بحث',
                prefixIcon: const Icon(Icons.search, size: 18),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                fillColor: const Color(0xFFF5F5F5),
              ),
            ),
          ),
        ),
        Expanded(
          child: devicesAsync.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (devices, isRefreshing, filterQuery, statusFilter) {
              return ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: devices.length,
                separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF5F5F5)),
                itemBuilder: (context, index) => _buildDeviceItem(devices[index]),
              );
            },
            error: (err, stack) => Center(child: Text('خطأ: $err')),
          ),
        ),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildDeviceItem(DeviceEntity device) {
    final statusColor = AppTheme.getStatusColor(device.displayStatus);
    final isOnline = device.displayStatus != 'offline';
    
    return ListTile(
      dense: true,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.directions_car, color: statusColor, size: 20),
      ),
      title: Text(device.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      subtitle: Text(isOnline ? 'متصل' : 'غير متصل', style: TextStyle(color: isOnline ? Colors.green : Colors.red, fontSize: 11)),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
        onPressed: () => _showDeviceOptions(device),
      ),
      onTap: () => Navigator.pop(context),
    );
  }

  void _showDeviceOptions(DeviceEntity device) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(device.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildOptionItem(Icons.location_on_outlined, 'إظهار على الخريطة', () {}),
              _buildOptionItem(Icons.access_time, 'سجل اليوم', () {}),
              _buildOptionItem(Icons.edit_outlined, 'تعديل', () {}),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  Widget _buildGroupsTab() {
    return const Center(child: Text('قائمة المجموعات', style: TextStyle(fontSize: 13)));
  }

  Widget _buildOptionsTab() {
    final authState = ref.watch(authNotifierProvider);
    final email = authState.maybeWhen(authenticated: (user) => user.email, orElse: () => 'user@track.com');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(email, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
        const SizedBox(height: 20),
        _buildActionCard(Icons.add_circle_outline, 'إضافة جهاز جديد', () => context.push('/add-device')),
        _buildActionCard(Icons.history, 'السجل', () => context.push('/history')),
        _buildActionCard(Icons.build_outlined, 'الأدوات', () => context.push('/tools')),
        _buildActionCard(Icons.settings_outlined, 'الإعداد', () => context.push('/setup')),
        _buildActionCard(Icons.logout, 'تسجيل الخروج', () => ref.read(authNotifierProvider.notifier).logout()),
      ],
    );
  }

  Widget _buildActionCard(IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: AppTheme.primaryColor, size: 20),
        title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_left, size: 18, color: AppTheme.primaryColor),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
      ),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton.small(
          onPressed: () => context.push('/add-device'),
          backgroundColor: Colors.white,
          child: const Icon(Icons.add, color: AppTheme.primaryColor),
        ),
      ),
    );
  }
}
