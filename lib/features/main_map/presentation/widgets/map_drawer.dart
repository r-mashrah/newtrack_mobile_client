import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../setup/presentation/providers/setup_provider.dart';
import '../providers/devices_provider.dart';
import '../providers/map_controller_provider.dart';
import '../../../../domain/entities/device_entity.dart';
import '../../../../generated/l10n/app_localizations.dart';


class MapDrawer extends ConsumerStatefulWidget {
  const MapDrawer({Key? key}) : super(key: key);

  @override
  ConsumerState<MapDrawer> createState() => _MapDrawerState();
}

class _MapDrawerState extends ConsumerState<MapDrawer> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _deviceSearch = '';

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

  // ── Device status helpers ──
  Color _getDeviceEdgeColor(DeviceEntity device) {
    if (!device.isOnline) return Colors.red;
    if (device.speed != null && device.speed! > 0) return Colors.blue;
    if (device.displayStatus == 'idle') return Colors.yellow.shade700;
    return Colors.green;
  }

  String _getDeviceStatusLabel(DeviceEntity device, BuildContext context) {
    if (!device.isOnline) return AppLocalizations.of(context)!.offlineStatus;
    if (device.speed != null && device.speed! > 0) return AppLocalizations.of(context)!.movingStatus;
    if (device.displayStatus == 'idle') return AppLocalizations.of(context)!.idleStatus;
    return AppLocalizations.of(context)!.onlineStatus;
  }

  String _formatTime(DateTime? time, BuildContext context) {
    if (time == null) return AppLocalizations.of(context)!.notAvailable;
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return AppLocalizations.of(context)!.justNow;
    if (diff.inHours < 1) return AppLocalizations.of(context)!.minutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return AppLocalizations.of(context)!.hoursAgo(diff.inHours);
    return AppLocalizations.of(context)!.daysAgo(diff.inDays);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      backgroundColor: Colors.white,
      child: Column(
        children: [
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
              tabs: [
                Tab(text: AppLocalizations.of(context)!.optionsTab),
                Tab(text: AppLocalizations.of(context)!.groupsTab),
                Tab(text: AppLocalizations.of(context)!.devicesTab),
              ],
            ),
          ),
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

  // ════════════════════════════════════════════════════════
  // ── Devices Tab (NEW DESIGN)
  // ════════════════════════════════════════════════════════

  Widget _buildDevicesTab() {
    final devicesState = ref.watch(devicesNotifierProvider);
    final allDevices = devicesState.devices ?? [];

    final totalCount = allDevices.length;
    final onlineCount = allDevices.where((d) => d.isOnline).length;
    final offlineCount = totalCount - onlineCount;

    // Filter by search
    final filtered = _deviceSearch.isEmpty
        ? allDevices
        : allDevices.where((d) =>
            d.name.toLowerCase().contains(_deviceSearch.toLowerCase()) ||
            (d.plateNumber?.toLowerCase().contains(_deviceSearch.toLowerCase()) ?? false) ||
            d.imei.toLowerCase().contains(_deviceSearch.toLowerCase())).toList();

    return Column(
      children: [
        // Quick Stats
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          color: Colors.grey.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _statDot(AppLocalizations.of(context)!.quickStatsTotal(totalCount), Colors.black54),
              _statDot(AppLocalizations.of(context)!.quickStatsOnline(onlineCount), Colors.green),
              _statDot(AppLocalizations.of(context)!.quickStatsOffline(offlineCount), Colors.red),
            ],
          ),
        ),
        // Search
        Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: 38,
            child: TextField(
              onChanged: (v) => setState(() => _deviceSearch = v),
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchDeviceHint,
                hintStyle: const TextStyle(fontSize: 12),
                prefixIcon: const Icon(Icons.search, size: 18),
                contentPadding: EdgeInsets.zero,
                fillColor: const Color(0xFFF5F5F5),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
        // Device List
        Expanded(
          child: devicesState.when(
            initial: () => _shimmerList(),
            loading: () => _shimmerList(),
            loaded: (_, __, ___, ____) {
              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.devices_other, size: 48, color: Colors.grey.shade300),
                      const SizedBox(height: 8),
                      Text(_deviceSearch.isNotEmpty ? AppLocalizations.of(context)!.noResults : AppLocalizations.of(context)!.noDevices,
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: filtered.length,
                itemBuilder: (context, index) => _buildDeviceCard(filtered[index]),
              );
            },
            error: (err, prev) {
              final list = prev ?? [];
              if (list.isNotEmpty) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: list.length,
                  itemBuilder: (context, i) => _buildDeviceCard(list[i]),
                );
              }
              return Center(child: Text('خطأ: $err', style: const TextStyle(color: Colors.red, fontSize: 12)));
            },
          ),
        ),
        // Bottom buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/devices');
                  },
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: Text(AppLocalizations.of(context)!.viewAll, style: const TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton.small(
                heroTag: 'add_device_drawer',
                onPressed: () {
                  Navigator.pop(context);
                  context.push('/add-device');
                },
                backgroundColor: AppTheme.primaryColor,
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceCard(DeviceEntity device) {
    final edgeColor = _getDeviceEdgeColor(device);
    final isOnline = device.isOnline;
    final shouldPulse = isOnline && (device.speed ?? 0) > 0;

    return Slidable(
      key: ValueKey('drawer_${device.id}'),
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
              final latLng = LatLng(device.lastLocation.latitude, device.lastLocation.longitude);
              ref.read(mapControllerProvider.notifier).animateTo(latLng);
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.map_outlined,
            label: AppLocalizations.of(context)!.mapLabel,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
              context.push('/history');
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.history,
            label: AppLocalizations.of(context)!.historyLabel,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 6),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            final latLng = LatLng(device.lastLocation.latitude, device.lastLocation.longitude);
            ref.read(mapControllerProvider.notifier).animateTo(latLng);
          },
          onLongPress: () {
            HapticFeedback.lightImpact();
            _showDeviceOptions(device);
          },
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: edgeColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + status
                        Row(
                          children: [
                            if (shouldPulse)
                              _PulseWidget(color: edgeColor)
                            else
                              Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(color: edgeColor, shape: BoxShape.circle),
                              ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(device.name,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: edgeColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(_getDeviceStatusLabel(device, context),
                                  style: TextStyle(fontSize: 9, color: edgeColor, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Last update
                        Text(
                          _formatTime(device.lastUpdate, context),
                          style: TextStyle(fontSize: 10, color: isOnline ? Colors.grey : Colors.red.shade300),
                        ),
                        const SizedBox(height: 6),
                        // Quick info + actions
                        Row(
                          children: [
                            _miniInfo(Icons.speed, device.speed != null ? '${device.speed!.toStringAsFixed(0)} ${AppLocalizations.of(context)!.kmh}' : '--'),
                            const SizedBox(width: 8),
                            _miniInfo(Icons.battery_charging_full, device.batteryLevel != null ? '${device.batteryLevel!.toStringAsFixed(0)}%' : '--'),
                            const Spacer(),
                            InkWell(
                              onTap: () => _showDeviceOptions(device),
                              child: const Icon(Icons.more_horiz, size: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.grey.shade500),
        const SizedBox(width: 2),
        Text(text, style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _statDot(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _shimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 5,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          height: 70,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // ── Device Options BottomSheet
  // ════════════════════════════════════════════════════════

  void _showDeviceOptions(DeviceEntity device) {
    HapticFeedback.lightImpact();
    final edgeColor = _getDeviceEdgeColor(device);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.75,
        builder: (_, sc) => Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          child: ListView(
            controller: sc,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
              Row(children: [
                Expanded(child: Text(device.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: edgeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Text(_getDeviceStatusLabel(device, context), style: TextStyle(fontSize: 11, color: edgeColor, fontWeight: FontWeight.bold)),
                ),
              ]),
              const Divider(height: 24),
              _sheetOption(ctx, Icons.map_outlined, Colors.blue, AppLocalizations.of(context)!.mapLabel, 'تمركز الكاميرا على الموقع الحالي', () {
                Navigator.pop(ctx);
                Navigator.pop(context); // close drawer
                final latLng = LatLng(device.lastLocation.latitude, device.lastLocation.longitude);
                ref.read(mapControllerProvider.notifier).animateTo(latLng);
              }),
              _sheetOption(ctx, Icons.history, Colors.orange, AppLocalizations.of(context)!.historyLabel, 'عرض مسار الرحلات', () {
                Navigator.pop(ctx);
                Navigator.pop(context);
                context.push('/history');
              }),
              _sheetOption(ctx, Icons.send_outlined, Colors.teal, AppLocalizations.of(context)!.sendCommand, AppLocalizations.of(context)!.sendCommandDesc, () { Navigator.pop(ctx); }),
              _sheetOption(ctx, Icons.sms_outlined, Colors.green, AppLocalizations.of(context)!.sendSms, AppLocalizations.of(context)!.sendSmsDesc, () { Navigator.pop(ctx); }),
              _sheetOption(ctx, Icons.edit_outlined, Colors.blueGrey, AppLocalizations.of(context)!.editDevice, AppLocalizations.of(context)!.editDeviceDesc, () {
                Navigator.pop(ctx);
                Navigator.pop(context);
                context.push('/device_details/${device.id}');
              }),
              const Divider(height: 8, color: Colors.red),
              _sheetOption(ctx, Icons.delete_outline, Colors.red, AppLocalizations.of(context)!.deleteDevice, AppLocalizations.of(context)!.deleteDeviceDesc, () {
                Navigator.pop(ctx);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetOption(BuildContext ctx, IconData icon, Color c, String title, String sub, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: c, size: 20),
      title: Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: c == Colors.red ? Colors.red : Colors.black87)),
      subtitle: Text(sub, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      onTap: onTap,
    );
  }

  // ════════════════════════════════════════════════════════
  // ── Groups Tab (NEW DESIGN)
  // ════════════════════════════════════════════════════════

  Widget _buildGroupsTab() {
    final groupsAsync = ref.watch(vehicleGroupsProvider);
    final allDevices = ref.watch(devicesNotifierProvider).devices ?? [];

    return groupsAsync.when(
      loading: () => _shimmerList(),
      error: (err, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.grey[400], size: 48),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.groupsLoadFailed, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(vehicleGroupsProvider),
              icon: const Icon(Icons.refresh, size: 16),
              label: Text(AppLocalizations.of(context)!.retry, style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
      data: (groups) {
        if (groups.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_off_outlined, size: 48, color: Colors.grey.shade300),
                const SizedBox(height: 8),
                Text(AppLocalizations.of(context)!.noGroups, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/groups');
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: Text(AppLocalizations.of(context)!.createGroup, style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  final groupDevices = allDevices.where((d) => group.deviceIds.contains(d.id)).toList();
                  final onlineCount = groupDevices.where((d) => d.isOnline).length;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    clipBehavior: Clip.antiAlias,
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        childrenPadding: const EdgeInsets.only(bottom: 4),
                        leading: Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.folder_outlined, color: AppTheme.primaryColor, size: 18),
                        ),
                        title: Row(
                          children: [
                            Flexible(child: Text(group.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                              child: Text('${groupDevices.length}', style: const TextStyle(fontSize: 10, color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              _statDot('$onlineCount ${AppLocalizations.of(context)!.onlineStatus}', Colors.green),
                              const SizedBox(width: 12),
                              _statDot('${groupDevices.length - onlineCount} ${AppLocalizations.of(context)!.offlineStatus}', Colors.red),
                            ],
                          ),
                        ),
                        children: [
                           const Divider(height: 1, indent: 12, endIndent: 12),
                           if (groupDevices.isEmpty)
                             Padding(padding: const EdgeInsets.all(12), child: Text(AppLocalizations.of(context)!.noDevices, style: const TextStyle(fontSize: 11, color: Colors.grey)))
                           else
                             ...groupDevices.map((d) => ListTile(
                               dense: true,
                               visualDensity: VisualDensity.compact,
                               contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                               leading: Container(width: 6, height: 6, decoration: BoxDecoration(color: d.isOnline ? Colors.green : Colors.red, shape: BoxShape.circle)),
                               title: Text(d.name, style: const TextStyle(fontSize: 12)),
                               trailing: Text(d.isOnline ? AppLocalizations.of(context)!.onlineStatus : AppLocalizations.of(context)!.offlineStatus, style: TextStyle(fontSize: 10, color: d.isOnline ? Colors.green : Colors.red)),
                              onTap: () {
                                Navigator.pop(context);
                                final latLng = LatLng(d.lastLocation.latitude, d.lastLocation.longitude);
                                ref.read(mapControllerProvider.notifier).animateTo(latLng);
                              },
                            )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // View all button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/groups');
                  },
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: Text(AppLocalizations.of(context)!.manageGroups, style: const TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(foregroundColor: AppTheme.primaryColor, side: const BorderSide(color: AppTheme.primaryColor)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ════════════════════════════════════════════════════════
  // ── Options Tab
  // ════════════════════════════════════════════════════════

  Widget _buildOptionsTab() {
    final authState = ref.watch(authNotifierProvider);
    final email = authState.maybeWhen(authenticated: (user) => user.email, orElse: () => 'user@track.com');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(email, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
        const SizedBox(height: 20),
        _buildActionCard(Icons.add_circle_outline, AppLocalizations.of(context)!.addNewDevice, () => context.push('/add-device')),
        _buildActionCard(Icons.history, AppLocalizations.of(context)!.historyLabel, () => context.push('/history')),
        _buildActionCard(Icons.build_outlined, AppLocalizations.of(context)!.tools, () => context.push('/tools')),
        _buildActionCard(Icons.settings_outlined, AppLocalizations.of(context)!.setup, () => context.push('/setup')),
        _buildActionCard(Icons.logout, AppLocalizations.of(context)!.logout, () => ref.read(authNotifierProvider.notifier).logout()),
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
}

// ════════════════════════════════════════════════════════
// Pulse animation widget for active devices
// ════════════════════════════════════════════════════════

class _PulseWidget extends StatefulWidget {
  final Color color;
  const _PulseWidget({required this.color});

  @override
  State<_PulseWidget> createState() => _PulseWidgetState();
}

class _PulseWidgetState extends State<_PulseWidget> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.7, end: 1.3).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _anim,
      child: Container(
        width: 8, height: 8,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: widget.color.withOpacity(0.4), blurRadius: 4, spreadRadius: 1)],
        ),
      ),
    );
  }
}
