import 'package:flutter/material.dart';
import '../../../core/models/sleep_record_model.dart';
import '../../../core/theme/app_colors.dart';

class AddEditSleepDialog extends StatefulWidget {
  final SleepRecordModel? initialRecord;
  final Function(DateTime bedtime, DateTime wakeTime, String date, String? notes, int efficiency) onSave;

  const AddEditSleepDialog({
    super.key,
    this.initialRecord,
    required this.onSave,
  });

  @override
  State<AddEditSleepDialog> createState() => _AddEditSleepDialogState();
}

class _AddEditSleepDialogState extends State<AddEditSleepDialog> {
  late DateTime _referenceDate;
  late TimeOfDay _bedtime;
  late TimeOfDay _wakeTime;
  late int _efficiency;
  late TextEditingController _notesController;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    final init = widget.initialRecord;
    if (init != null) {
      _referenceDate = DateTime.tryParse(init.date) ?? DateTime.now();
      _bedtime = TimeOfDay(hour: init.bedtime.hour, minute: init.bedtime.minute);
      _wakeTime = TimeOfDay(hour: init.wakeTime.hour, minute: init.wakeTime.minute);
      _efficiency = init.efficiencyPercent;
      _notesController = TextEditingController(text: init.notes ?? '');
    } else {
      _referenceDate = DateTime.now();
      _bedtime = const TimeOfDay(hour: 23, minute: 0); // 11:00 PM
      _wakeTime = const TimeOfDay(hour: 7, minute: 30); // 7:30 AM
      _efficiency = 88;
      _notesController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  DateTime _computeBedtimeDateTime() {
    // If bedtime hour is >= 12, it is on the day BEFORE reference date (for overnight sleep)
    // E.g. bedtime 23:00 on Nov 6, wakeTime 07:30 on Nov 7 (reference date Nov 7)
    final isPreviousDay = _bedtime.hour >= 12;
    final baseDate = isPreviousDay ? _referenceDate.subtract(const Duration(days: 1)) : _referenceDate;
    return DateTime(baseDate.year, baseDate.month, baseDate.day, _bedtime.hour, _bedtime.minute);
  }

  DateTime _computeWakeTimeDateTime() {
    return DateTime(_referenceDate.year, _referenceDate.month, _referenceDate.day, _wakeTime.hour, _wakeTime.minute);
  }

  int _calculateDurationMinutes() {
    final start = _computeBedtimeDateTime();
    final end = _computeWakeTimeDateTime();
    return end.difference(start).inMinutes;
  }

  String _formatDateString(DateTime d) {
    return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialRecord != null;
    final durationMins = _calculateDurationMinutes();
    final isDurationValid = durationMins > 0;
    final hours = durationMins ~/ 60;
    final mins = durationMins % 60;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.surfaceOf(context),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.bedtime_rounded, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEditing ? 'Edit Sleep Record' : 'Log Sleep Session',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryOf(context),
                        ),
                      ),
                      Text(
                        'Offline Local Storage',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondaryOf(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Reference / Morning Date
            Text(
              'Morning Wake-up Date',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondaryOf(context),
              ),
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _referenceDate,
                  firstDate: DateTime(2024),
                  lastDate: DateTime.now().add(const Duration(days: 1)),
                );
                if (picked != null) {
                  setState(() {
                    _referenceDate = picked;
                  });
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderOf(context)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDateString(_referenceDate),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryOf(context),
                      ),
                    ),
                    Icon(Icons.calendar_month_rounded, size: 20, color: AppColors.primaryOf(context)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Time Pickers Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bedtime',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondaryOf(context),
                        ),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _bedtime,
                          );
                          if (picked != null) {
                            setState(() {
                              _bedtime = picked;
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderOf(context)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _bedtime.format(context),
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimaryOf(context),
                                ),
                              ),
                              const Icon(Icons.nightlight_round, size: 18, color: Colors.indigoAccent),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wake-up Time',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondaryOf(context),
                        ),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _wakeTime,
                          );
                          if (picked != null) {
                            setState(() {
                              _wakeTime = picked;
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderOf(context)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _wakeTime.format(context),
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimaryOf(context),
                                ),
                              ),
                              const Icon(Icons.wb_sunny_rounded, size: 18, color: Colors.amber),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Computed Duration Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDurationValid
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDurationValid
                      ? AppColors.primary.withValues(alpha: 0.25)
                      : AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isDurationValid ? Icons.timelapse_rounded : Icons.error_outline_rounded,
                    color: isDurationValid ? AppColors.primary : AppColors.warning,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isDurationValid
                              ? 'Total Sleep: ${hours}h ${mins}m'
                              : 'Invalid duration',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDurationValid
                                ? AppColors.textPrimaryOf(context)
                                : AppColors.warning,
                          ),
                        ),
                        Text(
                          _bedtime.hour >= 12
                              ? 'Overnight session (crosses midnight)'
                              : 'Same-day session',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textSecondaryOf(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Sleep Efficiency Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sleep Quality / Efficiency',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondaryOf(context),
                  ),
                ),
                Text(
                  '$_efficiency%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            Slider(
              value: _efficiency.toDouble(),
              min: 40,
              max: 100,
              divisions: 60,
              activeColor: AppColors.primary,
              onChanged: (val) {
                setState(() {
                  _efficiency = val.round();
                });
              },
            ),
            const SizedBox(height: 8),

            // Notes field
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'e.g. Restful sleep, drank chamomile tea',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              maxLines: 2,
            ),
            if (_validationError != null) ...[
              const SizedBox(height: 12),
              Text(
                _validationError!,
                style: const TextStyle(color: AppColors.error, fontSize: 12.5),
              ),
            ],
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textSecondaryOf(context)),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: !isDurationValid
                      ? null
                      : () {
                          final start = _computeBedtimeDateTime();
                          final end = _computeWakeTimeDateTime();
                          final dateStr = _formatDateString(_referenceDate);

                          widget.onSave(
                            start,
                            end,
                            dateStr,
                            _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                            _efficiency,
                          );
                          Navigator.of(context).pop();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(isEditing ? 'Save Changes' : 'Log Sleep'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
