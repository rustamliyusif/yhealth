import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/models/weight_record_model.dart';
import '../../../l10n/app_localizations.dart';

/// Modal dialog for logging or editing a body weight measurement.
class AddEditWeightDialog extends StatefulWidget {
  final WeightRecordModel? existingRecord;
  final double currentWeight;
  final Function(double weightKg, String? notes, DateTime date) onSave;

  const AddEditWeightDialog({
    super.key,
    this.existingRecord,
    required this.currentWeight,
    required this.onSave,
  });

  @override
  State<AddEditWeightDialog> createState() => _AddEditWeightDialogState();
}

class _AddEditWeightDialogState extends State<AddEditWeightDialog> {
  late TextEditingController _weightController;
  late TextEditingController _notesController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final initialWeight = widget.existingRecord?.weightKg ?? widget.currentWeight;
    _weightController = TextEditingController(text: initialWeight.toStringAsFixed(1));
    _notesController = TextEditingController(text: widget.existingRecord?.notes ?? '');
    _selectedDate = widget.existingRecord?.createdAt ?? DateTime.now();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.existingRecord != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Weight' : l10n.logWeight),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weight Input
            TextField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                suffixText: 'kg',
                prefixIcon: Icon(Icons.monitor_weight_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Date Picker Row
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  DateFormat('yyyy-MM-dd').format(_selectedDate),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                  child: const Text('Change Date'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Notes Input
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'e.g. Morning before breakfast',
                prefixIcon: Icon(Icons.edit_note_outlined),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final weight = double.tryParse(_weightController.text.trim());
            if (weight == null || weight <= 20.0 || weight >= 300.0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid weight (20.0 - 300.0 kg)')),
              );
              return;
            }
            final notes = _notesController.text.trim();
            widget.onSave(weight, notes.isEmpty ? null : notes, _selectedDate);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
