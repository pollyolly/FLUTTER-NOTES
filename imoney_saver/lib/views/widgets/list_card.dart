import 'package:flutter/material.dart';
import 'package:imoney_saver/models/money_saver_arguments.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class MoneySaverCard extends StatefulWidget {
  int? id;
  final String remarks;
  final num money;
  final String category;
  final DateTime creationDate;
  final dynamic isChecked; //set dynamic data type
  final DateFormat formatter = DateFormat('MM/dd EEE'); //intl.dart

  MoneySaverCard(
      {this.id,
      required this.remarks,
      required this.money,
      required this.category,
      required this.creationDate,
      required this.isChecked,
      Key? key})
      : super(key: key);

  @override
  MoneySaverState createState() => MoneySaverState();
}

class MoneySaverState extends State<MoneySaverCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0), topRight: Radius.circular(0))),
        margin: const EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
        // margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        child: InkWell(
            onTap: () => Navigator.of(context).pushNamed('/detail',
                arguments: MoneySaverArguments(
                    widget.id,
                    widget.remarks,
                    widget.money,
                    widget.category,
                    widget.creationDate,
                    widget.isChecked)),
            child: Row(children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: widget.category == 'Expense'
                    ? const Icon(Icons.arrow_downward,
                        size: 35, color: Color(0xFFFF1744))
                    : const Icon(Icons.arrow_upward,
                        size: 35, color: Color(0xFF00E676)),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: 200,
                            child: Text(widget.remarks,
                                overflow: TextOverflow.fade,
                                style: const TextStyle(fontSize: 15))),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Text(
                            widget.category == 'Expense'
                                ? '-${widget.money}'
                                : '+${widget.money}',
                            style: const TextStyle(
                                fontSize: 15, color: Color(0xFF8F8F8F)),
                          ),
                        )
                      ])
                ],
              )),
            ])));
  }
}
