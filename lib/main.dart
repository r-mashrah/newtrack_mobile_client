import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routes/app_router.dart';
import 'core/providers/caching_provider.dart';
import 'core/services/caching_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cachingService = CachingService();
  await cachingService.init();

  runApp(
    ProviderScope(
      overrides: [
        cachingServiceProvider.overrideWithValue(cachingService),
      ],
      child: const MyApp(),
    ),
  );
}

void main() {
  bootstrap();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeState = ref.watch(themeNotifierProvider);
    
    // نستخدم العربية كافتراضية إذا لم تكن محددة
    final locale = Locale(themeState.localeCode == 'en' ? 'en' : 'ar');

    return MaterialApp.router(
      title: 'NewTrack',
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      debugShowCheckedModeBanner: false,
      // نستخدم الثيم الموحد من AppTheme مباشرة دون تلاعب بالألوان
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeState.themeMode,
      routerConfig: router,
      locale: locale,
      supportedLocales: const [
        Locale('ar', ''),
        Locale('en', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // ضمان اتجاه RTL للعربية
      builder: (context, child) {
        return Directionality(
          textDirection: locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
    );
  }
}
