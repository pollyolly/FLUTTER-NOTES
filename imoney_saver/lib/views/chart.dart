// import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:imoney_saver/models/money_saver_model.dart';
import 'package:imoney_saver/provider/detail_provider.dart';
import 'package:imoney_saver/provider/theme_provider.dart';
import 'package:intl/intl.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import 'package:provider/provider.dart';
import "package:collection/collection.dart";

class MoneySaverChart extends StatefulWidget {
  const MoneySaverChart({Key? key}) : super(key: key);

  @override
  MoneySaverChartState createState() => MoneySaverChartState();
}

class MoneySaverChartState extends State<MoneySaverChart> {
  DateTime selectedDate = DateTime.now();
  String _month = '';
  String dateStr = '';
  // String dateNow = '';
  int touchedIndex = -1;
  num percentIncome = 0;
  num percentExpense = 0;
  late final dataList;
  late List<MoneySaverModel> groupedData = [];
  late Map<String, List<MoneySaverModel>> groupByGroups;

  @override
  void initState() {
    super.initState();
    dateStr = DateFormat('MM-yyyy').format(selectedDate).toString();
    _month = DateFormat("MMMM").format(DateTime.now()).toString();
    // dateNow = DateFormat('MM-yyyy').format(selectedDate).toString();
    // dataList = Provider.of<MoneySaverDetailProvider>(context, listen: false)
    //     .getSelectedDataProvider(dateNow);
  }

  Future<void> setChartValues() async {
    num? sumIncome = 0;
    num? sumExpense = 0;
    groupedData =
        Provider.of<MoneySaverDetailProvider>(context, listen: false).dataList;
    // print('group data:' + groupedData.toString());
    if (groupedData.isNotEmpty) {
      groupByGroups = groupBy(groupedData, (obj) => obj.category);
      sumIncome =
          groupByGroups['Income']?.map((MoneySaverModel e) => e.money).sum;
      sumExpense =
          groupByGroups['Expense']?.map((MoneySaverModel e) => e.money).sum;
      // sumIncome!;
      // sumExpense!;
      sumIncome ??= 0;
      sumExpense ??= 0;
      percentIncome = ((sumIncome / (sumExpense + sumIncome)) * 100);
      percentExpense = ((sumExpense / (sumExpense + sumIncome)) * 100);
    } else {
      percentIncome = 0.0;
      percentExpense = 0.0;
    }
  }

  Future<void> setChartInitialValues() async {
    String dateNow = DateFormat('MM-yyyy').format(selectedDate).toString();
    await Provider.of<MoneySaverDetailProvider>(context, listen: false)
        .getchartDataProvider(dateNow);
    await setChartValues();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showMonthPicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _month = DateFormat("MMMM").format(picked).toString();
        dateStr = DateFormat('MM-yyyy').format(selectedDate).toString();
      });
      await Provider.of<MoneySaverDetailProvider>(context, listen: false)
          .getchartDataProvider(dateStr);
      await setChartValues();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Chart'), actions: [
          Text(_month,
              style: const TextStyle(
                  height: 3, fontSize: 15, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
                onPressed: () => _selectDate(context),
                //
                icon: const Icon(Icons.calendar_month, size: 25)),
          ),
        ]),
        body: AspectRatio(
          aspectRatio: 1.3,
          child: Consumer<MoneySaverThemeProvider>(
              builder: (context, theme, child) {
            return Card(
              margin:
                  const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              child: Row(
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: FutureBuilder(
                          future: setChartInitialValues(), //Initialized Value
                          // ignore: void_checks
                          initialData: groupedData,
                          builder: (context, snapshot) => snapshot
                                      .connectionState ==
                                  ConnectionState.waiting
                              ? const Center(
                                  child: Text('No data found'),
                                )
                              : Consumer<MoneySaverDetailProvider>(
                                  builder: (context, detailProvider, child) {
                                  return PieChart(
                                    PieChartData(
                                        pieTouchData: PieTouchData(
                                            touchCallback: (FlTouchEvent event,
                                                pieTouchResponse) {
                                          setState(() {
                                            if (!event
                                                    .isInterestedForInteractions ||
                                                pieTouchResponse == null ||
                                                pieTouchResponse
                                                        .touchedSection ==
                                                    null) {
                                              touchedIndex = -1;
                                              return;
                                            }
                                            touchedIndex = pieTouchResponse
                                                .touchedSection!
                                                .touchedSectionIndex;
                                          });
                                        }),
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        sectionsSpace: 0,
                                        centerSpaceRadius: 40,
                                        sections: showingSections()),
                                  );
                                })),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Indicator(
                        color: Color(0xFF00E676),
                        text: 'Income',
                        isSquare: true,
                        textColor:
                            theme.darkTheme ? Colors.grey : Colors.orange,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Indicator(
                        color: Color(0xFFFF1744),
                        text: 'Expense',
                        isSquare: true,
                        textColor:
                            theme.darkTheme ? Colors.grey : Colors.orange,
                      ),
                      SizedBox(
                        height: 18,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 28,
                  ),
                ],
              ),
            );
          }),
        ));
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      2,
      (i) {
        final isTouched = i == touchedIndex;
        final fontSize = isTouched ? 25.0 : 16.0;
        final radius = isTouched ? 60.0 : 50.0;
        switch (i) {
          case 0: //Income
            return PieChartSectionData(
              color: const Color(0xFF00E676),
              value: percentIncome == null
                  ? 0
                  : double.parse(percentIncome.toString()),
              title: '${percentIncome.toStringAsFixed(2)}%',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)),
            );
          case 1: //Expense
            return PieChartSectionData(
              color: const Color(0xFFFF1744),
              value: percentExpense == null
                  ? 0
                  : double.parse(percentExpense.toString()),
              title: '${percentExpense.toStringAsFixed(2)}%',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)),
            );
          default:
            throw Error();
        }
      },
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
