import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/device_entity.dart';
import '../../../main_map/presentation/providers/devices_provider.dart';
import '../../../../generated/l10n/app_localizations.dart';

import 'add_device_screen.dart';
import '../widgets/device_list.dart';
import '../../../setup/presentation/providers/setup_provider.dart';

// ==================== Sort Enum ====================

enum DeviceSortOption {
  newestUpdate,
  oldestUpdate,
  mostActive,
  highestSpeed,
  alphabetical,
  lastConnection,
}

// ==================== Pinned Devices Provider ====================

final pinnedDeviceIdsProvider = StateProvider<Set<String>>((ref) => {});

// ==================== Screen ====================

class DevicesScreen extends ConsumerStatefulWidget {
  const DevicesScreen({Key? key}) : super(key: key);

  static const routeName = '/devices';

  @override
  ConsumerState<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends ConsumerState<DevicesScreen> {
  String _searchQuery = '';
  String _selectedGroup = 'all';
  String _selectedStatus = 'all';
  DeviceSortOption _sortOption = DeviceSortOption.newestUpdate;
  DateTime? _lastRefreshTime;
  Timer? _lastRefreshTimer;

  @override
  void initState() {
    super.initState();
    _lastRefreshTime = DateTime.now();
    _loadPinnedDevices();
    _lastRefreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _lastRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadPinnedDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final pinned = prefs.getStringList('pinned_device_ids') ?? [];
    ref.read(pinnedDeviceIdsProvider.notifier).state = pinned.toSet();
  }

  Future<void> _savePinnedDevices(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('pinned_device_ids', ids.toList());
  }

  void _togglePin(String deviceId) {
    HapticFeedback.lightImpact();
    final current = ref.read(pinnedDeviceIdsProvider);
    final updated = Set<String>.from(current);
    if (updated.contains(deviceId)) {
      updated.remove(deviceId);
    } else {
      updated.add(deviceId);
    }
    ref.read(pinnedDeviceIdsProvider.notifier).state = updated;
    _savePinnedDevices(updated);
  }

  String _lastRefreshLabel() {
    if (_lastRefreshTime == null) return '';
    final diff = DateTime.now().difference(_lastRefreshTime!);
    if (diff.inSeconds < 10) return 'آخر تحديث: الآن';
    if (diff.inMinutes < 1) return 'آخر تحديث: منذ ${diff.inSeconds} ثانية';
    if (diff.inHours < 1) return 'آخر تحديث: منذ ${diff.inMinutes} دقيقة';
    return 'آخر تحديث: منذ ${diff.inHours} ساعة';
  }

  @override
  Widget build(BuildContext context) {
    final devicesState = ref.watch(devicesNotifierProvider);
    final pinnedIds = ref.watch(pinnedDeviceIdsProvider);

    final allDevices = devicesState.devices ?? [];
    final totalCount = allDevices.length;
    final onlineCount = allDevices.where((d) => d.isOnline).length;
    final movingCount = allDevices
        .where((d) => d.displayStatus == 'moving')
        .length;
    final offlineCount = allDevices.where((d) => !d.isOnline).length;

    final groupsAsync = ref.watch(vehicleGroupsProvider);
    final groupsList = groupsAsync.value ?? [];

    // Helper to get group name
    String getGroupName(String? groupId) {
      if (groupId == null || groupId.isEmpty) return 'ungrouped';
      final group = groupsList.where((g) => g.id == groupId).firstOrNull;
      return group?.name ?? groupId; // Fallback to ID if not found
    }

    // Get unique groups from devices
    final groupNames = <String>{'all', 'ungrouped'};
    for (var d in allDevices) {
      if (d.group != null && d.group!.isNotEmpty) {
        groupNames.add(getGroupName(d.group));
      }
    }

    // Filter
    final filteredDevices = _filterDevices(allDevices, getGroupName);
    // Sort
    final sortedDevices = _sortDevices(filteredDevices, pinnedIds);
    final filteredCount = sortedDevices.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppTheme.primaryColor,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.devicesTabTitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.sort,
              color: AppTheme.primaryColor,
              size: 22,
            ),
            tooltip: 'ترتيب',
            onPressed: () => _showSortSheet(),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Quick Stats Bar ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatChip(
                  AppLocalizations.of(context)!.totalLabel,
                  totalCount,
                  Colors.black87,
                ),
                _buildStatChip(
                  AppLocalizations.of(context)!.onlineStatus,
                  onlineCount,
                  Colors.green,
                ),
                _buildStatChip(
                  AppLocalizations.of(context)!.movingStatus,
                  movingCount,
                  Colors.blue,
                ),
                _buildStatChip(
                  AppLocalizations.of(context)!.offlineStatus,
                  offlineCount,
                  Colors.red,
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // ── Search Bar ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchDeviceHint,
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade400,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 22,
                    color: AppTheme.primaryColor,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                ),
              ),
            ),
          ),

          // ── Status Filter (ToggleButtons) ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ToggleButtons(
                    isSelected: [
                      _selectedStatus == 'all',
                      _selectedStatus == 'online',
                      _selectedStatus == 'offline',
                    ],
                    onPressed: (index) {
                      setState(() {
                        _selectedStatus = ['all', 'online', 'offline'][index];
                      });
                    },
                    constraints: BoxConstraints(
                      minHeight: 38,
                      minWidth:
                          (constraints.maxWidth - 4) / 3, // -4 for borders
                    ),
                    borderRadius: BorderRadius.circular(10),
                    selectedColor: Colors.white,
                    fillColor: AppTheme.primaryColor,
                    color: Colors.grey.shade600,
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    borderColor: Colors.transparent,
                    selectedBorderColor: Colors.transparent,
                    children: [
                      Text(AppLocalizations.of(context)!.allDevicesFilter),
                      Text(AppLocalizations.of(context)!.onlineStatus),
                      Text(AppLocalizations.of(context)!.offlineStatus),
                    ],
                  );
                },
              ),
            ),
          ),

          // ── Group Filter Chips ──
          Container(
            color: Colors.white,
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              children: groupNames.map((group) {
                final isSelected = _selectedGroup == group;
                String displayLabel = group;
                if (group == 'all') {
                  displayLabel = AppLocalizations.of(context)!.allDevicesFilter;
                } else if (group == 'ungrouped') {
                  displayLabel = AppLocalizations.of(context)!.ungroupedFilter;
                }
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: FilterChip(
                    label: Text(
                      displayLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryColor,
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : Colors.grey.shade300,
                      ),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    showCheckmark: false,
                    onSelected: (_) {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedGroup = group);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // ── Last Update & Count ──
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'يعرض $filteredCount من $totalCount أجهزة',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                Text(
                  _lastRefreshLabel(),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // ── Device List ──
          Expanded(
            child: DeviceList(
              devices: sortedDevices,
              isLoading: devicesState.maybeMap(
                initial: (_) => true,
                loading: (_) => true,
                orElse: () => false,
              ),
              hasError: devicesState.maybeMap(
                error: (e) => true,
                orElse: () => false,
              ),
              errorMessage: devicesState.maybeMap(
                error: (e) => e.message,
                orElse: () => null,
              ),
              pinnedIds: pinnedIds,
              onTogglePin: _togglePin,
              onRefresh: () async {
                await ref
                    .read(devicesNotifierProvider.notifier)
                    .refreshDevices();
                setState(() => _lastRefreshTime = DateTime.now());
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AddDeviceScreen.routeName),
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'جهاز جديد',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ── Filter Logic ──
  List<DeviceEntity> _filterDevices(
    List<DeviceEntity> allDevices,
    String Function(String?) getGroupName,
  ) {
    return allDevices.where((device) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          device.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (device.plateNumber?.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ??
              false) ||
          device.imei.toLowerCase().contains(_searchQuery.toLowerCase());

      final deviceGroupName = getGroupName(device.group);

      final matchesGroup =
          _selectedGroup == 'all' ||
          (_selectedGroup == 'ungrouped' &&
              (device.group == null || device.group!.isEmpty)) ||
          deviceGroupName == _selectedGroup;

      final matchesStatus =
          _selectedStatus == 'all' ||
          (_selectedStatus == 'online' && device.isOnline) ||
          (_selectedStatus == 'offline' && !device.isOnline);

      return matchesSearch && matchesGroup && matchesStatus;
    }).toList();
  }

  // ── Sort Logic ──
  List<DeviceEntity> _sortDevices(
    List<DeviceEntity> devices,
    Set<String> pinnedIds,
  ) {
    final pinned = <DeviceEntity>[];
    final unpinned = <DeviceEntity>[];
    for (var d in devices) {
      if (pinnedIds.contains(d.id)) {
        pinned.add(d);
      } else {
        unpinned.add(d);
      }
    }

    int Function(DeviceEntity, DeviceEntity) comparator;
    switch (_sortOption) {
      case DeviceSortOption.newestUpdate:
        comparator = (a, b) => (b.lastUpdate ?? DateTime(2000)).compareTo(
          a.lastUpdate ?? DateTime(2000),
        );
        break;
      case DeviceSortOption.oldestUpdate:
        comparator = (a, b) => (a.lastUpdate ?? DateTime(2000)).compareTo(
          b.lastUpdate ?? DateTime(2000),
        );
        break;
      case DeviceSortOption.mostActive:
        comparator = (a, b) {
          final aScore = (a.isOnline ? 2 : 0) + ((a.speed ?? 0) > 0 ? 1 : 0);
          final bScore = (b.isOnline ? 2 : 0) + ((b.speed ?? 0) > 0 ? 1 : 0);
          return bScore.compareTo(aScore);
        };
        break;
      case DeviceSortOption.highestSpeed:
        comparator = (a, b) => (b.speed ?? 0).compareTo(a.speed ?? 0);
        break;
      case DeviceSortOption.alphabetical:
        comparator = (a, b) => a.name.compareTo(b.name);
        break;
      case DeviceSortOption.lastConnection:
        comparator = (a, b) => (b.lastUpdate ?? DateTime(2000)).compareTo(
          a.lastUpdate ?? DateTime(2000),
        );
        break;
    }
    pinned.sort(comparator);
    unpinned.sort(comparator);
    return [...pinned, ...unpinned];
  }

  // ── Sort BottomSheet ──
  void _showSortSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text(
                  'ترتيب حسب',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildSortTile(
                  'الأحدث تحديثاً',
                  DeviceSortOption.newestUpdate,
                  Icons.update,
                ),
                _buildSortTile(
                  'الأقدم',
                  DeviceSortOption.oldestUpdate,
                  Icons.history,
                ),
                _buildSortTile(
                  'الأكثر نشاطاً',
                  DeviceSortOption.mostActive,
                  Icons.trending_up,
                ),
                _buildSortTile(
                  'الأعلى سرعة',
                  DeviceSortOption.highestSpeed,
                  Icons.speed,
                ),
                _buildSortTile(
                  'أبجدي',
                  DeviceSortOption.alphabetical,
                  Icons.sort_by_alpha,
                ),
                _buildSortTile(
                  'آخر اتصال',
                  DeviceSortOption.lastConnection,
                  Icons.access_time,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortTile(String label, DeviceSortOption option, IconData icon) {
    final isActive = _sortOption == option;
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? AppTheme.primaryColor : Colors.grey,
        size: 22,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? AppTheme.primaryColor : Colors.black87,
        ),
      ),
      trailing: isActive
          ? const Icon(
              Icons.check_circle,
              color: AppTheme.primaryColor,
              size: 20,
            )
          : null,
      onTap: () {
        setState(() => _sortOption = option);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildStatChip(String label, int count, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          '$count $label',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
