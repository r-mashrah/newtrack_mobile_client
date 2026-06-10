import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/command_models.dart';

/// Debug-only panel showing request/response details for command API calls.
class CommandDiagnosticPanel extends StatelessWidget {
  final CommandDiagnostic? diagnostic;

  const CommandDiagnosticPanel({super.key, this.diagnostic});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode || diagnostic == null) return const SizedBox.shrink();

    final d = diagnostic!;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bug_report, color: Colors.orange.shade400, size: 16),
              const SizedBox(width: 6),
              Text(
                'Diagnostic Mode (Debug)',
                style: TextStyle(
                  color: Colors.orange.shade400,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _row('Method', d.method),
          _row('URL', d.url),
          _row('Status', d.statusCode?.toString() ?? '—'),
          _row('Payload', d.requestPayload.toString()),
          if (d.validationErrors.isNotEmpty)
            _row('Validation', d.validationErrors.toString()),
          if (d.responseBody != null)
            _row('Response', d.responseBody.toString()),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 10, color: Colors.white70, height: 1.4),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

/// Banner shown when SMS gateway is disabled on the server.
class SmsGatewayBanner extends StatelessWidget {
  final bool enabled;
  final bool isLoading;

  const SmsGatewayBanner({
    super.key,
    required this.enabled,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('جاري التحقق من بوابة SMS...', style: TextStyle(fontSize: 12)),
            SizedBox(width: 8),
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      );
    }

    if (enabled) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade700, size: 18),
            const Spacer(),
            Text(
              'بوابة SMS مفعّلة على الخادم',
              style: TextStyle(
                color: Colors.green.shade800,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 20),
          const Spacer(),
          Expanded(
            flex: 10,
            child: Text(
              'بوابة SMS غير مفعّلة على الخادم.\n'
              'لن يتم إرسال الرسائل حتى يتم تفعيلها من لوحة التحكم.',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.red.shade800,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state when no devices are available for commands.
class CommandEmptyDevicesState extends StatelessWidget {
  const CommandEmptyDevicesState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.devices_other, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            'لا توجد أجهزة متاحة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'أضف جهازاً أولاً أو تحقق من صلاحياتك',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

/// Template section with loading, error+retry, and empty states.
class CommandTemplateSection extends StatelessWidget {
  final AsyncValue<dynamic> templatesAsync;
  final Widget Function(List<dynamic> templates) builder;
  final VoidCallback onRetry;

  const CommandTemplateSection({
    super.key,
    required this.templatesAsync,
    required this.builder,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return templatesAsync.when(
      data: (templates) {
        if (templates.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey.shade500, size: 18),
                const Spacer(),
                Text(
                  'لا توجد قوالب — يمكنك إرسال رسالة/أمر مخصص',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          );
        }
        return builder(templates);
      },
      loading: () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(width: 12),
            Text('جاري تحميل القوالب...', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      error: (_, __) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          children: [
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('إعادة المحاولة'),
            ),
            const Spacer(),
            Text(
              'تعذر تحميل القوالب',
              style: TextStyle(color: Colors.orange.shade800, fontSize: 13),
            ),
            const SizedBox(width: 8),
            Icon(Icons.warning_amber, color: Colors.orange.shade700, size: 18),
          ],
        ),
      ),
    );
  }
}

void showCommandSnackBar(
  BuildContext context, {
  required String message,
  required bool isError,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 4),
    ),
  );
}
