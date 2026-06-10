import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = AppTheme.primaryColor;
  static const Color white = Colors.white;
  static const Color white1 = Color(0xFFF5F5F5);
  static const Color black = Colors.black;
  static const Color materialGrey200 = Color(0xFFEEEEEE);
  static const Color materialGrey400 = Color(0xFFBDBDBD);
  static const Color materialGrey700 = Color(0xFF616161);
}

class AppTheme {
  // الألوان الرئيسية - تم التغيير للأزرق/السماوي حسب هوية التطبيق في الصور
  static const Color primaryColor = Color(0xFF03A9F4); // سماوي احترافي
  static const Color secondaryColor = Color(0xFF0288D1);
  static const Color accentColor = Color(0xFF00BCD4);

  // ألوان الحالة
  static const Color onlineColor = Color(0xFF4CAF50);
  static const Color movingColor = Color(0xFF4CAF50);
  static const Color stoppedColor = Color(0xFFFF9800);
  static const Color offlineColor = Color(0xFFF44336);
  static const Color parkedColor = Color(0xFF03A9F4);

  // ألوان الخلفية والنص
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFD32F2F);

  // الثيم الفاتح
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        labelStyle: const TextStyle(fontSize: 14),
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey[200]!),
        ),
        color: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 4,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
        titleSmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54),
        bodyLarge: TextStyle(fontSize: 15, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 13, color: Colors.black54),
        bodySmall: TextStyle(fontSize: 11, color: Colors.grey),
      ),
    );
  }

  // الثيم الداكن
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey[800]!),
        ),
        color: Colors.grey[850],
      ),
    );
  }

  // الدوال المساعدة
  static Color getStatusColor(String status) {
    switch (status) {
      case 'online':
      case 'moving':
        return onlineColor;
      case 'stopped':
        return stoppedColor;
      case 'offline':
        return offlineColor;
      case 'parked':
        return parkedColor;
      default:
        return Colors.grey;
    }
  }

  static IconData getVehicleIcon(String? markerImage) {
    final marker = markerImage?.toLowerCase() ?? '';
    if (marker.contains('truck')) return Icons.local_shipping;
    if (marker.contains('bus')) return Icons.directions_bus;
    if (marker.contains('motorcycle') || marker.contains('bike')) return Icons.two_wheeler;
    if (marker.contains('person') || marker.contains('user')) return Icons.person;
    if (marker.contains('boat') || marker.contains('ship')) return Icons.directions_boat;
    if (marker.contains('tractor')) return Icons.agriculture;
    if (marker.contains('plane')) return Icons.flight;
    return Icons.directions_car;
  }
}

