import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/coach_message_model.dart';
import '../../core/providers/weight_coach_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/add_edit_weight_dialog.dart';

/// Screen presenting the intelligent offline AI Weight Coach,
/// personalized metabolic analysis, and conversational guidance.
class WeightCoachScreen extends StatefulWidget {
  const WeightCoachScreen({super.key});

  @override
  State<WeightCoachScreen> createState() => _WeightCoachScreenState();
}

class _WeightCoachScreenState extends State<WeightCoachScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _quickPromptsEn = [
    'Analyze my progress',
    'How much water should I drink?',
    'Explain my BMI',
    'Nutrition guidance',
    'How many steps should I walk?',
    'How does sleep affect weight?',
    'I hit a weight plateau',
  ];

  final List<String> _quickPromptsAz = [
    'Tərəqqimi təhlil et',
    'Nə qədər su içməliyəm?',
    'BMI göstəricimi izah et',
    'Qidalanma tövsiyələri',
    'Gündə neçə addım atmalıyam?',
    'Yuxu çəkiyə necə təsir edir?',
    'Çəkim dayanıb (plato)',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final coach = context.watch<WeightCoachProvider>();
    final analysis = coach.currentAnalysis;
    final isAz = Localizations.localeOf(context).languageCode == 'az';
    final quickPrompts = isAz ? _quickPromptsAz : _quickPromptsEn;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundOf(context),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.weightCoachTitle,
              style: AppTypography.headlineMedium(context).copyWith(fontSize: 18.5),
            ),
            Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'Coach Leo • 100% Offline AI',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryAccentOf(context),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderOf(context), width: 1),
            ),
            child: IconButton(
              icon: Icon(Icons.history_rounded, color: AppColors.primaryAccentOf(context), size: 20),
              tooltip: l10n.weightHistory,
              onPressed: () => _showWeightHistorySheet(context, coach, l10n),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: AppColors.textSecondaryOf(context)),
            onSelected: (val) {
              if (val == 'target') {
                _showTargetWeightDialog(context, coach);
              } else if (val == 'clear') {
                coach.clearChatHistory();
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'target',
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('Change Target Weight'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('Clear Chat History'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Metabolic Header & Summary Card
          _buildMetabolicSummaryCard(context, l10n, coach, analysis),

          // Chat Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: coach.messages.length,
              itemBuilder: (context, index) {
                final msg = coach.messages[index];
                return _buildMessageBubble(context, msg);
              },
            ),
          ),

          // Quick Prompt Suggestion Chips
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: quickPrompts.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final prompt = quickPrompts[idx];
                return ActionChip(
                  label: Text(
                    prompt,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryAccentOf(context),
                    ),
                  ),
                  backgroundColor: AppColors.primaryAccentOf(context).withValues(alpha: 0.1),
                  side: BorderSide(color: AppColors.primaryAccentOf(context).withValues(alpha: 0.25)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  onPressed: () {
                    coach.sendMessage(prompt, isAzerbaijani: isAz);
                    _scrollToBottom();
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Message Input Field
          _buildInputBar(context, l10n, coach, isAz),
        ],
      ),
    );
  }

  Widget _buildMetabolicSummaryCard(
    BuildContext context,
    AppLocalizations l10n,
    WeightCoachProvider coach,
    dynamic analysis,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppDecorations.cardShadow(context),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Current vs Target Weight & Log Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${analysis.currentWeight} kg → ${analysis.targetWeight} kg',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimaryOf(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${analysis.estimatedWeeksToGoal} weeks estimated (${analysis.recommendedWeeklyChangeKg} kg/wk)',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryAccentOf(context),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AddEditWeightDialog(
                      currentWeight: coach.currentWeight,
                      onSave: (w, n, d) => coach.logWeight(weightKg: w, notes: n, date: d),
                    ),
                  );
                },
                icon: const Icon(Icons.add_rounded, size: 16),
                label: Text(l10n.logWeight),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccentOf(context),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: AppColors.dividerOf(context)),
          const SizedBox(height: 10),

          // 4-item Metric Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricItem(context, 'BMI', analysis.bmi.toStringAsFixed(1), analysis.bmiCategory, AppColors.accentDistance),
              _buildMetricItem(context, 'Daily Target', '${analysis.targetDailyKcal}', 'kcal/day', AppColors.accentCalories),
              _buildMetricItem(context, 'TDEE / BMR', '${analysis.tdeeKcal}/${analysis.bmrKcal}', 'kcal', AppColors.accentTime),
              _buildMetricItem(context, 'Hydration', '${analysis.dailyHydrationLiters}L', 'water/day', const Color(0xFF0D9488)),
            ],
          ),
          const SizedBox(height: 10),

          // Medical Disclaimer Notice
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, size: 15, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Educational health insights only. Not a medical diagnosis.',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(BuildContext context, String label, String value, String sub, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 10.5,
            color: AppColors.textSecondaryOf(context),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          sub,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 9.5,
            color: AppColors.textMutedOf(context),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(BuildContext context, CoachMessageModel message) {
    final isUser = message.isUser;
    final isDark = AppColors.isDark(context);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.primaryAccentOf(context)
              : (isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceOf(context)),
          gradient: isUser ? AppColors.emeraldGradient : null,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
          border: isUser ? null : Border.all(color: AppColors.borderOf(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isUser ? 0.12 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccentOf(context).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.psychology_rounded, size: 13, color: AppColors.primaryAccentOf(context)),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Coach Leo',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryAccentOf(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
            Text(
              message.content,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 13.5,
                height: 1.4,
                color: isUser ? Colors.white : AppColors.textPrimaryOf(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(
    BuildContext context,
    AppLocalizations l10n,
    WeightCoachProvider coach,
    bool isAz,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 8, 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        border: Border(top: BorderSide(color: AppColors.borderOf(context))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: l10n.typeMessage,
                  hintStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13,
                    color: AppColors.textMutedOf(context),
                  ),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: AppColors.borderOf(context)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: AppColors.borderOf(context)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: AppColors.primaryAccentOf(context), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onSubmitted: (text) {
                  if (text.trim().isNotEmpty) {
                    coach.sendMessage(text.trim(), isAzerbaijani: isAz);
                    _inputController.clear();
                    _scrollToBottom();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.emeraldGradient,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                onPressed: () {
                  final text = _inputController.text.trim();
                  if (text.isNotEmpty) {
                    coach.sendMessage(text, isAzerbaijani: isAz);
                    _inputController.clear();
                    _scrollToBottom();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWeightHistorySheet(
    BuildContext context,
    WeightCoachProvider coach,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AppColors.surfaceOf(context),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final history = coach.weightHistory;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.weightHistory,
                        style: AppTypography.titleMedium(context).copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Divider(color: AppColors.dividerOf(context)),
                  Expanded(
                    child: history.isEmpty
                        ? const Center(child: Text('No weight records logged yet'))
                        : ListView.separated(
                            itemCount: history.length,
                            separatorBuilder: (context, index) => Divider(height: 1, color: AppColors.dividerOf(context)),
                            itemBuilder: (context, idx) {
                              final item = history[idx];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.primaryAccentOf(context).withValues(alpha: 0.12),
                                  child: Icon(Icons.scale_rounded, color: AppColors.primaryAccentOf(context), size: 20),
                                ),
                                title: Text(
                                  item.formattedWeight,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${item.date} • BMI ${item.formattedBmi}${item.notes != null ? " • ${item.notes}" : ""}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (c) => AlertDialog(
                                        title: const Text('Confirm Deletion'),
                                        content: Text(l10n.deleteWeightConfirm),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(c, false),
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(c, true),
                                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await coach.deleteWeightRecord(item.id);
                                      setSheetState(() {});
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showTargetWeightDialog(BuildContext context, WeightCoachProvider coach) {
    final controller = TextEditingController(text: coach.targetWeight.toStringAsFixed(1));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Update Target Weight'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Target Weight (kg)',
            suffixText: 'kg',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(controller.text.trim());
              if (val != null && val >= 25.0 && val <= 250.0) {
                coach.updateTargetWeight(val);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
