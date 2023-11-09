import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spendwise/model/transaction.dart';
import 'package:spendwise/provider/transaction_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsScreen extends HookConsumerWidget {
  AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = useState<List<ExpenceData>>([]);
    final maxPercentOfExpence = useState<double>(100);
    final transactions = ref.watch(transactionProvider.notifier).get();

    useEffect(() {
      final total = transactions.fold<double>(
          0, (previousValue, element) => previousValue + element.amount);

      List<ExpenceData> temp = [];
      transactions.forEach((element) {
        if (element.category == TransactionCatergory.account) {
          return;
        }
        final expenceInPercent = element.amount / total * 100;
        temp.add(ExpenceData(element.category, expenceInPercent));
      });

      temp.sort((a, b) => a.expenceInPercent.compareTo(b.expenceInPercent));

      maxPercentOfExpence.value = temp.last.expenceInPercent;
      data.value = temp;

      return null;
    }, [transactions]);

    print(data);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Center(
        child: Container(
          child: SfCircularChart(
            palette: [
              Theme.of(context).colorScheme.inverseSurface,
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.tertiary,
              Theme.of(context).colorScheme.inversePrimary,
            ],
            legend: const Legend(
                isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
            series: [
              RadialBarSeries<ExpenceData, String>(
                dataSource: data.value,
                radius: "90%",
                innerRadius: "30%",
                trackColor: Theme.of(context).colorScheme.surface,
                gap: '3%',
                cornerStyle: CornerStyle.bothCurve,
                xValueMapper: (ExpenceData data, _) => data.catergory.name,
                yValueMapper: (ExpenceData data, _) => data.expenceInPercent,
                legendIconType: LegendIconType.circle,
                sortingOrder: SortingOrder.descending,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                maximumValue: maxPercentOfExpence.value + 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ExpenceData {
  ExpenceData(this.catergory, this.expenceInPercent);
  TransactionCatergory catergory;
  double expenceInPercent;
}
