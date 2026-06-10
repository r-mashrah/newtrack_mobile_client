import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/trip_entity.dart';
import '../../../../generated/l10n/app_localizations.dart';

class TripStatsSheet extends StatelessWidget {
  final TripEntity trip;
  final ScrollController scrollController;

  const TripStatsSheet({
    Key? key,
    required this.trip,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        // Main stats grid
        _buildStatsGrid(context),
        const SizedBox(height: 16),
        // Moving vs Stop bar
        _buildMovingStopBar(context),
        const SizedBox(height: 16),
        // Trip efficiency
        _buildEfficiencyCard(context),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _StatCard(
          icon: Icons.straighten,
          label: loc.distanceLabel,
          value: '${trip.distanceKm.toStringAsFixed(1)} ${loc.km}',
          color: Colors.blue,
        ),
        _StatCard(
          icon: Icons.timer,
          label: loc.durationLabel,
          value: trip.durationFormatted,
          color: Colors.teal,
        ),
        _StatCard(
          icon: Icons.speed,
          label: loc.avgSpeedCard,
          value: '${trip.avgSpeed.toStringAsFixed(0)} ${loc.kmh}',
          color: Colors.green,
        ),
        _StatCard(
          icon: Icons.flash_on,
          label: loc.maxSpeedCard,
          value: '${trip.maxSpeed.toStringAsFixed(0)} ${loc.kmh}',
          color: trip.maxSpeed > 120 ? Colors.red : Colors.orange,
        ),
        _StatCard(
          icon: Icons.pause_circle,
          label: loc.stopsCountCard,
          value: '${trip.stopsCount}',
          color: Colors.orange,
        ),
        _StatCard(
          icon: Icons.stop_circle,
          label: loc.stopTimeCard,
          value: _formatDuration(trip.stopTime, context),
          color: Colors.redAccent,
        ),
        _StatCard(
          icon: Icons.directions_car,
          label: loc.movingTimeCard,
          value: _formatDuration(trip.movingTime, context),
          color: Colors.green,
        ),
        _StatCard(
          icon: Icons.gps_fixed,
          label: loc.pointsCard,
          value: '${trip.points.length}',
          color: AppTheme.primaryColor,
        ),
      ],
    );
  }

  Widget _buildMovingStopBar(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.movingStopRatio,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  Expanded(
                    flex: (trip.movingRatio * 100).round().clamp(1, 100),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: ((1 - trip.movingRatio) * 100).round().clamp(1, 100),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade300,
                            Colors.orange.shade100,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${loc.movingColor} ${(trip.movingRatio * 100).toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${loc.stoppedColor} ${((1 - trip.movingRatio) * 100).toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEfficiencyCard(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final efficiency = trip.movingRatio * 100;
    Color effColor;
    String effLabel;
    if (efficiency > 80) {
      effColor = Colors.green;
      effLabel = loc.efficiencyExcellent;
    } else if (efficiency > 60) {
      effColor = Colors.teal;
      effLabel = loc.efficiencyGood;
    } else if (efficiency > 40) {
      effColor = Colors.orange;
      effLabel = loc.efficiencyAverage;
    } else {
      effColor = Colors.red;
      effLabel = loc.efficiencyPoor;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [effColor.withOpacity(0.05), effColor.withOpacity(0.02)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: effColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: effColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${efficiency.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: effColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.tripEfficiency,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                effLabel,
                style: TextStyle(
                  fontSize: 12,
                  color: effColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d, BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    if (d.inHours > 0)
      return isAr
          ? '${d.inHours}س ${d.inMinutes.remainder(60)}د'
          : '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    return isAr ? '${d.inMinutes}د' : '${d.inMinutes}m';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final w = (MediaQuery.of(context).size.width - 56) / 2;
    return Container(
      width: w,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: color.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
