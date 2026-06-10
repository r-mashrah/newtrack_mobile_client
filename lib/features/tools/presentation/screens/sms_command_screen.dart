import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/setup_models.dart';
import '../../../../data/models/command_models.dart';
import '../../../main_map/presentation/providers/devices_provider.dart';
import '../../../../domain/entities/device_entity.dart';
import '../../../setup/presentation/providers/setup_provider.dart';
import '../widgets/command_widgets.dart';

class SMSCommandScreen extends ConsumerStatefulWidget {
  final DeviceEntity? preSelectedDevice;
  const SMSCommandScreen({super.key, this.preSelectedDevice});

  @override
  ConsumerState<SMSCommandScreen> createState() => _SMSCommandScreenState();
}

class _SMSCommandScreenState extends ConsumerState<SMSCommandScreen> {
  DeviceEntity? _selectedDevice;
  SmsTemplate? _selectedTemplate;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDevice = widget.preSelectedDevice;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  List<DeviceEntity> _filterSmsDevices(
    List<DeviceEntity> allDevices,
    SendCommandData? commandData,
  ) {
    if (commandData == null || commandData.devicesSms.isEmpty) {
      return allDevices;
    }
    final allowedIds =
        commandData.devicesSms.map((d) => d.id.toString()).toSet();
    return allDevices.where((d) => allowedIds.contains(d.id)).toList();
  }

  String? _resolveMessage() {
    if (_selectedTemplate != null) {
      final content = _selectedTemplate!.content.trim();
      if (content.isEmpty) {
        return null;
      }
      return content;
    }
    final custom = _messageController.text.trim();
    return custom.isEmpty ? null : custom;
  }

  Future<void> _sendCommand() async {
    if (_selectedDevice == null) {
      showCommandSnackBar(context, message: 'الرجاء اختيار المركبة أولاً', isError: true);
      return;
    }

    final message = _resolveMessage();
    if (message == null) {
      showCommandSnackBar(
        context,
        message: _selectedTemplate != null
            ? 'القالب المختار لا يحتوي على نص رسالة'
            : 'الرجاء كتابة نص الرسالة',
        isError: true,
      );
      return;
    }

    final gatewayState = ref.read(smsGatewaySettingsProvider);
    final gatewayEnabled = gatewayState.maybeWhen(
      data: (s) => s.enabled,
      orElse: () => false,
    );
    if (!gatewayEnabled) {
      showCommandSnackBar(
        context,
        message: 'بوابة SMS غير مفعّلة على الخادم — لا يمكن الإرسال',
        isError: true,
      );
      return;
    }

    final result = await ref.read(smsCommandProvider.notifier).send(
          deviceId: _selectedDevice!.id,
          message: message,
        );

    if (!mounted) return;

    showCommandSnackBar(
      context,
      message: result.message,
      isError: !result.success,
    );

    if (result.success) {
      setState(() {
        _selectedTemplate = null;
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final devicesState = ref.watch(devicesNotifierProvider);
    final allDevices = devicesState.maybeWhen(
      loaded: (devices, _, __, ___) => devices,
      orElse: () => <DeviceEntity>[],
    );

    final commandDataAsync = ref.watch(sendCommandDataProvider);
    final smsDevices = commandDataAsync.maybeWhen(
      data: (data) => _filterSmsDevices(allDevices, data),
      orElse: () => allDevices,
    );

    final smsTemplatesAsync = ref.watch(smsTemplatesProvider);
    final gatewayAsync = ref.watch(smsGatewaySettingsProvider);
    final sendState = ref.watch(smsCommandProvider);
    final isSending = sendState.isSending;
    final gatewayEnabled = gatewayAsync.maybeWhen(
      data: (s) => s.enabled,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'إرسال أمر SMS',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    gatewayAsync.when(
                      data: (s) => SmsGatewayBanner(enabled: s.enabled),
                      loading: () => const SmsGatewayBanner(enabled: false, isLoading: true),
                      error: (_, __) => const SmsGatewayBanner(enabled: false),
                    ),
                    const SizedBox(height: 20),

                    _buildSectionTitle('المركبة المستهدفة'),
                    const SizedBox(height: 12),
                    if (smsDevices.isEmpty)
                      const CommandEmptyDevicesState()
                    else
                      _buildDeviceSelectorCard(smsDevices),

                    const SizedBox(height: 28),
                    _buildSectionTitle('قالب الرسالة (اختياري)'),
                    const SizedBox(height: 12),
                    CommandTemplateSection(
                      templatesAsync: smsTemplatesAsync,
                      onRetry: () => ref.invalidate(sendCommandDataProvider),
                      builder: (templates) =>
                          _buildTemplateSelectorCard(List<SmsTemplate>.from(templates)),
                    ),

                    const SizedBox(height: 28),
                    _buildSectionTitle(
                      _selectedTemplate != null ? 'معاينة نص القالب' : 'نص الرسالة',
                    ),
                    const SizedBox(height: 12),
                    _buildMessageInput(),

                    const SizedBox(height: 24),
                    _buildInfoAlert(),

                    if (kDebugMode)
                      CommandDiagnosticPanel(
                        diagnostic: sendState.lastResult?.diagnostic,
                      ),
                  ],
                ),
              ),
            ),
            _buildBottomSendButton(isSending, gatewayEnabled),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildDeviceSelectorCard(List<DeviceEntity> devices) {
    return InkWell(
      onTap: () => _showDevicePicker(devices),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            const Spacer(),
            if (_selectedDevice != null) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _selectedDevice!.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  _buildConnectionBadge(_selectedDevice!),
                ],
              ),
              const SizedBox(width: 16),
              _buildDeviceIcon(),
            ] else ...[
              const Text(
                'اضغط لاختيار المركبة',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(width: 16),
              _buildDeviceIcon(unselected: true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionBadge(DeviceEntity device) {
    final online = device.status == 'online' || device.status == 'moving';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          online ? 'متصل' : 'غير متصل',
          style: TextStyle(fontSize: 12, color: online ? Colors.green : Colors.grey),
        ),
        const SizedBox(width: 4),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: online ? Colors.green : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceIcon({bool unselected = false}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: unselected
            ? Colors.grey.shade100
            : AppTheme.primaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        unselected ? Icons.device_unknown : Icons.directions_car,
        color: unselected ? Colors.grey : AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildTemplateSelectorCard(List<SmsTemplate> templates) {
    final displayName = _selectedTemplate?.name ?? 'رسالة مخصصة';
    return InkWell(
      onTap: () => _showTemplatePicker(templates),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            const Spacer(),
            Text(
              displayName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.message, color: AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    final isTemplateSelected = _selectedTemplate != null;
    return Container(
      decoration: BoxDecoration(
        color: isTemplateSelected ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: _messageController,
        maxLines: 5,
        readOnly: isTemplateSelected,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          hintText: isTemplateSelected
              ? (_selectedTemplate?.content ?? 'لا يوجد نص في القالب')
              : 'اكتب نص الرسالة هنا...',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildInfoAlert() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'معلومات عن SMS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'الحقول المطلوبة: المركبة + نص الرسالة.\n'
                  'القوالب اختيارية — عند اختيار قالب يُرسل محتواه مباشرة.\n'
                  'يجب أن تكون بوابة SMS مفعّلة على الخادم.',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.sms, color: Colors.green.shade700),
        ],
      ),
    );
  }

  Widget _buildBottomSendButton(bool isSending, bool gatewayEnabled) {
    final canSend = !isSending && gatewayEnabled;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: canSend ? _sendCommand : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
          ),
          child: isSending
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'إرسال SMS',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.send),
                  ],
                ),
        ),
      ),
    );
  }

  void _showDevicePicker(List<DeviceEntity> devices) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'اختر المركبة المستهدفة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: devices.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final d = devices[index];
                  final isSelected = _selectedDevice?.id == d.id;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    trailing: const Icon(Icons.directions_car, color: Colors.grey),
                    title: Text(
                      d.name,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(d.plateNumber ?? '', textAlign: TextAlign.right),
                    leading: isSelected
                        ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                        : null,
                    selected: isSelected,
                    selectedTileColor: AppTheme.primaryColor.withOpacity(0.05),
                    onTap: () {
                      setState(() => _selectedDevice = d);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTemplatePicker(List<SmsTemplate> templates) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'اختر قالب الرسالة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    trailing: const Icon(Icons.edit, color: Colors.grey),
                    title: const Text(
                      'رسالة مخصصة',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'اكتب نص الرسالة يدوياً',
                      textAlign: TextAlign.right,
                    ),
                    leading: _selectedTemplate == null
                        ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                        : null,
                    selected: _selectedTemplate == null,
                    selectedTileColor: AppTheme.primaryColor.withOpacity(0.05),
                    onTap: () {
                      setState(() {
                        _selectedTemplate = null;
                        _messageController.clear();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  if (templates.isNotEmpty) const Divider(height: 1),
                  ...templates.map((t) {
                    final isSelected = _selectedTemplate?.id == t.id;
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          trailing: const Icon(Icons.message, color: Colors.grey),
                          title: Text(
                            t.name,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            t.content,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: isSelected
                              ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                              : null,
                          selected: isSelected,
                          selectedTileColor: AppTheme.primaryColor.withOpacity(0.05),
                          onTap: () {
                            setState(() {
                              _selectedTemplate = t;
                              _messageController.text = t.content;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        const Divider(height: 1),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
