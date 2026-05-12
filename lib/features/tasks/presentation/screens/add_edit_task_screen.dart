import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/task_model.dart';
import '../providers/tasks_provider.dart';
import '../widgets/location_picker_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddEditTaskScreen extends ConsumerStatefulWidget {
  final TaskModel? task;
  const AddEditTaskScreen({super.key, this.task});

  @override
  ConsumerState<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends ConsumerState<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _invoiceController;
  late TextEditingController _commentController;
  
  String? _selectedDeviceId;
  String _priority = 'Medium';
  
  String _pickupAddress = '(مطلوب)';
  LatLng? _pickupLocation;
  DateTime _pickupFrom = DateTime.now();
  DateTime _pickupTo = DateTime.now().add(const Duration(hours: 2));
  
  String _deliveryAddress = '(مطلوب)';
  LatLng? _deliveryLocation;
  DateTime _deliveryFrom = DateTime.now().add(const Duration(hours: 3));
  DateTime _deliveryTo = DateTime.now().add(const Duration(hours: 5));

  final List<String> _devices = ['Toyota Camry', 'Mercedes Actros', 'Volvo FH16'];
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _invoiceController = TextEditingController(text: widget.task?.invoiceNumber ?? '');
    _commentController = TextEditingController(text: widget.task?.comment ?? '');
    if (widget.task != null) {
      _selectedDeviceId = widget.task!.deviceName;
      _priority = widget.task!.priority;
      _pickupAddress = widget.task!.pickupAddress;
      _pickupLocation = LatLng(widget.task!.pickupLat, widget.task!.pickupLng);
      _pickupFrom = widget.task!.pickupFromDate;
      _pickupTo = widget.task!.pickupToDate;
      _deliveryAddress = widget.task!.deliveryAddress;
      _deliveryLocation = LatLng(widget.task!.deliveryLat, widget.task!.deliveryLng);
      _deliveryFrom = widget.task!.deliveryFromDate;
      _deliveryTo = widget.task!.deliveryToDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _invoiceController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white1,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.save, color: AppColors.primary),
          onPressed: _saveTask,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        title: Text(
          widget.task == null ? 'Add Task' : 'Edit Task',
          style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('الإعدادات الرئيسية'),
              _buildDropdownField('الجهاز', _selectedDeviceId, _devices, (val) => setState(() => _selectedDeviceId = val)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Title (required)', border: UnderlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _invoiceController,
                decoration: const InputDecoration(hintText: 'رقم الفاتورة', border: UnderlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(hintText: 'Comment', border: UnderlineInputBorder()),
              ),
              const SizedBox(height: 16),
              _buildDropdownField('أفضلية', _priority, _priorities, (val) => setState(() => _priority = val!)),
              
              const SizedBox(height: 24),
              _buildSectionHeader('الاستلام'),
              _buildLocationTile('عنوان الاستلام', _pickupAddress, () => _pickLocation(true)),
              _buildDateTimeTile('من', _pickupFrom, (dt) => setState(() => _pickupFrom = dt)),
              _buildDateTimeTile('إلى', _pickupTo, (dt) => setState(() => _pickupTo = dt)),
              
              const SizedBox(height: 24),
              _buildSectionHeader('التسليم'),
              _buildLocationTile('عنوان التسليم', _deliveryAddress, () => _pickLocation(false)),
              _buildDateTimeTile('من', _deliveryFrom, (dt) => setState(() => _deliveryFrom = dt)),
              _buildDateTimeTile('إلى', _deliveryTo, (dt) => setState(() => _deliveryTo = dt)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
      child: Row(
        children: [
          const Icon(Icons.chevron_right, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: Text('(مطلوب) $label'),
                items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildLocationTile(String label, String address, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
        child: Row(
          children: [
            const Icon(Icons.chevron_right, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(child: Text(address, style: TextStyle(color: address.contains('مطلوب') ? Colors.blue : Colors.black))),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeTile(String label, DateTime dateTime, Function(DateTime) onSelected) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(context: context, initialDate: dateTime, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
        if (date != null) {
          final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(dateTime));
          if (time != null) {
            onSelected(DateTime(date.year, date.month, date.day, time.hour, time.minute));
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
        child: Row(
          children: [
            const Icon(Icons.chevron_right, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(child: Text(DateFormat('yyyy-MM-dd HH:mm').format(dateTime))),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  void _pickLocation(bool isPickup) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerWidget(
          onLocationSelected: (pos, addr) {
            setState(() {
              if (isPickup) {
                _pickupLocation = pos;
                _pickupAddress = addr; // سيتم عرض العنوان النصي فقط للمستخدم
              } else {
                _deliveryLocation = pos;
                _deliveryAddress = addr; // سيتم عرض العنوان النصي فقط للمستخدم
              }
            });
          },
        ),
      ),
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = TaskModel(
        id: widget.task?.id ?? '',
        title: _titleController.text,
        deviceId: 'dev_id',
        deviceName: _selectedDeviceId ?? 'Unknown',
        invoiceNumber: _invoiceController.text,
        address: _pickupAddress,
        comment: _commentController.text,
        priority: _priority,
        pickupAddress: _pickupAddress,
        pickupLat: _pickupLocation?.latitude ?? 0,
        pickupLng: _pickupLocation?.longitude ?? 0,
        pickupFromDate: _pickupFrom,
        pickupToDate: _pickupTo,
        deliveryAddress: _deliveryAddress,
        deliveryLat: _deliveryLocation?.latitude ?? 0,
        deliveryLng: _deliveryLocation?.longitude ?? 0,
        deliveryFromDate: _deliveryFrom,
        deliveryToDate: _deliveryTo,
      );

      if (widget.task == null) {
        ref.read(tasksProvider.notifier).addTask(newTask);
      } else {
        ref.read(tasksProvider.notifier).updateTask(newTask);
      }
      Navigator.pop(context);
    }
  }
}
