import 'package:brasilcripto/app/core/l10n/l10n.dart';
import 'package:brasilcripto/app/presenter/models/crypto.dart';
import 'package:brasilcripto/app/presenter/models/crypto/chart_data.dart';
import 'package:brasilcripto/app/presenter/views/widgets/details/cards/details_coin_widget.dart';
import 'package:brasilcripto/app/presenter/views/widgets/details/cards/details_price_widget.dart';
import 'package:brasilcripto/app/presenter/views/widgets/details/components/graphic/details_empty_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CryptoChartWidget extends StatefulWidget {
  final Crypto crypto;
  final bool showVolume;

  const CryptoChartWidget({
    super.key,
    required this.crypto,
    this.showVolume = false,
  });

  @override
  State<CryptoChartWidget> createState() => _CryptoChartWidgetState();
}

class _CryptoChartWidgetState extends State<CryptoChartWidget> {
  bool _showVolume = false;
  late TooltipBehavior _tooltipBehavior;
  Crypto get crypto => widget.crypto;

  @override
  void initState() {
    super.initState();
    _showVolume = widget.showVolume;
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y',
    );
  }

  List<ChartData> _getSortedChartData() {
    final details = crypto.details;
    if (details == null || details.chartDatas.isEmpty) {
      return [];
    }

    final sortedData = List<ChartData>.from(details.chartDatas);
    sortedData.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return sortedData;
  }

  String _formatYAxisValue(double value, bool isVolume) {
    if (isVolume) {
      return NumberFormat.compact(locale: 'pt_BR').format(value);
    }

    // For price values, use more precision to avoid repeated labels
    if (value >= 100000) {
      return NumberFormat.currency(
        locale: 'pt_BR',
        symbol: '',
        decimalDigits: 0,
      ).format(value);
    } else if (value >= 1000) {
      return NumberFormat.currency(
        locale: 'pt_BR',
        symbol: '',
        decimalDigits: 1,
      ).format(value);
    } else if (value >= 1) {
      return NumberFormat.currency(
        locale: 'pt_BR',
        symbol: '',
        decimalDigits: 2,
      ).format(value);
    } else {
      return NumberFormat.currency(
        locale: 'pt_BR',
        symbol: '',
        decimalDigits: 6,
      ).format(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedChartDatas = _getSortedChartData();

    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailsCoinWidget(crypto: crypto),
          DetailsPriceWidget(crypto: crypto),
          Visibility(
            visible: sortedChartDatas.isNotEmpty,
            replacement: DetailsEmptyChartWidget(crypto: crypto),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildChartToggle(),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _showVolume
                        ? _buildVolumeChart(sortedChartDatas)
                        : _buildPriceChart(sortedChartDatas),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartToggle() {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme;
    final l10n = LocalizationService.instance.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.lastTrades,
              style: textStyle.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildToggleButton(l10n.price, Icons.show_chart, false),
          const SizedBox(width: 8),
          _buildToggleButton(l10n.volume, Icons.bar_chart, true),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, IconData icon, bool isVolume) {
    final isSelected = _showVolume == isVolume;
    final theme = Theme.of(context);
    final textStyle = theme.textTheme;
    final colors = theme.colorScheme;
    return GestureDetector(
      onTap: () {
        setState(() {
          _showVolume = isVolume;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: textStyle.bodySmall?.copyWith(
                color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceChart(List<ChartData> chartDatas) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme;
    final colors = theme.colorScheme;

    final l10n = LocalizationService.instance.l10n;
    return SfCartesianChart(
      backgroundColor: Colors.transparent,
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        labelFormat: 'HH:mm',
        intervalType: DateTimeIntervalType.hours,
        interval: 4,
        labelIntersectAction: AxisLabelIntersectAction.rotate45,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorGridLines: MajorGridLines(color: colors.outlineVariant, width: 1),
        axisLine: const AxisLine(width: 0),
        labelStyle: textStyle.bodySmall?.copyWith(
          color: colors.onSurfaceVariant,
        ),
      ),
      primaryYAxis: NumericAxis(
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          return ChartAxisLabel(
            _formatYAxisValue(details.value.toDouble(), false),
            textStyle.bodySmall?.copyWith(color: colors.onSurfaceVariant),
          );
        },
        desiredIntervals: 6,
        majorGridLines: MajorGridLines(color: colors.outlineVariant, width: 1),
        axisLine: const AxisLine(width: 0),
      ),
      tooltipBehavior: _tooltipBehavior,
      series: <CartesianSeries<ChartData, DateTime>>[
        AreaSeries<ChartData, DateTime>(
          dataSource: chartDatas,
          xValueMapper: (ChartData data, _) => data.timestamp,
          yValueMapper: (ChartData data, _) => data.price,
          name: l10n.price,
          color: colors.primaryFixedDim,
          borderColor: colors.primary,
          borderWidth: 2,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colors.primaryFixedDim, colors.primaryFixedDim],
          ),
        ),
      ],
    );
  }

  Widget _buildVolumeChart(List<ChartData> chartDatas) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme;
    final colors = theme.colorScheme;

    final l10n = LocalizationService.instance.l10n;
    return SfCartesianChart(
      backgroundColor: Colors.transparent,
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        labelFormat: 'HH:mm',
        intervalType: DateTimeIntervalType.hours,
        interval: 4,
        labelIntersectAction: AxisLabelIntersectAction.rotate45,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorGridLines: MajorGridLines(color: colors.outlineVariant, width: 1),
        axisLine: const AxisLine(width: 0),
        labelStyle: textStyle.bodySmall?.copyWith(
          color: colors.onSurfaceVariant,
        ),
      ),
      primaryYAxis: NumericAxis(
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          return ChartAxisLabel(
            _formatYAxisValue(details.value.toDouble(), true),
            textStyle.bodySmall?.copyWith(color: colors.onSurfaceVariant),
          );
        },
        desiredIntervals: 6,
        majorGridLines: MajorGridLines(color: colors.outlineVariant, width: 1),
        axisLine: const AxisLine(width: 0),
      ),
      tooltipBehavior: _tooltipBehavior,
      series: <CartesianSeries<ChartData, DateTime>>[
        ColumnSeries<ChartData, DateTime>(
          dataSource: chartDatas,
          xValueMapper: (ChartData data, _) => data.timestamp,
          yValueMapper: (ChartData data, _) => data.volume,
          name: l10n.volume,
          color: colors.secondary,
          width: 0.6,
          spacing: 0.2,
        ),
      ],
    );
  }
}
