class MoneySaverArguments {
  int? id;
  final String remarks;
  final num money;
  final String category;
  final DateTime creationDate;
  final dynamic isChecked; //set dynamic data type
  MoneySaverArguments(this.id, this.remarks, this.money, this.category,
      this.creationDate, this.isChecked);
}
