import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/map_objects_provider.dart';
import 'poi_form_screen.dart';

class POIListScreen extends ConsumerWidget {
  const POIListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pois = ref.watch(poiProvider);

    return Scaffold(
      backgroundColor: AppColors.white1,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _buildHeaderButton(
          icon: Icons.add,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const POIFormScreen()),
          ),
        ),
        actions: [
          _buildHeaderButton(
            icon: Icons.arrow_forward,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: pois.isEmpty
          ? const Center(
              child: Text(
                'لا توجد مواقع مهمة!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D99BD),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pois.length,
              itemBuilder: (context, index) {
                final poi = pois[index];
                return Card(
                  child: ListTile(
                    title: Text(poi.name, textAlign: TextAlign.right),
                    subtitle: Text(
                      '${poi.position.latitude}, ${poi.position.longitude}',
                      textAlign: TextAlign.right,
                    ),
                    leading: const Icon(Icons.location_on, color: Color(0xFF1D99BD)),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => POIFormScreen(poi: poi),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildHeaderButton({required IconData icon, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(icon, color: const Color(0xFF1D99BD)),
          onPressed: onTap,
        ),
      ),
    );
  }
}
