import 'package:flutter/material.dart';
import 'package:spendwise/screens/pages/analytics_page/analytics_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final toolTip = TooltipBehavior(enable: true);
Widget getRaidalChart(
    List<ExpenseData> data, double maxPercentOfExpence, BuildContext context) {
  return SfCircularChart(
    palette: [
      Theme.of(context).colorScheme.inverseSurface,
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.tertiary,
      Theme.of(context).colorScheme.inversePrimary,
    ],
    legend: const Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        position: LegendPosition.bottom),
    tooltipBehavior: toolTip,
    series: [
      RadialBarSeries<ExpenseData, String>(
        dataSource: data,
        radius: "90%",
        innerRadius: "20%",
        trackColor: Theme.of(context).colorScheme.surface,
        gap: '3%',
        cornerStyle: CornerStyle.bothCurve,
        xValueMapper: (ExpenseData data, _) => data.catergory.name,
        yValueMapper: (ExpenseData data, _) => data.expenceInPercent,
        legendIconType: LegendIconType.circle,
        sortingOrder: SortingOrder.descending,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        maximumValue: maxPercentOfExpence + 10,
        enableTooltip: true,
      )
    ],
  );
}

Widget getPieChart(
  List<ExpenseData> data,
  double maxPercentOfExpence,
  BuildContext context,
) {
  return SfCircularChart(
    palette: [
      Theme.of(context).colorScheme.inverseSurface,
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.tertiary,
      Theme.of(context).colorScheme.inversePrimary,
    ],
    legend: const Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        position: LegendPosition.bottom),
    tooltipBehavior: toolTip,
    series: [
      PieSeries<ExpenseData, String>(
          dataSource: data,
          radius: "90%",
          xValueMapper: (ExpenseData data, _) => data.catergory.name,
          yValueMapper: (ExpenseData data, _) => data.expenceInPercent,
          legendIconType: LegendIconType.circle,
          sortingOrder: SortingOrder.descending,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          enableTooltip: true)
    ],
  );
}

Widget getDonutChart(
  List<ExpenseData> data,
  double maxPercentOfExpence,
  BuildContext context,
) {
  return SfCircularChart(
    palette: [
      Theme.of(context).colorScheme.inverseSurface,
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.tertiary,
      Theme.of(context).colorScheme.inversePrimary,
    ],
    legend: const Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        position: LegendPosition.bottom),
    tooltipBehavior: toolTip,
    series: [
      DoughnutSeries<ExpenseData, String>(
        dataSource: data,
        radius: "90%",
        xValueMapper: (ExpenseData data, _) => data.catergory.name,
        yValueMapper: (ExpenseData data, _) => data.expenceInPercent,
        legendIconType: LegendIconType.circle,
        sortingOrder: SortingOrder.descending,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        enableTooltip: true,
      )
    ],
  );
}

Widget getBarChart(
  List<ExpenseData> data,
  double maxPercentOfExpence,
  BuildContext context,
) {
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(),
    primaryYAxis: NumericAxis(minimum: 0, maximum: 100, interval: 10),
    zoomPanBehavior: ZoomPanBehavior(
      enablePanning: true,
    ),
    tooltipBehavior: toolTip,
    series: [
      BarSeries<ExpenseData, String>(
        dataSource: data,
        xValueMapper: (ExpenseData data, _) => data.catergory.name,
        yValueMapper: (ExpenseData data, _) => data.expenceInPercent,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        color: Theme.of(context).colorScheme.primary,
        enableTooltip: true,
      )
    ],
  );
}
