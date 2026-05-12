import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/map_objects_provider.dart';
import 'geofence_form_screen.dart';

class GeofencingListScreen extends ConsumerWidget {
  const GeofencingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geofences = ref.watch(geofencesProvider);

    return Scaffold(
      backgroundColor: AppColors.white1,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _buildHeaderButton(
          icon: Icons.add,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GeofenceFormScreen()),
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
      body: geofences.isEmpty
          ? const Center(child: Text('لا توجد حدود جغرافية!'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: geofences.length,
              itemBuilder: (context, index) {
                final geofence = geofences[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF1D99BD), width: 2),
                      ),
                      child: Center(
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1D99BD),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      geofence.name,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D99BD),
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('HH:mm:ss yyyy-MM-dd').format(geofence.createdAt),
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 12),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GeofenceFormScreen(geofence: geofence),
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
