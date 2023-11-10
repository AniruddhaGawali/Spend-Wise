import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spendwise/model/transaction.dart';
import 'package:spendwise/provider/transaction_provider.dart';
import 'package:spendwise/screens/pages/analytics_page/analytics_chart.dart';
import 'package:spendwise/utils/get_date.dart';

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
    List<Transaction> transactions =
        ref.watch(transactionProvider.notifier).get();
    final data = useState<List<ExpenseData>>([]);
    final maxPercentOfExpence = useState<double>(100);
    final typeOfChart = useState<ChartType>(ChartType.radial);

    useEffect(() {
      transactions = transactions
          .where((element) =>
              element.date.month == DateTime.now().month &&
              element.date.year == DateTime.now().year)
          .toList();

      List<ExpenseData> temp = calculateExpenseData(transactions);

      temp.sort((a, b) => a.expenceInPercent.compareTo(b.expenceInPercent));

      for (var element in temp) {
        element.expenceInPercent = element.expenceInPercent.roundToDouble();
      }

      if (temp.isNotEmpty) {
        maxPercentOfExpence.value = temp.last.expenceInPercent;
        data.value = temp;
      }

      return null;
    }, [transactions]);

    if (data.value.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Analytics"),
        ),
        body: Center(
          child: Text(
            "No data to show",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Analytics"),
            Text(
              "${typeOfChart.value == ChartType.bar || typeOfChart.value == ChartType.radial ? "Top 5 Expences | " : ""}${getMonth(DateTime.now().month)} ${DateTime.now().year} | In Percent",
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

  List<ExpenseData> calculateExpenseData(List<Transaction> transactions) {
    // Create a map to store total expenses for each category
    Map<TransactionCatergory, double> categoryExpenses = {};

    // Initialize the map with 0 for each category
    for (var category in TransactionCatergory.values) {
      categoryExpenses[category] = 0.0;
    }

    // Calculate total expenses for each category
    for (var transaction in transactions) {
      if (transaction.type == TransactionType.expense &&
          transaction.category != TransactionCatergory.account) {
        categoryExpenses[transaction.category] =
            categoryExpenses[transaction.category]! + transaction.amount;
      }
    }

    // Filter out categories with zero expenses
    categoryExpenses.removeWhere((_, expense) => expense == 0);

    // Calculate the total expenses
    double totalExpenses = categoryExpenses.values.reduce((a, b) => a + b);

    // Calculate the percentage for each category
    List<ExpenseData> expenseDataList = [];
    for (var entry in categoryExpenses.entries) {
      double expenseInPercent = (entry.value / totalExpenses) * 100;
      expenseDataList.add(ExpenseData(entry.key, expenseInPercent));
    }

    return expenseDataList;
  }
}

class ExpenseData {
  ExpenseData(this.catergory, this.expenceInPercent);
  TransactionCatergory catergory;
  double expenceInPercent;
}
