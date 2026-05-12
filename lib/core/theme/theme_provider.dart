import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/caching_provider.dart';
import '../services/caching_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_provider.freezed.dart';

/// حالة الثيم والألوان
@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState({
    required Color primaryColor,
    required Color secondaryColor,
    required Color accentColor,
    required ThemeMode themeMode,
    required String localeCode, // 'ar' or 'en'
  }) = _ThemeState;

  factory ThemeState.initial() => const ThemeState(
    primaryColor: Color(0xFF2E7D32),
    secondaryColor: Color(0xFF388E3C),
    accentColor: Color(0xFF4CAF50),
    themeMode: ThemeMode.system,
    localeCode: 'ar', // الافتراضي هو العربية
  );
}

/// Notifier لإدارة الثيم والألوان
class ThemeNotifier extends StateNotifier<ThemeState> {
  final CachingService _cachingService;

  static const String _primaryColorKey = 'theme_primary_color';
  static const String _themeModeKey = 'theme_mode';
  static const String _localeCodeKey = 'locale_code';

  ThemeNotifier(this._cachingService) : super(ThemeState.initial()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final primaryColorValue = _cachingService.getInt(_primaryColorKey);
    final themeModeIndex = _cachingService.getInt(_themeModeKey);
    final localeCode = _cachingService.getString(_localeCodeKey);

    var newState = state;

    if (primaryColorValue != null) {
      newState = newState.copyWith(primaryColor: Color(primaryColorValue));
    }

    if (themeModeIndex != null && themeModeIndex >= 0 && themeModeIndex < ThemeMode.values.length) {
      newState = newState.copyWith(themeMode: ThemeMode.values[themeModeIndex]);
    }

    if (localeCode != null) {
      newState = newState.copyWith(localeCode: localeCode);
    }

    state = newState;
  }

  Future<void> _saveSettings() async {
    await _cachingService.setInt(_primaryColorKey, state.primaryColor.value);
    await _cachingService.setInt(_themeModeKey, state.themeMode.index);
    await _cachingService.setString(_localeCodeKey, state.localeCode);
  }

  /// تحديث اللون الرئيسي
  void setPrimaryColor(Color color) {
    state = state.copyWith(primaryColor: color);
    _saveSettings();
  }

  /// تحديث اللون الثانوي
  void setSecondaryColor(Color color) {
    state = state.copyWith(secondaryColor: color);
    // لا نحفظ اللون الثانوي بشكل منفصل، بل يتم حفظه مع setPrimaryColor أو setColorScheme
  }

  /// تحديث اللون الإضافي
  void setAccentColor(Color color) {
    state = state.copyWith(accentColor: color);
    // لا نحفظ اللون الإضافي بشكل منفصل، بل يتم حفظه مع setPrimaryColor أو setColorScheme
  }

  /// تحديث وضع الثيم
  void setLocale(String localeCode) {
    state = state.copyWith(localeCode: localeCode);
    _saveSettings();
  }

  /// تحديث وضع الثيم
  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _saveSettings();
  }

  /// إعادة تعيين الألوان الافتراضية
  void resetToDefaults() {
    state = ThemeState.initial();
    _saveSettings();
  }

  /// تعيين مجموعة ألوان مخصصة
  void setColorScheme({
    required Color primary,
    required Color secondary,
    required Color accent,
  }) {
    state = state.copyWith(
      primaryColor: primary,
      secondaryColor: secondary,
      accentColor: accent,
    );
    _saveSettings();
  }
}

/// Provider لإدارة الثيم
final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  final cachingService = ref.watch(cachingServiceProvider);
  return ThemeNotifier(cachingService);
});

/// Provider لحالة الثيم (للقراءة فقط)
final themeStateProvider = Provider<ThemeState>((ref) {
  return ref.watch(themeNotifierProvider);
});
