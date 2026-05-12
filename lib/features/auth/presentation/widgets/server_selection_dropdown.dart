import 'package:flutter/material.dart';
import '../../../../generated/l10n/app_localizations.dart';

class ServerSelectionDropdown extends StatelessWidget {
  final String selectedServer;
  final ValueChanged<String> onServerChanged;
  final String title;

  const ServerSelectionDropdown({
    Key? key,
    required this.selectedServer,
    required this.onServerChanged,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return DropdownButtonFormField<String>(
      value: selectedServer,
      decoration: InputDecoration(
        labelText: title,
        hintText: title,
        prefixIcon: const Icon(Icons.cloud),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: [
        DropdownMenuItem(
          value: 'Production',
          child: Text(loc.productionServer),
        ),
        DropdownMenuItem(
          value: 'Staging',
          child: Text(loc.stagingServer),
        ),
        DropdownMenuItem(
          value: 'Development',
          child: Text(loc.developmentServer),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          onServerChanged(value);
        }
      },
    );
  }
}
