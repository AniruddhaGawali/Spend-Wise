import 'package:flutter/material.dart';
import 'package:spendwise/screens/analytics_screen/analytics_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Widget getRaidalChart(
    List<ExpenceData> data, double maxPercentOfExpence, BuildContext context) {
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
    series: [
      RadialBarSeries<ExpenceData, String>(
        dataSource: data,
        radius: "90%",
        innerRadius: "20%",
        trackColor: Theme.of(context).colorScheme.surface,
        gap: '3%',
        cornerStyle: CornerStyle.bothCurve,
        xValueMapper: (ExpenceData data, _) => data.catergory.name,
        yValueMapper: (ExpenceData data, _) => data.expenceInPercent,
        legendIconType: LegendIconType.circle,
        sortingOrder: SortingOrder.descending,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        maximumValue: maxPercentOfExpence + 10,
      )
    ],
  );
}

Widget getPieChart(
  List<ExpenceData> data,
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
    series: [
      PieSeries<ExpenceData, String>(
        dataSource: data,
        radius: "90%",
        xValueMapper: (ExpenceData data, _) => data.catergory.name,
        yValueMapper: (ExpenceData data, _) => data.expenceInPercent,
        legendIconType: LegendIconType.circle,
        sortingOrder: SortingOrder.descending,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      )
    ],
  );
}

Widget getDonutChart(
  List<ExpenceData> data,
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
    series: [
      DoughnutSeries<ExpenceData, String>(
        dataSource: data,
        radius: "90%",
        xValueMapper: (ExpenceData data, _) => data.catergory.name,
        yValueMapper: (ExpenceData data, _) => data.expenceInPercent,
        legendIconType: LegendIconType.circle,
        sortingOrder: SortingOrder.descending,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      )
    ],
  );
}

Widget getBarChart(
  List<ExpenceData> data,
  double maxPercentOfExpence,
  BuildContext context,
) {
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(),
    primaryYAxis: NumericAxis(minimum: 0, maximum: 100, interval: 10),
    zoomPanBehavior: ZoomPanBehavior(
      enablePanning: true,
    ),
    series: [
      BarSeries<ExpenceData, String>(
        dataSource: data,
        xValueMapper: (ExpenceData data, _) => data.catergory.name,
        yValueMapper: (ExpenceData data, _) => data.expenceInPercent,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        color: Theme.of(context).colorScheme.primary,
      )
    ],
  );
}
