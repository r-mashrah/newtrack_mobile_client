import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/trip_entity.dart';
import '../../../../generated/l10n/app_localizations.dart';

class TripTimelineSheet extends StatelessWidget {
  final TripEntity trip;
  final ScrollController scrollController;
  final void Function(TripEvent event)? onEventTap;

  const TripTimelineSheet({Key? key, required this.trip, required this.scrollController, this.onEventTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = trip.events;
    if (events.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noEventsTitle, style: const TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final isFirst = index == 0;
        final isLast = index == events.length - 1;

        return GestureDetector(
          onTap: () => onEventTap?.call(event),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline line + dot
                SizedBox(
                  width: 30,
                  child: Column(
                    children: [
                      if (!isFirst)
                        Container(width: 2, height: 8, color: AppTheme.primaryColor.withOpacity(0.3)),
                      Container(
                        width: 14, height: 14,
                        decoration: BoxDecoration(
                          color: _getEventColor(event.type),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: _getEventColor(event.type).withOpacity(0.3), blurRadius: 6)],
                        ),
                      ),
                      if (!isLast)
                        Expanded(child: Container(width: 2, color: AppTheme.primaryColor.withOpacity(0.15))),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Event card
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
                    ),
                    child: Row(
                      children: [
                        Text(event.type.icon, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.type.getName(context), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                              if (event.description != null)
                                Text(event.description!, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(DateFormat('hh:mm a').format(event.time), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
                            const Icon(Icons.chevron_left, size: 16, color: Colors.grey),
                          ],
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

  Color _getEventColor(TripEventType type) {
    switch (type) {
      case TripEventType.start: return Colors.green;
      case TripEventType.end: return Colors.red;
      case TripEventType.stop: return Colors.orange;
      case TripEventType.overSpeed: return Colors.redAccent;
      case TripEventType.alert: return Colors.amber;
      case TripEventType.moving: return AppTheme.primaryColor;
      case TripEventType.engineOn: return Colors.teal;
      case TripEventType.engineOff: return Colors.grey;
      case TripEventType.geofenceEntry: return Colors.purple;
      case TripEventType.geofenceExit: return Colors.deepPurple;
    }
  }
}
