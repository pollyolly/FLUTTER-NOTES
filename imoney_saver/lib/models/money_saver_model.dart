// import 'package:intl/intl.dart';

class MoneySaverModel {
  int? id;
  final String remarks;
  final num money;
  final String category;
  final DateTime creationDate;
  final bool isChecked;

//Constructor
  MoneySaverModel(
      {this.id,
      required this.remarks,
      required this.money,
      required this.category,
      required this.creationDate,
      required this.isChecked});

  //to save data in DB need to convert using Map
  Map<String, dynamic> toMap() {
    // DateFormat formatter = DateFormat('yyyy-mm-dd');
    return {
      'id': id,
      'remarks': remarks,
      'creationDate':
          creationDate.toString(), //sqflite does not support datetime data type
      'money': money,
      'category': category,
      'isChecked': isChecked ? 1 : 0 //sqflite does not support boolean
    };
  }

  // MoneySaverModel.fromJson(Map<String, dynamic> json)
  //     : id = json['id'],
  //       remarks = json['remarks'],
  //       creationDate = json['creationDate'],
  //       money = json['money'],
  //       category = json['category'],
  //       isChecked = json['isChecked'];

  // Map<String, dynamic> toJson() {
  //   // DateFormat formatter = DateFormat('yyyy-mm-dd');
  //   return {
  //     'id': id,
  //     'remarks': remarks,
  //     'creationDate':
  //         creationDate.toString(), //sqflite does not support datetime data type
  //     'money': money,
  //     'category': category,
  //     'isChecked': isChecked ? 1 : 0 //sqflite does not support boolean
  //   };
  // }

  //For Debugging //Checking
  @override
  String toString() {
    return 'id $id, remarks: $remarks, creationDate: $creationDate, money: $money, category: $category,isChecked: $isChecked';
  }
}
