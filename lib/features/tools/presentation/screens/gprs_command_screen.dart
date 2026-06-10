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

class GPRSCommandScreen extends ConsumerStatefulWidget {
  final DeviceEntity? preSelectedDevice;
  const GPRSCommandScreen({super.key, this.preSelectedDevice});

  @override
  ConsumerState<GPRSCommandScreen> createState() => _GPRSCommandScreenState();
}

class _GPRSCommandScreenState extends ConsumerState<GPRSCommandScreen> {
  DeviceEntity? _selectedDevice;
  SmsTemplate? _selectedTemplate;
  CommandTypeOption? _selectedCommandType;
  bool _autoSendWhenOnline = false;
  bool _showAdvanced = false;
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

  List<DeviceEntity> _filterGprsDevices(
    List<DeviceEntity> allDevices,
    SendCommandData? commandData,
  ) {
    if (commandData == null || commandData.devicesGprs.isEmpty) {
      return allDevices;
    }
    final allowedIds =
        commandData.devicesGprs.map((d) => d.id.toString()).toSet();
    return allDevices.where((d) => allowedIds.contains(d.id)).toList();
  }

  String _resolveCommandType() {
    if (_selectedTemplate != null) return 'custom';
    return _selectedCommandType?.id ?? 'custom';
  }

  String? _resolveMessage() {
    if (_selectedTemplate != null) {
      final content = _selectedTemplate!.content.trim();
      return content.isEmpty ? null : content;
    }
    final type = _resolveCommandType();
    if (type != 'custom') return null;
    final custom = _messageController.text.trim();
    return custom.isEmpty ? null : custom;
  }

  Future<void> _sendCommand() async {
    if (_selectedDevice == null) {
      showCommandSnackBar(context, message: 'الرجاء اختيار المركبة أولاً', isError: true);
      return;
    }

    final commandType = _resolveCommandType();
    final message = _resolveMessage();

    if (commandType == 'custom' && (message == null || message.isEmpty)) {
      showCommandSnackBar(
        context,
        message: _selectedTemplate != null
            ? 'القالب المختار لا يحتوي على نص أمر'
            : 'الرجاء كتابة نص الأمر أو اختيار نوع أمر جاهز',
        isError: true,
      );
      return;
    }

    final result = await ref.read(gprsCommandProvider.notifier).send(
          deviceId: _selectedDevice!.id,
          commandType: commandType,
          message: message,
          autoSendWhenOnline: _autoSendWhenOnline,
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
        _selectedCommandType = null;
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
    final gprsDevices = commandDataAsync.maybeWhen(
      data: (data) => _filterGprsDevices(allDevices, data),
      orElse: () => allDevices,
    );

    final gprsTemplatesAsync = ref.watch(gprsTemplatesProvider);
    final commandTypesAsync = ref.watch(commandTypesProvider);
    final sendState = ref.watch(gprsCommandProvider);
    final isSending = sendState.isSending;

    final isCustomType = _resolveCommandType() == 'custom';
    final deviceOffline = _selectedDevice != null &&
        _selectedDevice!.status != 'online' &&
        _selectedDevice!.status != 'moving';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'إرسال أمر GPRS',
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
                    if (deviceOffline) _buildOfflineWarning(),

                    _buildSectionTitle('المركبة المستهدفة'),
                    const SizedBox(height: 12),
                    if (gprsDevices.isEmpty)
                      const CommandEmptyDevicesState()
                    else
                      _buildDeviceSelectorCard(gprsDevices),

                    const SizedBox(height: 28),
                    _buildSectionTitle('نوع الأمر'),
                    const SizedBox(height: 12),
                    commandTypesAsync.when(
                      data: (types) => _buildCommandTypeSelector(types),
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      error: (_, __) => _buildCommandTypeFallback(),
                    ),

                    const SizedBox(height: 28),
                    _buildSectionTitle('قالب الأمر (اختياري)'),
                    const SizedBox(height: 12),
                    CommandTemplateSection(
                      templatesAsync: gprsTemplatesAsync,
                      onRetry: () => ref.invalidate(sendCommandDataProvider),
                      builder: (templates) =>
                          _buildTemplateSelectorCard(List<SmsTemplate>.from(templates)),
                    ),

                    if (isCustomType && _selectedTemplate == null) ...[
                      const SizedBox(height: 28),
                      _buildSectionTitle('نص الأمر (مخصص)'),
                      const SizedBox(height: 12),
                      _buildMessageInput(),
                    ],

                    const SizedBox(height: 20),
                    _buildAdvancedSection(deviceOffline),

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
            _buildBottomSendButton(isSending),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineWarning() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.orange.shade800, size: 18),
          const Spacer(),
          Expanded(
            flex: 10,
            child: Text(
              'الجهاز غير متصل — فعّل "الإرسال عند الاتصال" في الإعدادات المتقدمة',
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.orange.shade900, fontSize: 12),
            ),
          ),
        ],
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

  Widget _buildCommandTypeSelector(List<CommandTypeOption> types) {
    final displayLabel = _selectedTemplate != null
        ? 'مخصص (من القالب)'
        : (_selectedCommandType?.label ?? 'اختر نوع الأمر');

    return InkWell(
      onTap: _selectedTemplate != null
          ? null
          : () => _showCommandTypePicker(types),
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
            if (_selectedTemplate == null)
              const Icon(Icons.keyboard_arrow_down, color: Colors.grey)
            else
              Icon(Icons.lock_outline, color: Colors.grey.shade400, size: 20),
            const Spacer(),
            Text(
              displayLabel,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _selectedTemplate != null
                    ? Colors.grey
                    : AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.settings_remote, color: AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildCommandTypeFallback() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: () => ref.invalidate(sendCommandDataProvider),
            child: const Text('إعادة المحاولة'),
          ),
          const Spacer(),
          const Text(
            'أمر مخصص (تعذر تحميل الأنواع)',
            style: TextStyle(color: Colors.orange, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateSelectorCard(List<SmsTemplate> templates) {
    final displayName = _selectedTemplate?.name ?? 'بدون قالب';
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
            const Icon(Icons.terminal, color: AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: _messageController,
        maxLines: 5,
        textAlign: TextAlign.right,
        textDirection: TextDirection.ltr,
        decoration: InputDecoration(
          hintText: 'اكتب نص الأمر هنا (للأوامر المخصصة)...',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildAdvancedSection(bool deviceOffline) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: () => setState(() => _showAdvanced = !_showAdvanced),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                _showAdvanced ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                'إعدادات متقدمة',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (_showAdvanced) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'الإرسال عند اتصال الجهاز',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 14),
              ),
              subtitle: Text(
                deviceOffline
                    ? 'موصى به — الجهاز حالياً غير متصل'
                    : 'يُخزّن الأمر ويُرسل عند إعادة الاتصال',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              value: _autoSendWhenOnline,
              activeColor: AppTheme.primaryColor,
              onChanged: (val) => setState(() => _autoSendWhenOnline = val),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoAlert() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'ملاحظة هامة',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'الحقول المطلوبة: device_id + type (+ message للأوامر المخصصة).\n'
                  'يمكنك استخدام [%IMEI%] في الأوامر النصية RAW.\n'
                  'القوالب اختيارية — عند اختيار قالب يُرسل type=custom.',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.info_outline, color: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildBottomSendButton(bool isSending) {
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
          onPressed: isSending ? null : _sendCommand,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
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
                      'إرسال الأمر',
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

  void _showCommandTypePicker(List<CommandTypeOption> types) {
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
                'اختر نوع الأمر',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: types.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final t = types[index];
                  final isSelected = _selectedCommandType?.id == t.id;
                  return ListTile(
                    title: Text(
                      t.label,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      t.id,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                    ),
                    leading: isSelected
                        ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedCommandType = t;
                        if (!t.isCustom) _messageController.clear();
                      });
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
                'اختر قالب الأمر',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: const Text('بدون قالب', textAlign: TextAlign.right),
                    leading: _selectedTemplate == null
                        ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                        : null,
                    onTap: () {
                      setState(() => _selectedTemplate = null);
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(height: 1),
                  ...templates.map((t) {
                    final isSelected = _selectedTemplate?.id == t.id;
                    return Column(
                      children: [
                        ListTile(
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
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: isSelected
                              ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedTemplate = t;
                              _selectedCommandType = null;
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
