import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_report_data.dart';
import 'package:poseidon/data/models/report_item.dart';
import 'package:poseidon/ui/core/widgets/app_bottom_nav_bar.dart';
import 'package:poseidon/ui/core/widgets/poseidon_app_bar.dart';
import 'package:poseidon/ui/features/report/views/create_report_screen.dart';
import 'package:poseidon/ui/features/report/widgets/report_card_item.dart';
import 'package:poseidon/ui/features/report/widgets/report_detail_sheet.dart';

class ReportScreen extends StatefulWidget {
  final bool showScaffold;
  final ValueChanged<int>? onTabSelected;
  final VoidCallback? onCenterAction;

  const ReportScreen({
    super.key,
    this.showScaffold = true,
    this.onTabSelected,
    this.onCenterAction,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late List<ReportItem> _reports;

  @override
  void initState() {
    super.initState();
    _reports = List.from(MockReportData.initialReports);
  }

  void _openCreateReport() {
    Navigator.push(
      context,
      CreateReportScreen.route(
        onReportCreated: (newReport) {
          setState(() {
            _reports.insert(0, newReport);
          });
        },
      ),
    );
  }

  void _openReportDetail(ReportItem report) {
    ReportDetailSheet.show(
      context,
      report: report,
      onCancelReport: () {
        setState(() {
          _reports.removeWhere((r) => r.id == report.id);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildContent();

    if (!widget.showScaffold) {
      return content;
    }

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: const PoseidonAppBar(),
      body: content,
      bottomNavigationBar: widget.onTabSelected != null
          ? AppBottomNavBar(
              currentIndex: 1,
              onTabSelected: widget.onTabSelected!,
              onCenterAction: widget.onCenterAction ?? () {},
            )
          : null,
    );
  }

  Widget _buildContent() {
    return SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600.0),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 32.0),
            physics: const BouncingScrollPhysics(),
            children: [
              // Page Title
              const Text(
                'Lapor',
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6.0),

              // Page Subtitle
              const Text(
                'Laporkan anomali yang anda temukan di sekitar area parkir untuk kami tindak lanjuti',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20.0),

              // "+ Buat Laporan" Button
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: ElevatedButton.icon(
                  onPressed: _openCreateReport,
                  icon: const Icon(Icons.add, size: 20.0, color: Colors.white),
                  label: const Text(
                    'Buat Laporan',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // Section Header: Riwayat Laporan & Count
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Expanded(
                    child: Text(
                      'Riwayat Laporan',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    '${_reports.length} laporan',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),

              // Report Items Card Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFF1F1F1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _reports.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(
                            'Belum ada laporan riwayat.',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          for (int i = 0; i < _reports.length; i++) ...[
                            if (i > 0)
                              const Divider(
                                height: 1.0,
                                thickness: 1.0,
                                color: Color(0xFFF5F5F7),
                                indent: 16.0,
                                endIndent: 16.0,
                              ),
                            ReportCardItem(
                              report: _reports[i],
                              onTap: () => _openReportDetail(_reports[i]),
                            ),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
