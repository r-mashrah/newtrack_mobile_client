import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/history_provider.dart';
import '../../../../generated/l10n/app_localizations.dart';

class HistoryFilterBar extends ConsumerWidget {
  const HistoryFilterBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyPageProvider);
    final notifier = ref.read(historyPageProvider.notifier);

    return Column(
      children: [
        // Preset Filters Row
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _PresetChip(
                label: AppLocalizations.of(context)!.todayPreset,
                icon: Icons.today,
                isSelected: state.filter.preset == HistoryFilterPreset.today,
                onTap: () => notifier.setPreset(HistoryFilterPreset.today),
              ),
              const SizedBox(width: 8),
              _PresetChip(
                label: AppLocalizations.of(context)!.yesterdayPreset,
                icon: Icons.history,
                isSelected: state.filter.preset == HistoryFilterPreset.yesterday,
                onTap: () => notifier.setPreset(HistoryFilterPreset.yesterday),
              ),
              const SizedBox(width: 8),
              _PresetChip(
                label: AppLocalizations.of(context)!.weekPreset,
                icon: Icons.date_range,
                isSelected: state.filter.preset == HistoryFilterPreset.lastWeek,
                onTap: () => notifier.setPreset(HistoryFilterPreset.lastWeek),
              ),
              const SizedBox(width: 8),
              _PresetChip(
                label: AppLocalizations.of(context)!.monthPreset,
                icon: Icons.calendar_month,
                isSelected: state.filter.preset == HistoryFilterPreset.lastMonth,
                onTap: () => notifier.setPreset(HistoryFilterPreset.lastMonth),
              ),
              const SizedBox(width: 8),
              _PresetChip(
                label: AppLocalizations.of(context)!.customPreset,
                icon: Icons.tune,
                isSelected: state.filter.preset == HistoryFilterPreset.custom,
                onTap: () => _showCustomDatePicker(context, ref),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Trip Category Chips
        SizedBox(
          height: 34,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _CategoryChip(label: AppLocalizations.of(context)!.allDevicesFilter, isSelected: state.filter.chipFilter == TripChipFilter.all, onTap: () => notifier.setChipFilter(TripChipFilter.all)),
              const SizedBox(width: 6),
              _CategoryChip(label: AppLocalizations.of(context)!.longTrip, isSelected: state.filter.chipFilter == TripChipFilter.longTrip, onTap: () => notifier.setChipFilter(TripChipFilter.longTrip)),
              const SizedBox(width: 6),
              _CategoryChip(label: AppLocalizations.of(context)!.shortTrip, isSelected: state.filter.chipFilter == TripChipFilter.shortTrip, onTap: () => notifier.setChipFilter(TripChipFilter.shortTrip)),
              const SizedBox(width: 6),
              _CategoryChip(label: AppLocalizations.of(context)!.stops, isSelected: state.filter.chipFilter == TripChipFilter.stops, onTap: () => notifier.setChipFilter(TripChipFilter.stops)),
              const SizedBox(width: 6),
              _CategoryChip(label: AppLocalizations.of(context)!.fastTrip, isSelected: state.filter.chipFilter == TripChipFilter.fastTrip, onTap: () => notifier.setChipFilter(TripChipFilter.fastTrip)),
              const SizedBox(width: 6),
              _CategoryChip(label: AppLocalizations.of(context)!.alerts, isSelected: state.filter.chipFilter == TripChipFilter.alerts, onTap: () => notifier.setChipFilter(TripChipFilter.alerts)),
              const SizedBox(width: 6),
              _CategoryChip(label: AppLocalizations.of(context)!.night, isSelected: state.filter.chipFilter == TripChipFilter.night, onTap: () => notifier.setChipFilter(TripChipFilter.night)),
            ],
          ),
        ),
      ],
    );
  }

  void _showCustomDatePicker(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(historyPageProvider.notifier);
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppTheme.primaryColor),
          ),
          child: child!,
        );
      },
    );
    if (range != null) {
      notifier.setCustomDateRange(range.start, range.end);
    }
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PresetChip({required this.label, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(colors: [Color(0xFF0288D1), Color(0xFF03A9F4)])
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
          boxShadow: isSelected
              ? [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: isSelected ? Colors.white : Colors.grey.shade600),
            const SizedBox(width: 5),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.12) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppTheme.primaryColor : Colors.transparent, width: 1.2),
        ),
        child: Text(label, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? AppTheme.primaryColor : Colors.grey.shade600)),
      ),
    );
  }
}
