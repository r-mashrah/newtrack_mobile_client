import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/map_style_provider.dart';

class MapSettingsBottomSheet extends ConsumerStatefulWidget {
  const MapSettingsBottomSheet({Key? key}) : super(key: key);

  @override
  ConsumerState<MapSettingsBottomSheet> createState() =>
      _MapSettingsBottomSheetState();
}

class _MapSettingsBottomSheetState extends ConsumerState<MapSettingsBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapStyle = ref.watch(mapStyleStateProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // ignore: unused_local_variable
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _slideAnimation.value) * 100),
          child: Opacity(opacity: _slideAnimation.value, child: child),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.map_outlined,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'إعدادات الخريطة',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

Flexible(
  child: SingleChildScrollView(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Map Type Section
        _buildSectionTitle(context, 'نوع الخريطة'),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildMapTypeItem(
                context,
                label: 'عادي',
                type: MapStyleType.normal,
                icon: Icons.map,
                isSelected:
                    mapStyle.currentStyle == MapStyleType.normal,
                assetPath: 'assets/images/map_normal.png',
              ),
              _buildMapTypeItem(
                context,
                label: 'ليلي',
                type: MapStyleType.night,
                icon: Icons.dark_mode,
                isSelected:
                    mapStyle.currentStyle == MapStyleType.night,
                assetPath: 'assets/images/map_night.png',
              ),
              _buildMapTypeItem(
                context,
                label: 'تضاريس',
                type: MapStyleType.terrain,
                icon: Icons.terrain,
                isSelected:
                    mapStyle.currentStyle == MapStyleType.terrain,
                assetPath: 'assets/images/map_terrain.jpeg',
              ),
              _buildMapTypeItem(
                context,
                label: 'أقمار',
                type: MapStyleType.satellite,
                icon: Icons.satellite,
                isSelected:
                    mapStyle.currentStyle == MapStyleType.satellite,
                assetPath: 'assets/images/map_satellite.jpeg',
              ),
              _buildMapTypeItem(
                context,
                label: 'هجين',
                type: MapStyleType.hybrid,
                icon: Icons.layers,
                isSelected:
                    mapStyle.currentStyle == MapStyleType.hybrid,
                assetPath: 'assets/images/map_hybrid.jpeg',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Map Utilities Section
        _buildSectionTitle(context, 'أدوات الخريطة'),
        const SizedBox(height: 8),
        _buildUtilityToggle(
          context,
          label: 'عرض المسارات (Trails)',
          subtitle: 'إظهار مسار حركة الأجهزة على الخريطة',
          icon: Icons.timeline,
          value: mapStyle.showTrail,
          onChanged: (val) => ref
              .read(mapStyleNotifierProvider.notifier)
              .toggleTrail(),
        ),
        _buildUtilityToggle(
          context,
          label: 'الأسوار الجغرافية (Geofences)',
          subtitle: 'إظهار المناطق المحددة جغرافياً',
          icon: Icons.border_outer,
          value: mapStyle.showGeofences,
          onChanged: (val) => ref
              .read(mapStyleNotifierProvider.notifier)
              .toggleGeofences(),
        ),
        _buildUtilityToggle(
          context,
          label: 'نقاط الاهتمام (POI)',
          subtitle: 'إظهار المواقع الهامة والمحطات',
          icon: Icons.place_outlined,
          value: mapStyle.showPoI,
          onChanged: (val) => ref
              .read(mapStyleNotifierProvider.notifier)
              .togglePoI(),
        ),
      ],
    ),
  ),
),        // Footer Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('تطبيق الإعدادات'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

Widget _buildMapTypeItem(
  BuildContext context, {
  required String label,
  required MapStyleType type,
  required IconData icon,
  required bool isSelected,
  required String assetPath, // تغيير من imageUrl إلى assetPath
}) {
  final colorScheme = Theme.of(context).colorScheme;
  return GestureDetector(
    onTap: () =>
        ref.read(mapStyleNotifierProvider.notifier).setMapStyle(type),
    child: Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            height: 70,
            width: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
                width: isSelected ? 3 : 1,
              ),
              image: DecorationImage(
                image: AssetImage(assetPath), // استخدام AssetImage بدلاً من NetworkImage
                fit: BoxFit.cover,
                colorFilter: isSelected
                    ? null
                    : ColorFilter.mode(
                        Colors.black.withOpacity(0.2),
                        BlendMode.darken,
                      ),
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: colorScheme.onPrimary,
                        size: 16,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget _buildUtilityToggle(
    BuildContext context, {
    required String label,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: value
              ? colorScheme.primaryContainer
              : colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: value
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: colorScheme.primary,
      ),
    );
  }
}
