import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/weekly_report_model.dart';

/// Local service generating high-resolution, privacy-first PDF documents for weekly reports.
class PdfReportService {
  static Future<pw.ThemeData?> _loadUnicodeTheme() async {
    try {
      final regular = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
      final bold = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
      return pw.ThemeData.withFont(
        base: pw.Font.ttf(regular),
        bold: pw.Font.ttf(bold),
      );
    } catch (e) {
      debugPrint('PdfReportService: Unicode font load failed: $e');
      return null;
    }
  }

  /// Generates a PDF report document and persists it to local device storage.
  /// Returns the absolute file path of the generated PDF.
  static Future<String> generateAndSaveWeeklyReportPdf(WeeklyReportModel report) async {
    final pdf = pw.Document(theme: await _loadUnicodeTheme());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'YHealth - Weekly Report',
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blueGrey900,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        '${report.startDate}  to  ${report.endDate}   |   Week ${report.weekNumber}, ${report.year}',
                        style: const pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue100,
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Text(
                      'YHEALTH OFFLINE',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 16),

              // KPI Summary Cards Grid
              pw.Text(
                'Weekly Summary Metrics',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey800,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                children: [
                  _buildKpiCard('Total Steps', '${report.totalSteps}', 'steps', PdfColors.teal50),
                  pw.SizedBox(width: 8),
                  _buildKpiCard('Distance', report.formattedTotalDistance, '', PdfColors.cyan50),
                  pw.SizedBox(width: 8),
                  _buildKpiCard('Calories', '${report.totalCalories}', 'kcal', PdfColors.orange50),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Row(
                children: [
                  _buildKpiCard('Active Time', '${report.totalActiveMinutes}', 'min', PdfColors.amber50),
                  pw.SizedBox(width: 8),
                  _buildKpiCard('Avg Sleep / Night', report.formattedAvgDailySleep, '', PdfColors.indigo50),
                  pw.SizedBox(width: 8),
                  _buildKpiCard('Goal Completed', '${report.goalMetDays} / 7 days', '(${report.goalCompletionPercent}%)', PdfColors.green50),
                ],
              ),
              pw.SizedBox(height: 16),

              // Highlights & Comparison
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Most Active Day:',
                          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                        ),
                        pw.Text(
                          '${report.mostActiveDayDate}  (${report.mostActiveDaySteps} steps)',
                          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey900),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'vs Previous Week:',
                          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                        ),
                        pw.Text(
                          'Steps: ${report.formatDeltaPercent(report.stepsChangePercent)}   |   Sleep: ${report.formatDeltaPercent(report.sleepChangePercent)}',
                          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey900),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Daily Breakdown Table
              pw.Text(
                '7-Day Daily Breakdown (Monday - Sunday)',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey800,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.blueGrey100),
                    children: [
                      _buildTableCell('Day', isHeader: true),
                      _buildTableCell('Date', isHeader: true),
                      _buildTableCell('Steps', isHeader: true),
                      _buildTableCell('Dist (km)', isHeader: true),
                      _buildTableCell('Calories', isHeader: true),
                      _buildTableCell('Active (m)', isHeader: true),
                      _buildTableCell('Sleep', isHeader: true),
                      _buildTableCell('Goal Met', isHeader: true),
                    ],
                  ),
                  // Table Rows
                  ...report.dailyBreakdowns.map((d) {
                    final sleepStr = d.sleepMinutes > 0
                        ? '${d.sleepMinutes ~/ 60}h ${d.sleepMinutes % 60}m'
                        : '-';
                    final goalStr = d.isGoalMet ? 'Yes' : (d.isMissing ? 'No record' : 'No');
                    return pw.TableRow(
                      decoration: pw.BoxDecoration(
                        color: d.isMissing ? PdfColors.grey50 : PdfColors.white,
                      ),
                      children: [
                        _buildTableCell(d.dayName),
                        _buildTableCell(d.date),
                        _buildTableCell(d.isMissing ? '-' : '${d.steps}'),
                        _buildTableCell(d.isMissing ? '-' : d.distanceKm.toStringAsFixed(1)),
                        _buildTableCell(d.isMissing ? '-' : '${d.calories}'),
                        _buildTableCell(d.isMissing ? '-' : '${d.activeMinutes}'),
                        _buildTableCell(sleepStr),
                        _buildTableCell(goalStr),
                      ],
                    );
                  }),
                ],
              ),
              pw.Spacer(),

              // Footer
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 6),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Generated locally by YHealth. Data is stored strictly on-device without cloud sync.',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
                  pw.Text(
                    'Generated: ${report.generatedAt.toLocal().toString().split('.')[0]}',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'yhealth_report_${report.year}_W${report.weekNumber.toString().padLeft(2, '0')}.pdf';
    final file = File(p.join(dir.path, fileName));
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  static pw.Widget _buildKpiCard(String label, String value, String unit, PdfColor bgColor) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: pw.BoxDecoration(
          color: bgColor,
          borderRadius: pw.BorderRadius.circular(6),
          border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              value,
              style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey900),
            ),
            if (unit.isNotEmpty) ...[
              pw.Text(
                unit,
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.blueGrey900 : PdfColors.grey800,
        ),
      ),
    );
  }
}
