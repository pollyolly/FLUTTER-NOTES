import 'package:flutter/material.dart';
import 'package:imoney_saver/models/money_saver_model.dart';
import 'package:imoney_saver/net/notification_api.dart';
import 'package:imoney_saver/provider/detail_provider.dart';
import 'package:imoney_saver/provider/theme_provider.dart';
import 'package:intl/intl.dart';
import 'package:imoney_saver/models/money_saver_arguments.dart';
import 'package:imoney_saver/models/db_model.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MoneySaverDetails extends StatelessWidget {
  MoneySaverArguments data;
  final DateFormat formatter = DateFormat('MMMM/dd/yyyy EEE');
  var db = DatabaseConnect();
  MoneySaverDetails({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailProvider =
        Provider.of<MoneySaverDetailProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
                onPressed: () => showAlertDialog(context, detailProvider),
                //
                icon: const Icon(Icons.delete_outline_outlined, size: 25)),
          ),
        ],
      ),
      body: Card(
          margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              // child: Expanded(
              child: Consumer<MoneySaverThemeProvider>(
                  builder: (context, theme, child) {
                return Column(
                  children: [
                    SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Text('Category:',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: theme.darkTheme
                                        ? Color(0xFF8F8F8F)
                                        : Colors.orange)),
                            Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(data.category,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF8F8F8F)))),
                          ],
                        )),
                    // ]),
                    // Row(children: [
                    SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Text('Money:',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: theme.darkTheme
                                        ? Color(0xFF8F8F8F)
                                        : Colors.orange)),
                            Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                    data.category == 'Expense'
                                        ? '-${data.money}'
                                        : '+${data.money}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF8F8F8F)))),
                          ],
                        )),
                    // ]),
                    SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Text('Created:',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: theme.darkTheme
                                        ? Color(0xFF8F8F8F)
                                        : Colors.orange)),
                            Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                    formatter
                                        .format(data.creationDate)
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF8F8F8F)))),
                          ],
                        )),
                    SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Text('Remarks:',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: theme.darkTheme
                                        ? Color(0xFF8F8F8F)
                                        : Colors.orange)),
                            Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: SizedBox(
                                    width: 200,
                                    child: Text(data.remarks,
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF8F8F8F))))),
                          ],
                        ))
                  ],
                );
              }))),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Edit Details',
        onPressed: () => Navigator.of(context).pushNamed('/update-detail',
            arguments: MoneySaverArguments(
              data.id,
              data.remarks,
              data.money,
              // data.incomeMoney,
              // data.expenseMoney,
              data.category,
              data.creationDate,
              data.isChecked,
            )),
        child: const Icon(Icons.edit),
      ),
    );
  }

  showAlertDialog(BuildContext context, detailProvider) {
    // set up the buttons
    Widget okButton = TextButton(
      child: const Text("Ok"),
      onPressed: () async {
        await detailProvider
            .deleteDataProvider(MoneySaverModel(
                id: data.id,
                remarks: '',
                money: 00,
                category: '',
                creationDate: DateTime.now(),
                isChecked: false))
            .then((value) async {
          await NotificationApi.showNotification(
              title: 'Successfully Deleted!',
              body: data.remarks,
              payload: 'test payload');
          await Navigator.of(context).pushNamed('/');
        });
        // dismiss dialog
      },
    );
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Notice"),
      content: const Text("Do you really want to continue this action?"),
      actions: [
        okButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
