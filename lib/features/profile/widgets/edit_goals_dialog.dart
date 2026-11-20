import 'package:flutter/material.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class EditGoalsDialog extends StatefulWidget {
  final AuthProvider authProvider;

  const EditGoalsDialog({super.key, required this.authProvider});

  @override
  State<EditGoalsDialog> createState() => _EditGoalsDialogState();
}

class _EditGoalsDialogState extends State<EditGoalsDialog> {
  late final TextEditingController _stepsController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _distanceController;
  late final TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _stepsController = TextEditingController(text: '${widget.authProvider.goalSteps}');
    _caloriesController = TextEditingController(text: '${widget.authProvider.goalCalories}');
    _distanceController = TextEditingController(text: widget.authProvider.goalDistance.toStringAsFixed(1));
    _timeController = TextEditingController(text: '${widget.authProvider.goalActiveTime}');
  }

  @override
  void dispose() {
    _stepsController.dispose();
    _caloriesController.dispose();
    _distanceController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _save() {
    final steps = int.tryParse(_stepsController.text) ?? widget.authProvider.goalSteps;
    final calories = int.tryParse(_caloriesController.text) ?? widget.authProvider.goalCalories;
    final distance = double.tryParse(_distanceController.text) ?? widget.authProvider.goalDistance;
    final time = int.tryParse(_timeController.text) ?? widget.authProvider.goalActiveTime;

    widget.authProvider.updateGoals(
      steps: steps,
      calories: calories,
      distance: distance,
      activeTime: time,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.surfaceOf(context),
      title: Text(
        l10n.dailyGoalsSettings,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildGoalField(
              label: l10n.stepGoal,
              controller: _stepsController,
              unit: l10n.stepsUnit,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),
            _buildGoalField(
              label: l10n.calorieGoal,
              controller: _caloriesController,
              unit: l10n.kcalUnit,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),
            _buildGoalField(
              label: l10n.distanceGoal,
              controller: _distanceController,
              unit: l10n.kmUnit,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 14),
            _buildGoalField(
              label: l10n.activeTimeGoal,
              controller: _timeController,
              unit: l10n.minUnit,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(l10n.save),
        ),
      ],
    );
  }

  Widget _buildGoalField({
    required String label,
    required TextEditingController controller,
    required String unit,
    required TextInputType keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        suffixText: unit,
      ),
    );
  }
}
