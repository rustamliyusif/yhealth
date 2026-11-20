import 'package:flutter/material.dart';
import '../models/weekly_report_model.dart';
import '../repositories/activity_repository.dart';
import '../services/pdf_report_service.dart';
import '../services/report_scheduler_service.dart';

/// Provider managing state for weekly reports, background catch-up execution,
/// report selection, and PDF export.
class WeeklyReportProvider extends ChangeNotifier {
  final ActivityRepository _repository;
  late final ReportSchedulerService _schedulerService;

  List<WeeklyReportModel> _reports = [];
  WeeklyReportModel? _selectedReport;
  bool _isLoading = false;
  String? _errorMessage;
  String? _exportedPdfPath;

  WeeklyReportProvider(
    this._repository, {
    ReportSchedulerService? schedulerService,
  }) {
    _schedulerService = schedulerService ?? ReportSchedulerService(_repository);
    init();
  }

  List<WeeklyReportModel> get reports => List.unmodifiable(_reports);
  WeeklyReportModel? get selectedReport => _selectedReport;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get exportedPdfPath => _exportedPdfPath;

  Future<void> init() async {
    await loadReports();
    await checkAndGenerateCatchUpReports();
  }

  Future<void> loadReports() async {
    _isLoading = true;
    notifyListeners();

    try {
      final loaded = await _repository.getAllWeeklyReports();
      _reports = loaded;
      if (_reports.isNotEmpty) {
        if (_selectedReport == null || !_reports.any((r) => r.id == _selectedReport!.id)) {
          _selectedReport = _reports.first;
        } else {
          // Refresh selected report instance
          _selectedReport = _reports.firstWhere((r) => r.id == _selectedReport!.id);
        }
      } else {
        _selectedReport = null;
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load weekly reports: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkAndGenerateCatchUpReports() async {
    try {
      final newReports = await _schedulerService.checkAndGeneratePendingReports();
      if (newReports.isNotEmpty) {
        await loadReports();
      }
    } catch (e) {
      debugPrint('Catch-up report generation error: $e');
    }
  }

  void selectReport(WeeklyReportModel report) {
    _selectedReport = report;
    _exportedPdfPath = null;
    notifyListeners();
  }

  Future<void> forceGenerateReportForDate(DateTime date) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final report = await _schedulerService.forceGenerateReportForWeek(date);
      await loadReports();
      _selectedReport = report;
    } catch (e) {
      _errorMessage = 'Failed to generate report: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> exportPdf(WeeklyReportModel report) async {
    try {
      final path = await PdfReportService.generateAndSaveWeeklyReportPdf(report);
      _exportedPdfPath = path;
      notifyListeners();
      return path;
    } catch (e) {
      _errorMessage = 'Failed to export PDF: $e';
      notifyListeners();
      return null;
    }
  }

  Future<void> deleteReport(String id) async {
    try {
      await _repository.deleteWeeklyReport(id);
      await loadReports();
    } catch (e) {
      _errorMessage = 'Failed to delete report: $e';
      notifyListeners();
    }
  }
}
