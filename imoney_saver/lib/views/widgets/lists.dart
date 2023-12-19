import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:imoney_saver/models/db_model.dart';
import 'package:imoney_saver/provider/detail_provider.dart';
import 'package:imoney_saver/views/widgets/list_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import "package:collection/collection.dart";

import '../../models/money_saver_model.dart';

class MoneySaverList extends StatefulWidget {
  const MoneySaverList({Key? key}) : super(key: key);

  @override
  MoneySaverListState createState() => MoneySaverListState();
}

class MoneySaverListState extends State<MoneySaverList> {
  var db = DatabaseConnect();
  // num totalMoney = 0;
  // late Future<List<MoneySaverModel>> dataList;

  // Future<List<dynamic>> getDataProvider() {
  //   var list = Provider.of<MoneySaverDetailProvider>(context, listen: false)
  //       .getDataProvider;
  //   return list;
  // }

  // @override
  // void initState() {
  //   dataList = db.getData(); //initialized once
  //   super.initState();
  // }
  @override
  void initState() {
    super.initState();
  }

  Future<void> setListInitialValues() async {
    String dateNow = DateFormat('MM-yyyy').format(DateTime.now()).toString();
    await Provider.of<MoneySaverDetailProvider>(context, listen: false)
        .getchartDataProvider(dateNow);
  }

//GROUPEDLISTVIEW SAMPLE IMPLEMENTATION USING PROVIDER

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder(
            future: setListInitialValues(), //Initialized Value in Provider
            // ignore: void_checks
            initialData: const [],
            builder: (context, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? const Center(
                    child: Text('No data found'),
                  )
                : Consumer<MoneySaverDetailProvider>(
                    builder: (context, detailProvider, child) {
                    List<MoneySaverModel> groupedData = detailProvider.dataList;
                    String groupCategory = '';
                    String groupDate = '';
                    Map<String, List<MoneySaverModel>> groupByGroups = groupBy(
                        groupedData,
                        (obj) =>
                            DateFormat('MM/dd EEE')
                                .format(obj.creationDate)
                                .toString() +
                            obj.category);
                    // print(groupByGroups);
                    return GroupedListView<MoneySaverModel, String>(
                      elements: groupedData,
                      groupBy: (MoneySaverModel element) {
                        groupCategory = element.category;
                        groupDate = DateFormat('MM/dd EEE')
                            .format(element.creationDate)
                            .toString();
                        return DateFormat('MM/dd EEE')
                                .format(element.creationDate) +
                            element.category;
                      },
                      // groupComparator: (value1, value2) =>
                      //     value2.compareTo(value1),
                      // itemComparator: (item1, item2) {
                      // item1.creationDate.compareTo(item2.creationDate);
                      // },
                      order: GroupedListOrder.DESC,
                      useStickyGroupSeparators: false,
                      // groupSeparatorBuilder: (_) => SizedBox(
                      //   height: 10,
                      // ),
                      groupSeparatorBuilder: (String value) {
                        final sum =
                            groupByGroups[value]?.map((e) => e.money).sum;
                        // print(groupByGroups);
                        // print(value);
                        return Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0))),
                            margin: const EdgeInsets.only(
                                top: 5, bottom: 0, left: 10, right: 10),
                            // margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8, right: 8),
                                    child: Text(
                                      groupDate,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          // fontWeight: FontWeight.bold,
                                          color: Color(0xFF8F8F8F)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8, right: 8),
                                    child: Text(
                                      groupCategory == 'Expense'
                                          ? 'Expense: -${sum.toString()}'
                                          : 'Income: +${sum.toString()}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          // fontWeight: FontWeight.bold,
                                          color: Color(0xFF8F8F8F)),
                                    ),
                                  )
                                ]));
                        // return Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Text(
                        //     sum.toString(),
                        //     textAlign: TextAlign.center,
                        //     style: const TextStyle(
                        //         fontSize: 15,
                        //         fontWeight: FontWeight.bold,
                        //         color: Color(0xFF8F8F8F)),
                        //   ),
                        // );
                      },

                      itemBuilder: (context, i) {
                        return MoneySaverCard(
                            id: i.id,
                            remarks: i.remarks,
                            money: i.money,
                            category: i.category,
                            creationDate: i.creationDate,
                            isChecked: i.isChecked);
                      },
                    );
                  })));

//LISTVIEW SAMPLE IMPLEMENTATION USING PROVIDER

    // @override
    // Widget build(BuildContext context) {
    //   return Expanded(
    //       child: FutureBuilder(
    //           future:
    //               Provider.of<MoneySaverDetailProvider>(context, listen: false)
    //                   .getDataProvider(),
    //           // ignore: void_checks
    //           initialData: const [],
    //           builder: (context, snapshot) => snapshot.connectionState ==
    //                   ConnectionState.waiting
    //               ? const Center(
    //                   child: Text('no data found'),
    //                 )
    //               : Consumer<MoneySaverDetailProvider>(
    //                   builder: (context, detailProvider, child) {
    //                   return ListView.builder(
    //                     itemCount: detailProvider.dataList.length,
    //                     itemBuilder: (context, i) {
    //                       return MoneySaverCard(
    //                           id: detailProvider.dataList[i].id,
    //                           remarks: detailProvider.dataList[i].remarks,
    //                           money: detailProvider.dataList[i].money,
    //                           category: detailProvider.dataList[i].category,
    //                           creationDate:
    //                               detailProvider.dataList[i].creationDate,
    //                           isChecked: detailProvider.dataList[i].isChecked);
    //                     },
    //                   );
    //                 })));

//LISTVIEW SAMPLE IMPLEMENTATION USING SETSTATE

    // @override
    // Widget build(BuildContext context) {
    //   return Expanded(
    //       child: FutureBuilder(
    //     future: dataList,
    //     initialData: const [],
    //     builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
    //       var data = snapshot.data;
    //       var datalength = data!.length;

    //       return datalength == 0
    //           ? const Center(
    //               child: Text('no data found'),
    //             )
    //           : ListView.builder(
    //               itemCount: datalength,
    //               itemBuilder: (context, i) => MoneySaverCard(
    //                   id: data[i].id,
    //                   remarks: data[i].remarks,
    //                   money: data[i].money,
    //                   category: data[i].category,
    //                   creationDate: data[i].creationDate,
    //                   isChecked: data[i].isChecked),
    //             );
    //     },
    //   ));
  }
}
