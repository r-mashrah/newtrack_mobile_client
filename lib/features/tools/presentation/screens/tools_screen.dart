import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../alerts/presentation/screens/alerts_screen.dart';
import '../../../tasks/presentation/screens/tasks_screen.dart';
import 'geofencing_list_screen.dart';
import 'poi_list_screen.dart';
import 'ruler_screen.dart';
import 'show_point_screen.dart';
import 'gprs_command_screen.dart';
import 'sms_command_screen.dart';

class ToolsScreen extends StatelessWidget {
  static const routeName = '/tools';
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(context),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Alerts & Tasks ──
                _buildCategoryLabel('التنبيهات والمهام'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildLargeCard(
                        context,
                        icon: Icons.notifications_active_rounded,
                        label: 'التنبيهات',
                        description: 'راقب أحداث أسطولك',
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B6B), Color(0xFFEE0979)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onTap: () => Navigator.push(
                          context,
                          _route(const AlertsScreen()),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildLargeCard(
                        context,
                        icon: Icons.task_alt_rounded,
                        label: 'المهام',
                        description: 'جدول ومتابعة المهام',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onTap: () => Navigator.push(
                          context,
                          _route(const TasksScreen()),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ── Map Objects ──
                _buildCategoryLabel('كائنات الخريطة'),
                const SizedBox(height: 12),
                _buildWideCard(
                  context,
                  icon: Icons.hexagon_outlined,
                  color: const Color(0xFF11998E),
                  label: 'السياج الجغرافي',
                  description: 'إنشاء وإدارة المناطق الجغرافية المحمية',
                  badge: 'Geofence',
                  onTap: () => Navigator.push(
                    context,
                    _route(const GeofencingListScreen()),
                  ),
                ),
                const SizedBox(height: 12),
                _buildWideCard(
                  context,
                  icon: Icons.location_pin,
                  color: const Color(0xFFF7971E),
                  label: 'نقاط الاهتمام',
                  description: 'حدد المواقع المهمة على الخريطة',
                  badge: 'POI',
                  onTap: () =>
                      Navigator.push(context, _route(const POIListScreen())),
                ),

                const SizedBox(height: 28),

                // ── Map Tools ──
                _buildCategoryLabel('أدوات الخريطة'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSmallCard(
                        context,
                        icon: Icons.straighten_rounded,
                        label: 'المسطرة',
                        color: const Color(0xFF1D99BD),
                        onTap: () => Navigator.push(
                          context,
                          _route(const RulerScreen()),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildSmallCard(
                        context,
                        icon: Icons.my_location_rounded,
                        label: 'عرض نقطة',
                        color: const Color(0xFF43B89C),
                        onTap: () => Navigator.push(
                          context,
                          _route(const ShowPointScreen()),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ── Commands ──
                _buildCategoryLabel('الأوامر'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildCommandCard(
                        context,
                        icon: Icons.cell_tower_rounded,
                        label: 'أوامر GPRS',
                        color: const Color(0xFF2193B0),
                        onTap: () => Navigator.push(
                          context,
                          _route(const GPRSCommandScreen()),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildCommandCard(
                        context,
                        icon: Icons.sms_rounded,
                        label: 'أوامر SMS',
                        color: const Color(0xFF56ab2f),
                        onTap: () => Navigator.push(
                          context,
                          _route(const SMSCommandScreen()),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: true,
      title: const Text(
        'مركز الأدوات',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppTheme.primaryColor,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryLabel(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildLargeCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -10,
              left: -10,
              child: Icon(
                icon,
                size: 90,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                  const Spacer(),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required String description,
    required String badge,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 14,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommandCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.85), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PageRoute _route(Widget screen) {
    return MaterialPageRoute(builder: (context) => screen);
  }
}
