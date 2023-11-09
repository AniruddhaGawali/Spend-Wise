import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/model/transaction.dart';
import 'package:spendwise/provider/transaction_provider.dart';
import 'package:spendwise/screens/analytics_screen/analytics_chart.dart';

enum ChartType { radial, donut, pie, bar }

getIconOfChartType(ChartType type) {
  switch (type) {
    case ChartType.radial:
      return MdiIcons.chartDonutVariant;
    case ChartType.donut:
      return MdiIcons.chartDonut;
    case ChartType.pie:
      return MdiIcons.chartPie;
    case ChartType.bar:
      return MdiIcons.chartBar;
  }
}

getChartOFChartType(ChartType type) {
  switch (type) {
    case ChartType.radial:
      return getRaidalChart;
    case ChartType.donut:
      return getDonutChart;
    case ChartType.pie:
      return getPieChart;
    case ChartType.bar:
      return getBarChart;
  }
}

class AnalyticsScreen extends HookConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = useState<List<ExpenceData>>([]);
    final maxPercentOfExpence = useState<double>(100);
    final transactions = ref.watch(transactionProvider.notifier).get();
    final typeOfChart = useState<ChartType>(ChartType.radial);

    useEffect(() {
      final total = transactions.fold<double>(
          0, (previousValue, element) => previousValue + element.amount);

      List<ExpenceData> temp = [];
      for (var element in transactions) {
        if (element.category == TransactionCatergory.account) {
          continue;
        }
        final expenceInPercent = element.amount / total * 100;
        temp.add(ExpenceData(element.category, expenceInPercent));
      }

      temp.sort((a, b) => a.expenceInPercent.compareTo(b.expenceInPercent));

      maxPercentOfExpence.value = temp.last.expenceInPercent;
      data.value = temp;

      return null;
    }, [transactions]);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Analytics"),
            Text(
              "${typeOfChart.value == ChartType.bar || typeOfChart.value == ChartType.radial ? "Top 5 Expences | " : ""}Last 30 days",
              style: Theme.of(context).textTheme.labelSmall,
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton(
                child: Icon(getIconOfChartType(typeOfChart.value)),
                itemBuilder: (ctx) => [
                      ...ChartType.values.map(
                        (e) => PopupMenuItem(
                          child: ListTile(
                            leading: Icon(getIconOfChartType(e)),
                            title: Text(e.name.substring(0, 1).toUpperCase() +
                                e.name.substring(1)),
                          ),
                          onTap: () {
                            typeOfChart.value = e;
                          },
                        ),
                      )
                    ]),
          )
        ],
      ),
      body: Center(
        child: SizedBox(
            child: getChartOFChartType(typeOfChart.value)(
          typeOfChart.value == ChartType.bar ||
                  typeOfChart.value == ChartType.radial
              ? data.value.sublist(data.value.length - 5, data.value.length)
              : data.value,
          maxPercentOfExpence.value,
          context,
        )),
      ),
    );
  }
}

class ExpenceData {
  ExpenceData(this.catergory, this.expenceInPercent);
  TransactionCatergory catergory;
  double expenceInPercent;
}
