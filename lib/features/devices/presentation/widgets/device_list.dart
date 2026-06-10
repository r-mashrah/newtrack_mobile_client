import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/device_entity.dart';
import '../screens/add_device_screen.dart';
import '../../../../generated/l10n/app_localizations.dart';

// ════════════════════════════════════════════════════════════
// DeviceList — Receives pre-filtered & sorted data from screen
// ════════════════════════════════════════════════════════════

class DeviceList extends StatelessWidget {
  final List<DeviceEntity> devices;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final Set<String> pinnedIds;
  final void Function(String deviceId) onTogglePin;
  final Future<void> Function() onRefresh;

  const DeviceList({
    Key? key,
    required this.devices,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    required this.pinnedIds,
    required this.onTogglePin,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading && devices.isEmpty) {
      return _buildSkeleton();
    }

    if (hasError && devices.isEmpty) {
      return _buildErrorState(context);
    }

    if (devices.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppTheme.primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80, left: 12, right: 12),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return DeviceCard(
            device: devices[index],
            isPinned: pinnedIds.contains(devices[index].id),
            onTogglePin: () => onTogglePin(devices[index].id),
          );
        },
      ),
    );
  }

  // ── Skeleton Shimmer ──
  Widget _buildSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 14, width: 120, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(height: 10, width: 180, color: Colors.white),
                        const SizedBox(height: 16),
                        Container(height: 36, color: Colors.white),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            3,
                            (_) => Container(
                              height: 12,
                              width: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Empty State ──
  Widget _buildEmptyState(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.devices_other, size: 72, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noDevicesMatched,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.tryChangingFilters,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }

  // ── Error State ──
  Widget _buildErrorState(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 72, color: Colors.red.shade200),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.checkNetworkConnection,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  errorMessage!,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// PulseIndicator — تأثير نبض لحالة Online/Moving
// ════════════════════════════════════════════════════════════

class PulseIndicator extends StatefulWidget {
  final Color color;
  const PulseIndicator({Key? key, required this.color}) : super(key: key);

  @override
  State<PulseIndicator> createState() => _PulseIndicatorState();
}

class _PulseIndicatorState extends State<PulseIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.7,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.4),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// DeviceCard — البطاقة الرئيسية
// ════════════════════════════════════════════════════════════

class DeviceCard extends StatelessWidget {
  final DeviceEntity device;
  final bool isPinned;
  final VoidCallback onTogglePin;

  const DeviceCard({
    Key? key,
    required this.device,
    this.isPinned = false,
    required this.onTogglePin,
  }) : super(key: key);

  // ── Compute device state from API fields ──
  _DeviceStatus get _status {
    // Priority: offline → no_gps → moving → idle → online
    if (device.displayStatus == 'offline' || !device.isOnline) {
      return _DeviceStatus.offline;
    }
    if (device.speed != null && device.speed! > 0) {
      return _DeviceStatus.moving;
    }
    if (device.displayStatus == 'idle') {
      return _DeviceStatus.idle;
    }
    // Online and stopped
    return _DeviceStatus.online;
  }

  Color get _edgeColor {
    switch (_status) {
      case _DeviceStatus.online:
        return const Color(0xFF4CAF50); // أخضر
      case _DeviceStatus.moving:
        return const Color(0xFF2196F3); // أزرق
      case _DeviceStatus.idle:
        return const Color(0xFFFFC107); // أصفر
      case _DeviceStatus.offline:
        return const Color(0xFFF44336); // أحمر
      case _DeviceStatus.noGps:
        return Colors.grey; // رمادي
    }
  }

  String _getStatusLabel(BuildContext context) {
    switch (_status) {
      case _DeviceStatus.online:
        return AppLocalizations.of(context)!.onlineStatus;
      case _DeviceStatus.moving:
        return AppLocalizations.of(context)!.movingStatus;
      case _DeviceStatus.idle:
        return AppLocalizations.of(context)!.idleStatus;
      case _DeviceStatus.offline:
        return AppLocalizations.of(context)!.offlineStatus;
      case _DeviceStatus.noGps:
        return AppLocalizations.of(context)!.noGpsSignal;
    }
  }

  bool get _shouldPulse =>
      _status == _DeviceStatus.online || _status == _DeviceStatus.moving;

  @override
  Widget build(BuildContext context) {
    final vehicleIcon = AppTheme.getVehicleIcon(device.markerImage ?? device.icon);

    return Slidable(
      key: ValueKey(device.id),
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) {
              HapticFeedback.lightImpact();
              context.go('/map');
            },
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            icon: Icons.map_outlined,
            label: AppLocalizations.of(context)!.mapLabel,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
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
              context.push('/history');
            },
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            icon: Icons.history,
            label: AppLocalizations.of(context)!.historyTabTitle,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          ),
        ],
      ),
      child: Container(
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push('/device_details/${device.id}'),
            onLongPress: () {
              HapticFeedback.lightImpact();
              _showOptionsSheet(context);
            },
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Status Edge Line
                  Container(width: 4, color: _edgeColor),
                  
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Row: Icon, Name, Pin, More
                          Row(
                            children: [
                              // Vehicle Icon with Status Indicator
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _edgeColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(vehicleIcon, size: 20, color: _edgeColor),
                                  ),
                                  if (_shouldPulse)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: PulseIndicator(color: _edgeColor),
                                    )
                                  else
                                    Positioned(
                                      bottom: 2,
                                      right: 2,
                                      child: Container(
                                        width: 8, height: 8,
                                        decoration: BoxDecoration(
                                          color: _edgeColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 1.5),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              
                              // Name & Time
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            device.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15,
                                              color: Colors.black87,
                                              letterSpacing: -0.3,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isPinned)
                                          const Padding(
                                            padding: EdgeInsets.only(right: 6),
                                            child: Icon(Icons.push_pin, size: 14, color: AppTheme.primaryColor),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      AppLocalizations.of(context)!.lastConnectionLabel(
                                        _formatTime(context, device.lastUpdate),
                                      ),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _status == _DeviceStatus.offline ? Colors.red.shade400 : Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Options Button
                              IconButton(
                                icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  _showOptionsSheet(context);
                                },
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Bottom Row: Quick Info (Speed, Battery, Fuel)
                          Row(
                            children: [
                              _buildInfoItem(Icons.speed, device.speed != null ? '${device.speed!.toStringAsFixed(0)} ${AppLocalizations.of(context)!.kmh}' : '--'),
                              _buildDivider(),
                              _buildInfoItem(Icons.battery_charging_full, device.batteryLevel != null ? '${device.batteryLevel!.toStringAsFixed(0)}%' : '--'),
                              _buildDivider(),
                              _buildInfoItem(Icons.local_gas_station_outlined, device.fuelLevel != null ? '${device.fuelLevel!.toStringAsFixed(0)}%' : '--'),
                              _buildDivider(),
                              Expanded(
                                child: _buildInfoItem(Icons.location_on_outlined, _locationText(), isExpanded: true),
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
      ),
    );
  }

  String _locationText() {
    final lat = device.lastLocation.latitude;
    final lng = device.lastLocation.longitude;
    if (lat == 0 && lng == 0) return '--';
    return '${lat.toStringAsFixed(3)}, ${lng.toStringAsFixed(3)}';
  }

  Widget _buildDivider() {
    return Container(
      height: 12,
      width: 1,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, {bool isExpanded = false}) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return isExpanded ? content : Flexible(child: content);
  }

  // ════════════════════════════════════════════════════════════
  // DeviceOptionsBottomSheet
  // ════════════════════════════════════════════════════════════

  void _showOptionsSheet(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header: Name + Status Chip
              Row(
                children: [
                  Expanded(
                    child: Text(
                      device.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _edgeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusLabel(context),
                      style: TextStyle(
                        color: _edgeColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 16),

              // Options
              _optionTile(
                ctx,
                Icons.map_outlined,
                Colors.blue,
                AppLocalizations.of(ctx)!.showOnMap,
                () {
                  Navigator.pop(ctx);
                  context.go('/map');
                },
              ),
              _optionTile(
                ctx,
                Icons.history,
                Colors.orange,
                AppLocalizations.of(ctx)!.historyTabTitle,
                () {
                  Navigator.pop(ctx);
                  context.push('/history');
                },
              ),
              _optionTile(
                ctx,
                Icons.send_outlined,
                Colors.teal,
                AppLocalizations.of(ctx)!.sendCommand,
                () {
                  Navigator.pop(ctx);
                },
              ),
              _optionTile(
                ctx,
                Icons.sms_outlined,
                Colors.green,
                AppLocalizations.of(ctx)!.sendSmsCommand,
                () {
                  Navigator.pop(ctx);
                },
              ),
              _optionTile(
                ctx,
                Icons.edit_outlined,
                Colors.blueGrey,
                AppLocalizations.of(ctx)!.editDevice,
                () {
                  Navigator.pop(ctx);
                  context.push(AddDeviceScreen.routeName, extra: device);
                },
              ),
              _optionTile(
                ctx,
                isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                AppTheme.primaryColor,
                isPinned ? AppLocalizations.of(ctx)!.unpin : AppLocalizations.of(ctx)!.pinToTop,
                () {
                  Navigator.pop(ctx);
                  onTogglePin();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionTile(
    BuildContext ctx,
    IconData icon,
    Color iconColor,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }



  String _formatTime(BuildContext context, DateTime? time) {
    if (time == null) return AppLocalizations.of(context)!.localeName == 'ar' ? 'غير متاح' : 'N/A';
    final diff = DateTime.now().difference(time);
    final isAr = AppLocalizations.of(context)!.localeName == 'ar';
    if (diff.inMinutes < 1) return isAr ? 'الآن' : 'Now';
    if (diff.inHours < 1) return isAr ? 'منذ ${diff.inMinutes} دقيقة' : '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return isAr ? 'منذ ${diff.inHours} ساعة' : '${diff.inHours}h ago';
    return isAr ? 'منذ ${diff.inDays} يوم' : '${diff.inDays}d ago';
  }
}

// ════════════════════════════════════════════════════════════
// Device Status Enum (internal)
// ════════════════════════════════════════════════════════════

enum _DeviceStatus {
  online, // متصل وثابت
  moving, // يتحرك — speed > 0
  idle, // متصل لكن ثابت فترة طويلة
  offline, // انقطع الاتصال
  noGps, // لا إشارة GPS
}
