import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/setup_models.dart';
import '../../../../domain/entities/device_entity.dart';
import '../../../main_map/presentation/providers/devices_provider.dart';
import '../../../setup/presentation/providers/setup_provider.dart';
import '../../../../core/providers/api_client_provider.dart';
import '../../../../core/constants/api_constants.dart';
import 'package:dio/dio.dart';
import '../../../../generated/l10n/app_localizations.dart';

// ════════════════════════════════════════════════════════════
// GroupsScreen — شاشة المجموعات
// ════════════════════════════════════════════════════════════

class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  static const routeName = '/groups';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(vehicleGroupsProvider);
    final devicesState = ref.watch(devicesNotifierProvider);
    final allDevices = devicesState.devices ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'المجموعات',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: groupsAsync.when(
        loading: () => _buildSkeleton(),
        error: (err, _) => _buildError(context, ref, err.toString()),
        data: (groups) {
          if (groups.isEmpty) {
            return _buildEmpty(context);
          }

          // Compute ungrouped devices
          final groupedDeviceIds = <String>{};
          for (var g in groups) {
            groupedDeviceIds.addAll(g.deviceIds);
          }
          final ungroupedDevices = allDevices
              .where((d) => !groupedDeviceIds.contains(d.id))
              .toList();

          return RefreshIndicator(
            onRefresh: () => ref.refresh(vehicleGroupsProvider.future),
            color: AppTheme.primaryColor,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                // Summary
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statItem(
                        'المجموعات',
                        groups.length,
                        AppTheme.primaryColor,
                      ),
                      _buildVerticalDivider(),
                      _statItem(
                        'إجمالي الأجهزة',
                        allDevices.length,
                        Colors.black87,
                      ),
                      _buildVerticalDivider(),
                      _statItem(
                        'بدون مجموعة',
                        ungroupedDevices.length,
                        Colors.orange,
                      ),
                    ],
                  ),
                ),

                // Group Cards
                ...groups
                    .map(
                      (group) =>
                          GroupCard(group: group, allDevices: allDevices),
                    )
                    .toList(),

                // Ungrouped Section
                if (ungroupedDevices.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _UngroupedSection(devices: ungroupedDevices),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddEditGroupSheet(context, ref, null);
        },
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'مجموعة جديدة',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 30, width: 1, color: Colors.grey.shade200);
  }

  Widget _statItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      },
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, String err) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade200),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ أثناء تحميل المجموعات',
            style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            err,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.invalidate(vehicleGroupsProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_off_outlined,
            size: 72,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد مجموعات بعد',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط + لإنشاء مجموعة جديدة',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  void _showAddEditGroupSheet(
    BuildContext context,
    WidgetRef ref,
    VehicleGroup? existingGroup,
  ) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditGroupSheet(existingGroup: existingGroup),
    );
  }
}

// ════════════════════════════════════════════════════════════
// GroupCard — بطاقة مجموعة مع ExpansionTile
// ════════════════════════════════════════════════════════════

class GroupCard extends StatelessWidget {
  final VehicleGroup group;
  final List<DeviceEntity> allDevices;

  const GroupCard({Key? key, required this.group, required this.allDevices})
    : super(key: key);

  List<DeviceEntity> get _groupDevices =>
      allDevices.where((d) => group.deviceIds.contains(d.id)).toList();

  int get _onlineCount => _groupDevices.where((d) => d.isOnline).length;
  int get _offlineCount => _groupDevices.where((d) => !d.isOnline).length;

  @override
  Widget build(BuildContext context) {
    final devices = _groupDevices;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.only(bottom: 8),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.folder_outlined,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          title: Row(
            children: [
              Flexible(
                child: Text(
                  group.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${devices.length} أجهزة',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                // Status indicators
                _statusDot(Colors.green, '$_onlineCount متصل'),
                const SizedBox(width: 12),
                _statusDot(Colors.red.shade400, '$_offlineCount غير متصل'),
                const Spacer(),
                // Mini avatars
                ..._buildMiniAvatars(devices),
              ],
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
            onPressed: () => _showGroupOptions(context),
          ),
          children: [
            const Divider(height: 1, indent: 16, endIndent: 16),
            if (devices.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'لا توجد أجهزة في هذه المجموعة',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              )
            else
              ...devices.map((d) => _buildMiniDeviceRow(d, context)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _statusDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildMiniAvatars(List<DeviceEntity> devices) {
    const maxShow = 3;
    final widgets = <Widget>[];
    for (var i = 0; i < devices.length && i < maxShow; i++) {
      final deviceIcon = AppTheme.getVehicleIcon(
        devices[i].markerImage ?? devices[i].icon,
      );
      widgets.add(
        Align(
          widthFactor: 0.8,
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.getStatusColor(
                  devices[i].displayStatus,
                ).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  deviceIcon,
                  size: 13,
                  color: AppTheme.getStatusColor(devices[i].displayStatus),
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (devices.length > maxShow) {
      widgets.add(
        Align(
          widthFactor: 0.8,
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Text(
                '+${devices.length - maxShow}',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  Widget _buildMiniDeviceRow(DeviceEntity device, BuildContext context) {
    final isOnline = device.isOnline;
    final statusColor = isOnline ? Colors.green : Colors.red.shade400;
    final deviceIcon = AppTheme.getVehicleIcon(
      device.markerImage ?? device.icon,
    );

    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(deviceIcon, size: 16, color: statusColor),
      ),
      title: Text(
        device.name,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          isOnline ? 'متصل' : 'غير متصل',
          style: TextStyle(
            fontSize: 11,
            color: statusColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: () => context.push('/device_details/${device.id}'),
    );
  }

  void _showGroupOptions(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
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
              Text(
                group.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_groupDevices.length} أجهزة',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 8),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.edit_outlined,
                  color: Colors.blueGrey,
                ),
                title: const Text(
                  'تعديل المجموعة',
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: const Text(
                  'تعديل الاسم وإدارة الأجهزة',
                  style: TextStyle(fontSize: 11),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => AddEditGroupSheet(existingGroup: group),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.map_outlined, color: Colors.blue),
                title: const Text(
                  'عرض على الخريطة',
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: const Text(
                  'عرض جميع أجهزة المجموعة على الخريطة',
                  style: TextStyle(fontSize: 11),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  context.go('/main-map');
                },
              ),
              const Divider(color: Colors.red),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'حذف المجموعة',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _showDeleteGroupDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteGroupDialog(BuildContext context) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (ctx) => _DeleteGroupDialog(group: group),
    );
  }
}

class _DeleteGroupDialog extends ConsumerWidget {
  final VehicleGroup group;
  const _DeleteGroupDialog({required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('حذف المجموعة'),
      content: Text(
        'هل تريد حذف "${group.name}"؟',
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () async {
            HapticFeedback.lightImpact();
            Navigator.pop(context);

            // Show loading
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );

            try {
              final apiClient = ref.read(apiClientProvider);
              await apiClient.delete(
                '${ApiConstants.destroyDeviceGroupBase}/${group.id}',
              );

              Navigator.of(context).pop(); // Close loading

              ref.invalidate(vehicleGroupsProvider);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف المجموعة بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            } catch (e) {
              Navigator.of(context).pop(); // Close loading
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('فشل حذف المجموعة: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('حذف', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
// Ungrouped Devices Section
// ════════════════════════════════════════════════════════════

class _UngroupedSection extends StatelessWidget {
  final List<DeviceEntity> devices;
  const _UngroupedSection({required this.devices});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.only(bottom: 8),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.folder_off_outlined,
              color: Colors.orange,
              size: 24,
            ),
          ),
          title: Row(
            children: [
              const Text(
                'بدون مجموعة',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${devices.length} أجهزة',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          children: [
            const Divider(height: 1, indent: 16, endIndent: 16),
            ...devices.map((d) {
              final isOnline = d.isOnline;
              final statusColor = isOnline ? Colors.green : Colors.red.shade400;
              final deviceIcon = AppTheme.getVehicleIcon(
                d.markerImage ?? d.icon,
              );

              return ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 2,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(deviceIcon, size: 16, color: statusColor),
                ),
                title: Text(
                  d.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isOnline ? 'متصل' : 'غير متصل',
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                onTap: () => context.push('/device_details/${d.id}'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// AddEditGroupSheet — إضافة / تعديل مجموعة
// ════════════════════════════════════════════════════════════

class AddEditGroupSheet extends ConsumerStatefulWidget {
  final VehicleGroup? existingGroup;
  const AddEditGroupSheet({Key? key, this.existingGroup}) : super(key: key);

  @override
  ConsumerState<AddEditGroupSheet> createState() => _AddEditGroupSheetState();
}

class _AddEditGroupSheetState extends ConsumerState<AddEditGroupSheet> {
  late TextEditingController _nameController;
  Set<String> _selectedDeviceIds = {};
  String _deviceSearch = '';

  bool get isEditing => widget.existingGroup != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.existingGroup?.name ?? '',
    );
    _selectedDeviceIds = widget.existingGroup?.deviceIds.toSet() ?? {};
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final devicesState = ref.watch(devicesNotifierProvider);
    final allDevices = devicesState.devices ?? [];
    final filteredDevices = _deviceSearch.isEmpty
        ? allDevices
        : allDevices
              .where(
                (d) =>
                    d.name.toLowerCase().contains(
                      _deviceSearch.toLowerCase(),
                    ) ||
                    (d.plateNumber?.toLowerCase().contains(
                          _deviceSearch.toLowerCase(),
                        ) ??
                        false),
              )
              .toList();

    final onlineSelected = allDevices
        .where((d) => _selectedDeviceIds.contains(d.id) && d.isOnline)
        .length;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isEditing ? 'تعديل المجموعة' : 'مجموعة جديدة',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Group Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'اسم المجموعة',
                  prefixIcon: const Icon(Icons.folder_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            // Summary Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'محدد: ${_selectedDeviceIds.length} أجهزة',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '| $onlineSelected نشط',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(
                      () => _selectedDeviceIds = allDevices
                          .map((d) => d.id)
                          .toSet(),
                    ),
                    child: const Text(
                      'تحديد الكل',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _selectedDeviceIds.clear()),
                    child: const Text(
                      'إلغاء الكل',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),

            // Search Devices
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  onChanged: (val) => setState(() => _deviceSearch = val),
                  style: const TextStyle(fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'ابحث عن جهاز...',
                    hintStyle: TextStyle(fontSize: 13),
                    prefixIcon: Icon(Icons.search, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),

            // Device List
            Expanded(
              child: ListView.builder(
                controller: controller,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: filteredDevices.length,
                itemBuilder: (context, index) {
                  final device = filteredDevices[index];
                  final isSelected = _selectedDeviceIds.contains(device.id);
                  final isOnline = device.isOnline;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor.withOpacity(0.06)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColor.withOpacity(0.3)
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: CheckboxListTile(
                      value: isSelected,
                      onChanged: (val) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          if (val == true) {
                            _selectedDeviceIds.add(device.id);
                          } else {
                            _selectedDeviceIds.remove(device.id);
                          }
                        });
                      },
                      activeColor: AppTheme.primaryColor,
                      dense: true,
                      title: Text(
                        device.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        isOnline ? 'متصل' : 'غير متصل',
                        style: TextStyle(
                          fontSize: 11,
                          color: isOnline ? Colors.green : Colors.red,
                        ),
                      ),
                      secondary: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.getStatusColor(
                            device.displayStatus,
                          ).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.directions_car,
                          size: 16,
                          color: AppTheme.getStatusColor(device.displayStatus),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Save FAB
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    HapticFeedback.lightImpact();

                    final name = _nameController.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('الرجاء إدخال اسم المجموعة'),
                        ),
                      );
                      return;
                    }

                    bool loadingShown = false;
                    try {
                      // Show loading dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) =>
                            const Center(child: CircularProgressIndicator()),
                      );
                      loadingShown = true;

                      final apiClient = ref.read(apiClientProvider);

                      // Build JSON body matching the server API contract:
                      // { "title": "string", "open": true, "devices": [int, int, ...] }
                      List<int> deviceIds = _selectedDeviceIds
                          .map((id) => int.tryParse(id) ?? 0)
                          .where((id) => id > 0)
                          .toList();
                          
                      // The GPSWox API expects at least [0] if no devices are selected
                      if (deviceIds.isEmpty) {
                        deviceIds = [0];
                      }

                      final Map<String, dynamic> requestBody = {
                        'title': name,
                        'open': true,
                        'devices': deviceIds,
                      };

                      Response response;
                      if (isEditing) {
                        // PUT /api/devices_groups/update/{id}
                        final groupId = widget.existingGroup?.id;
                        response = await apiClient.put(
                          '${ApiConstants.editDeviceGroupBase}/$groupId',
                          data: requestBody,
                        );
                      } else {
                        // POST /api/devices_groups/store
                        response = await apiClient.post(
                          ApiConstants.addDeviceGroup,
                          data: requestBody,
                        );
                      }

                      // Close loading dialog
                      if (loadingShown && mounted) {
                        Navigator.of(context).pop();
                        loadingShown = false;
                      }

                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        ref.invalidate(vehicleGroupsProvider); // Refresh groups

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isEditing
                                    ? 'تم تعديل المجموعة بنجاح'
                                    : 'تم إنشاء المجموعة بنجاح',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context); // Close bottom sheet
                        }
                      } else {
                        throw DioException(
                          requestOptions: response.requestOptions,
                          response: response,
                          message: 'فشل الحفظ - كود الاستجابة: ${response.statusCode}',
                        );
                      }
                    } catch (e) {
                      // Close loading dialog if still shown
                      if (loadingShown && mounted) {
                        Navigator.of(context).pop();
                        loadingShown = false;
                      }
                      String errorMessage = 'حدث خطأ غير متوقع';
                      if (e is DioException) {
                        if (e.response?.statusCode == 404) {
                          errorMessage = 'المسار غير موجود على السيرفر (404). تحقق من إعدادات الـ API.';
                        } else if (e.response?.data != null && e.response?.data is Map) {
                          final data = e.response!.data as Map;
                          if (data.containsKey('message')) {
                            errorMessage = data['message'].toString();
                          } else {
                            errorMessage = 'خطأ خادم (${e.response?.statusCode})';
                          }
                        } else if (e.type == DioExceptionType.connectionTimeout) {
                          errorMessage = 'انتهت مهلة الاتصال بالسيرفر';
                        } else if (e.type == DioExceptionType.connectionError) {
                          errorMessage = 'فشل الاتصال بالسيرفر';
                        } else {
                          errorMessage = 'خطأ: ${e.message ?? e.toString()}';
                        }
                      } else {
                        errorMessage = 'حدث خطأ: $e';
                      }
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        isEditing ? 'حفظ التعديلات' : 'إنشاء المجموعة',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      if (_selectedDeviceIds.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${_selectedDeviceIds.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
