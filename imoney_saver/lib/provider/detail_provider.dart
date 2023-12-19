import 'package:flutter/material.dart';
import 'package:imoney_saver/models/db_model.dart';
import 'package:imoney_saver/models/money_saver_model.dart';

class MoneySaverDetailProvider with ChangeNotifier {
  int total = 0;
  List<MoneySaverModel> _dataList = [];
  List<MoneySaverModel> get dataList => _dataList;
  // List<dynamic> get dataList;
  var db = DatabaseConnect();

  Future<MoneySaverModel> insertDataProvider(MoneySaverModel data) async {
    // _dataList.add(data);
    Future<MoneySaverModel> insertData = db.insertData(data);
    await insertData.then((value) => getDataProvider());
    notifyListeners();
    return insertData;
  }

  Future<MoneySaverModel> updateDataProvider(MoneySaverModel data) async {
    Future<MoneySaverModel> updateData = db.updateData(data);
    await updateData.then((value) => getDataProvider());
    notifyListeners();
    return updateData;
  }

  Future<MoneySaverModel> deleteDataProvider(MoneySaverModel data) async {
    Future<MoneySaverModel> deleteData = db.deleteData(data);
    await deleteData.then((value) => getDataProvider());
    notifyListeners();
    return deleteData;
  }

  Future<void> getchartDataProvider(String dateStr) async {
    final items = await db.getSelectedData(dateStr);
    _dataList = items
        .map((data) => MoneySaverModel(
            id: data.id,
            remarks: data.remarks,
            money: data.money,
            category: data.category,
            creationDate: data.creationDate,
            isChecked: data.isChecked))
        .toList();
    notifyListeners();
  }

  Future<void> getSelectedDataProvider(String dateStr) async {
    final items = await db.getSelectedData(dateStr);
    _dataList = items
        .map((data) => MoneySaverModel(
            id: data.id,
            remarks: data.remarks,
            money: data.money,
            category: data.category,
            creationDate: data.creationDate,
            isChecked: data.isChecked))
        .toList();
    notifyListeners();
  }

  Future<void> getDataProvider() async {
    final items = await db.getData();
    _dataList = items
        .map((data) => MoneySaverModel(
            id: data.id,
            remarks: data.remarks,
            money: data.money,
            category: data.category,
            creationDate: data.creationDate,
            isChecked: data.isChecked))
        .toList();
    notifyListeners();
  }
}
