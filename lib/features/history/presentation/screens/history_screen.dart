import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../main_map/presentation/providers/devices_provider.dart';
import '../providers/history_provider.dart';
import '../widgets/history_filter_bar.dart';
import '../widgets/trip_card.dart';
import 'trip_playback_screen.dart';
import '../../../../generated/l10n/app_localizations.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  static const routeName = '/history';

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyPageProvider);
    final devicesState = ref.watch(devicesNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: _showSearch
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchVehicleHint,
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                      border: InputBorder.none,
                    ),
                    onChanged: (q) => ref.read(historyPageProvider.notifier).setSearchQuery(q),
                  )
                : Text(AppLocalizations.of(context)!.historyTabTitle, style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(_showSearch ? Icons.close : Icons.search, color: AppTheme.primaryColor, size: 22),
                onPressed: () {
                  setState(() {
                    _showSearch = !_showSearch;
                    if (!_showSearch) {
                      _searchController.clear();
                      ref.read(historyPageProvider.notifier).setSearchQuery('');
                    }
                  });
                },
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: _buildDeviceSelector(devicesState),
            ),
          ),

          // Filter Bar
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 12),
                const HistoryFilterBar(),
                const SizedBox(height: 12),
                // Fetch button
                if (state.selectedDeviceId != null && !state.hasData)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: state.isLoading ? null : () => ref.read(historyPageProvider.notifier).fetchTrips(),
                        icon: state.isLoading
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.play_arrow, size: 20),
                        label: Text(state.isLoading ? AppLocalizations.of(context)!.loadingTrips : AppLocalizations.of(context)!.viewTripsButton),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ),
                if (state.hasData)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.tripsCount(state.filteredTrips.length),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () => ref.read(historyPageProvider.notifier).fetchTrips(),
                          icon: const Icon(Icons.refresh, size: 16),
                          label: Text(AppLocalizations.of(context)!.refreshTrips, style: const TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 4),
              ],
            ),
          ),

          // Content
          if (state.isLoading)
            SliverFillRemaining(child: _buildShimmerLoading())
          else if (state.error != null)
            SliverFillRemaining(child: _buildErrorState(state.error!))
          else if (state.selectedDeviceId == null)
            SliverFillRemaining(child: _buildSelectDeviceState())
          else if (!state.hasData)
            const SliverFillRemaining(child: SizedBox.shrink())
          else if (state.filteredTrips.isEmpty)
            SliverFillRemaining(child: _buildEmptyState())
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final trip = state.filteredTrips[index];
                  return TripCard(
                    trip: trip,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TripPlaybackScreen(trip: trip)),
                      );
                    },
                  );
                },
                childCount: state.filteredTrips.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildDeviceSelector(devicesState) {
    final historyState = ref.watch(historyPageProvider);
    final selectedId = historyState.selectedDeviceId;
    final searchQuery = historyState.filter.searchQuery.toLowerCase();

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: devicesState.maybeWhen(
        loaded: (allDevices, _, __, ___) {
          final devices = allDevices.where((d) {
            if (searchQuery.isEmpty) return true;
            return d.name.toLowerCase().contains(searchQuery) ||
                (d.plateNumber?.toLowerCase().contains(searchQuery) ?? false) ||
                d.imei.toLowerCase().contains(searchQuery);
          }).toList();

          if (devices.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noVehiclesMatchedSearch, style: const TextStyle(fontSize: 13, color: Colors.grey)),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              final isSelected = device.id == selectedId;
              return GestureDetector(
                onTap: () {
                  ref.read(historyPageProvider.notifier).selectDevice(device.id);
                  ref.read(historyPageProvider.notifier).fetchTrips();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(colors: [Color(0xFF0277BD), Color(0xFF03A9F4)])
                        : null,
                    color: isSelected ? null : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isSelected
                        ? [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.25), blurRadius: 6, offset: const Offset(0, 2))]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.directions_car, size: 14, color: isSelected ? Colors.white : Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text(
                        device.name,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        orElse: () => const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, i) {
        return Container(
          height: 180,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryColor),
                const SizedBox(height: 12),
                Text(AppLocalizations.of(context)!.loadingTrips, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline, size: 40, color: Colors.red.shade400),
            ),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.errorPrefix, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            Text(error, style: TextStyle(fontSize: 13, color: Colors.grey.shade600), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(historyPageProvider.notifier).clearError();
                ref.read(historyPageProvider.notifier).fetchTrips();
              },
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectDeviceState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.directions_car_outlined, size: 40, color: AppTheme.primaryColor.withOpacity(0.7)),
          ),
          const SizedBox(height: 20),
          Text(AppLocalizations.of(context)!.selectVehicleTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Text(AppLocalizations.of(context)!.selectVehicleSubtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.history_outlined, size: 40, color: Colors.orange.shade400),
          ),
          const SizedBox(height: 20),
          Text(AppLocalizations.of(context)!.noTripsTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Text(AppLocalizations.of(context)!.noTripsSubtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => ref.read(historyPageProvider.notifier).setChipFilter(TripChipFilter.all),
            icon: const Icon(Icons.filter_alt_off, size: 18),
            label: Text(AppLocalizations.of(context)!.removeFilters),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              side: const BorderSide(color: AppTheme.primaryColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
