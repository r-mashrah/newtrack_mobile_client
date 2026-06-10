import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/trip_entity.dart';
import 'package:intl/intl.dart';
import '../../../../generated/l10n/app_localizations.dart';

class TripCard extends StatelessWidget {
  final TripEntity trip;
  final VoidCallback onTap;

  const TripCard({Key? key, required this.trip, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final timeFormat = DateFormat('hh:mm a', localeCode);
    final dateFormat = DateFormat('yyyy/MM/dd', localeCode);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  // Vehicle icon
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.primaryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Name & plate
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.deviceName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        if (trip.plateNumber != null &&
                            trip.plateNumber!.isNotEmpty)
                          Text(
                            trip.plateNumber!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Status badge
                  _buildCategoryBadge(context),
                ],
              ),
            ),
            // Time row
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule, size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    timeFormat.format(trip.startTime),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: AppTheme.primaryColor.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    timeFormat.format(trip.endTime),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    dateFormat.format(trip.startTime),
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    icon: Icons.straighten,
                    label: AppLocalizations.of(context)!.distanceLabel,
                    value:
                        '${trip.distanceKm.toStringAsFixed(1)} ${AppLocalizations.of(context)!.kmh}',
                  ),
                  _StatItem(
                    icon: Icons.timer_outlined,
                    label: AppLocalizations.of(context)!.durationLabel,
                    value: trip.durationFormatted,
                  ),
                  _StatItem(
                    icon: Icons.speed,
                    label: AppLocalizations.of(context)!.avgSpeedLabel,
                    value:
                        '${trip.avgSpeed.toStringAsFixed(0)} ${AppLocalizations.of(context)!.kmh}',
                  ),
                  _StatItem(
                    icon: Icons.speed,
                    label: AppLocalizations.of(context)!.maxSpeedLabel,
                    value:
                        '${trip.maxSpeed.toStringAsFixed(0)} ${AppLocalizations.of(context)!.kmh}',
                    valueColor: trip.maxSpeed > 120 ? Colors.red : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Moving/Stop ratio bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.onlineColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${AppLocalizations.of(context)!.movingColor} ${(trip.movingRatio * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.stoppedColor} ${((1 - trip.movingRatio) * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.stoppedColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      height: 6,
                      child: Row(
                        children: [
                          Expanded(
                            flex: (trip.movingRatio * 100).round().clamp(
                              1,
                              100,
                            ),
                            child: Container(color: AppTheme.onlineColor),
                          ),
                          Expanded(
                            flex: ((1 - trip.movingRatio) * 100).round().clamp(
                              1,
                              100,
                            ),
                            child: Container(
                              color: AppTheme.stoppedColor.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Bottom indicators
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  if (trip.hasOverSpeed)
                    _Indicator(
                      icon: '⚡',
                      label: AppLocalizations.of(context)!.overspeed,
                      color: Colors.red,
                    ),
                  if (trip.stopsCount > 0)
                    _Indicator(
                      icon: '🛑',
                      label: AppLocalizations.of(
                        context,
                      )!.stopsCount(trip.stopsCount),
                      color: Colors.orange,
                    ),
                  if (trip.points.isNotEmpty)
                    _Indicator(
                      icon: '📍',
                      label: AppLocalizations.of(
                        context,
                      )!.pointsCount(trip.points.length),
                      color: AppTheme.primaryColor,
                    ),
                  const Spacer(),
                  Icon(
                    Icons.play_circle_fill,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(BuildContext context) {
    Color bgColor;
    String label;
    switch (trip.category) {
      case TripCategory.longTrip:
        bgColor = Colors.blue;
        label = AppLocalizations.of(context)!.longTrip;
        break;
      case TripCategory.shortTrip:
        bgColor = Colors.teal;
        label = AppLocalizations.of(context)!.shortTrip;
        break;
      case TripCategory.fastTrip:
        bgColor = Colors.red;
        label = AppLocalizations.of(context)!.fastTrip;
        break;
      case TripCategory.stops:
        bgColor = Colors.orange;
        label = AppLocalizations.of(context)!.stops;
        break;
      case TripCategory.night:
        bgColor = Colors.indigo;
        label = AppLocalizations.of(context)!.night;
        break;
      case TripCategory.normal:
        bgColor = Colors.green;
        label = AppLocalizations.of(context)!.normalTrip;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bgColor.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: bgColor,
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryColor.withOpacity(0.7)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black87,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
      ],
    );
  }
}

class _Indicator extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;

  const _Indicator({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 11)),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
