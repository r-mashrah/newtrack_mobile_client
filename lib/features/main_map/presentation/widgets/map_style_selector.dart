import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/map_style_provider.dart';

/// أداة اختيار نمط الخريطة
class MapStyleSelector extends ConsumerWidget {
  const MapStyleSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapStyle = ref.watch(mapStyleStateProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // عنوان القسم
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'نمط الخريطة',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(height: 1),

          // أزرار أنماط الخريطة
          Padding(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildStyleButton(
                  context,
                  ref,
                  label: 'عادي',
                  style: MapStyleType.normal,
                  currentStyle: mapStyle.currentStyle,
                ),
                _buildStyleButton(
                  context,
                  ref,
                  label: 'الليل',
                  style: MapStyleType.night,
                  currentStyle: mapStyle.currentStyle,
                ),
                _buildStyleButton(
                  context,
                  ref,
                  label: 'التضاريس',
                  style: MapStyleType.terrain,
                  currentStyle: mapStyle.currentStyle,
                ),
                _buildStyleButton(
                  context,
                  ref,
                  label: 'الأقمار',
                  style: MapStyleType.satellite,
                  currentStyle: mapStyle.currentStyle,
                ),
                _buildStyleButton(
                  context,
                  ref,
                  label: 'هجين',
                  style: MapStyleType.hybrid,
                  currentStyle: mapStyle.currentStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// بناء زر نمط الخريطة
  Widget _buildStyleButton(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required MapStyleType style,
    required MapStyleType currentStyle,
  }) {
    final isSelected = style == currentStyle;

    return ElevatedButton(
      onPressed: () {
        ref.read(mapStyleNotifierProvider.notifier).setMapStyle(style);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).primaryColor
            : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(label),
    );
  }
}

/// أداة التحكم بخيارات الخريطة
class MapOptionsToggle extends ConsumerWidget {
  const MapOptionsToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapStyle = ref.watch(mapStyleStateProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // عنوان القسم
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'خيارات الخريطة',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(height: 1),

          // خيارات التبديل
          _buildToggleOption(
            context,
            ref,
            label: 'عرض المسار',
            icon: Icons.timeline,
            value: mapStyle.showTrail,
            onChanged: () {
              ref.read(mapStyleNotifierProvider.notifier).toggleTrail();
            },
          ),
          _buildToggleOption(
            context,
            ref,
            label: 'الأسوار الجغرافية',
            icon: Icons.border_all,
            value: mapStyle.showGeofences,
            onChanged: () {
              ref.read(mapStyleNotifierProvider.notifier).toggleGeofences();
            },
          ),
          _buildToggleOption(
            context,
            ref,
            label: 'نقاط الاهتمام',
            icon: Icons.location_on,
            value: mapStyle.showPoI,
            onChanged: () {
              ref.read(mapStyleNotifierProvider.notifier).togglePoI();
            },
          ),
        ],
      ),
    );
  }

  /// بناء خيار التبديل
  Widget _buildToggleOption(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required IconData icon,
    required bool value,
    required VoidCallback onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label),
          ),
          Switch(
            value: value,
            onChanged: (_) => onChanged(),
          ),
        ],
      ),
    );
  }
}
