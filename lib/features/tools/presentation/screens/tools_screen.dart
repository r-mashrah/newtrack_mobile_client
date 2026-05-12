import 'package:flutter/material.dart';
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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'الأدوات',
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader('التنبيهات والمهام'),
          const SizedBox(height: 12),
          _buildToolItem('التنبيهات', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AlertsScreen()))),
          const SizedBox(height: 10),
          _buildToolItem('المهام', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TasksScreen()))),
          const SizedBox(height: 24),
          
          _buildSectionHeader('كائنات الخريطة'),
          const SizedBox(height: 12),
          _buildToolItem('السياج الجغرافي', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GeofencingListScreen()))),
          const SizedBox(height: 10),
          _buildToolItem('نقاط الاهتمام', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const POIListScreen()))),
          const SizedBox(height: 24),
          
          _buildSectionHeader('أدوات الخريطة'),
          const SizedBox(height: 12),
          _buildToolItem('المسطرة', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RulerScreen()))),
          const SizedBox(height: 10),
          _buildToolItem('إظهار نقطة', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ShowPointScreen()))),
          const SizedBox(height: 24),
          
          _buildSectionHeader('الأوامر'),
          const SizedBox(height: 12),
          _buildToolItem('أوامر GPRS', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GPRSCommandScreen()))),
          const SizedBox(height: 10),
          _buildToolItem('أوامر SMS', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SMSCommandScreen()))),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildToolItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const Spacer(),
            const Icon(Icons.chevron_left, size: 18, color: AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }
}
