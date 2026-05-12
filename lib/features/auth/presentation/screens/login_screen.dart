import 'package:flutter/material.dart';
import '../../../../generated/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';
import '../widgets/server_selection_dropdown.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedServer = 'Production';
  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      ref.read(authNotifierProvider.notifier).login(
        username: _usernameController.text,
        password: _passwordController.text,
        server: _selectedServer,
        rememberMe: _rememberMe,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    
    ref.listen<AuthState>(
      authNotifierProvider,
      (previous, next) {
        next.when(
          initial: () {},
          loading: () => setState(() => _isLoading = true),
          authenticated: (user) {
            setState(() => _isLoading = false);
            context.go('/main-map');
          },
          unauthenticated: () => setState(() => _isLoading = false),
          error: (message, code, previousUser) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${loc.errorPrefix}: $message'),
                backgroundColor: Colors.red,
              ),
            );
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400), // تصغير حجم العرض ليكون متناسقاً
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // الشعار - تم تعديله ليكون أكثر احترافية
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.gps_fixed,
                        size: 40,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    loc.loginTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // حقل اسم المستخدم
                  TextFormField(
                    controller: _usernameController,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      labelText: loc.usernameLabel,
                      prefixIcon: const Icon(Icons.person_outline, size: 20),
                    ),
                    validator: (value) => (value == null || value.isEmpty) ? loc.validationUsernameRequired : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // حقل كلمة المرور
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      labelText: loc.passwordLabel,
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (value) => (value == null || value.isEmpty) ? loc.validationPasswordRequired : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // اختيار الخادم
                  ServerSelectionDropdown(
                    selectedServer: _selectedServer,
                    onServerChanged: (value) => setState(() => _selectedServer = value),
                    title: loc.serverSelection,
                  ),
                  const SizedBox(height: 12),
                  
                  // تذكرني
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          activeColor: AppTheme.primaryColor,
                          onChanged: (value) => setState(() => _rememberMe = value ?? false),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(loc.rememberMe, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text(loc.forgotPassword, style: const TextStyle(fontSize: 13, color: AppTheme.primaryColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // زر تسجيل الدخول
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(loc.loginButton, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 32),
                  
                  // معلومات تجريبية بشكل مبسط
                  Text(
                    'NewTrack Mobile Client',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
