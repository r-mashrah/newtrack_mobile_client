import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/trip_entity.dart';
import '../../../../generated/l10n/app_localizations.dart';

class TripStopsSheet extends StatelessWidget {
  final TripEntity trip;
  final ScrollController scrollController;
  final void Function(TripStop stop)? onStopTap;

  const TripStopsSheet({Key? key, required this.trip, required this.scrollController, this.onStopTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stops = trip.stops;
    if (stops.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 48, color: Colors.green.shade300),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.noStopsTitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54)),
            Text(AppLocalizations.of(context)!.noStopsSubtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: stops.length,
      itemBuilder: (context, index) {
        final stop = stops[index];
        return GestureDetector(
          onTap: () => onStopTap?.call(stop),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
            ),
            child: Row(
              children: [
                // Stop number badge
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: _getStopColor(stop.reason).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(stop.reason.icon, style: const TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 12),
                // Stop info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(AppLocalizations.of(context)!.stopIndex(stop.index + 1), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getStopColor(stop.reason).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(stop.reason.getName(context), style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _getStopColor(stop.reason))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 12, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(
                            '${DateFormat('hh:mm a').format(stop.startTime)} → ${DateFormat('hh:mm a').format(stop.endTime)}',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Duration badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(stop.durationFormatted, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ),
                    const SizedBox(height: 4),
                    const Icon(Icons.map_outlined, size: 18, color: AppTheme.primaryColor),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStopColor(StopReason reason) {
    switch (reason) {
      case StopReason.traffic: return Colors.amber;
      case StopReason.engineOff: return Colors.red;
      case StopReason.parking: return Colors.blue;
      case StopReason.idle: return Colors.orange;
      case StopReason.unknown: return Colors.grey;
    }
  }
}
