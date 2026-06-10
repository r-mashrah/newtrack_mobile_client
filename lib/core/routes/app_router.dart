import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// استيراد الشاشات
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/providers/auth_state.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/main_map/presentation/screens/main_map_screen.dart';
import '../../features/devices/presentation/screens/devices_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/alerts/presentation/screens/alerts_screen.dart';
import '../../features/tools/presentation/screens/tools_screen.dart';
import '../../features/setup/presentation/screens/setup_screen.dart';
import '../../features/devices/presentation/screens/add_device_screen.dart';
import '../../features/devices/presentation/screens/device_details_screen.dart';
import '../../features/groups/presentation/screens/groups_screen.dart';
import '../../domain/entities/device_entity.dart';

// ==================== مفوض التوجيه ====================

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // المسار الأولي
    initialLocation: SplashScreen.routeName,

    // معالج الأخطاء
    errorBuilder: (context, state) => ErrorScreen(error: state.error),

    // المسارات - تم إزالة ShellRoute لإلغاء شريط التنقل السفلي نهائياً
    routes: [
      // شاشة التحميل
      GoRoute(
        path: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),

      // شاشة تسجيل الدخول
      GoRoute(
        path: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),

      // الخريطة الرئيسية
      GoRoute(
        path: MainMapScreen.routeName,
        builder: (context, state) => const MainMapScreen(),
      ),

      // قائمة الأجهزة
      GoRoute(
        path: DevicesScreen.routeName,
        builder: (context, state) => const DevicesScreen(),
      ),

      // سجل المسار
      GoRoute(
        path: HistoryScreen.routeName,
        builder: (context, state) => const HistoryScreen(),
      ),

      // التنبيهات
      GoRoute(
        path: AlertsScreen.routeName,
        builder: (context, state) => const AlertsScreen(),
      ),

      // الأدوات
      GoRoute(
        path: ToolsScreen.routeName,
        builder: (context, state) => const ToolsScreen(),
      ),

      // الإعدادات
      GoRoute(
        path: SetupScreen.routeName,
        builder: (context, state) => const SetupScreen(),
      ),

      // إضافة جهاز جديد
      GoRoute(
        path: AddDeviceScreen.routeName,
        builder: (context, state) {
          final device = state.extra as DeviceEntity?;
          return AddDeviceScreen(device: device);
        },
      ),

      // تفاصيل الجهاز
      GoRoute(
        path: '/device_details/:id',
        builder: (context, state) {
          final deviceId = state.pathParameters['id']!;
          return DeviceDetailsScreen(deviceId: deviceId);
        },
      ),

      // المجموعات
      GoRoute(
        path: GroupsScreen.routeName,
        builder: (context, state) => const GroupsScreen(),
      ),
    ],

    // معالج التوجيه
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final isAuthenticated = authState.isAuthenticated;

      // المسارات التي لا تتطلب مصادقة
      final publicRoutes = [SplashScreen.routeName, LoginScreen.routeName];

      // التحقق من حالة المصادقة
      if (!isAuthenticated && !publicRoutes.contains(state.path)) {
        return LoginScreen.routeName;
      }

      if (isAuthenticated && state.path == LoginScreen.routeName) {
        return MainMapScreen.routeName;
      }

      return null;
    },

    // المراقبة
    refreshListenable: RouterRefreshListenable(ref),
  );
});

// ==================== مفوض تحديث التوجيه ====================

class RouterRefreshListenable extends ChangeNotifier {
  RouterRefreshListenable(Ref ref) {
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      notifyListeners();
    });
  }
}

// ==================== شاشة الخطأ ====================

class ErrorScreen extends StatelessWidget {
  final Exception? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('حدث خطأ في التوجيه', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            if (error != null)
              Text(
                error.toString(),
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.go(MainMapScreen.routeName);
              },
              icon: const Icon(Icons.home),
              label: const Text('العودة للرئيسية'),
            ),
          ],
        ),
      ),
    );
  }
}
