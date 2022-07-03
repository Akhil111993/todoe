import 'package:flutter/foundation.dart';
import 'package:todoe/models/data.dart';

class DataListProvider with ChangeNotifier {
  final List<Data> _dataList = [];
  List<Data> get dataList => _dataList;
  bool itemAdded = false;

  addData(String title) {
    Data data = Data(title);
    _dataList.add(data);
    itemAdded = true;
    notifyListeners();
  }

  removeData(int index) {
    _dataList.removeAt(index);
    notifyListeners();
  }

  onCheckChange(bool isCheckChanged, int index) {
    _dataList[index].isChecked = isCheckChanged;
    itemAdded = false;
    notifyListeners();
  }

  // saveDataList() async {
  //   var box = await Hive.openBox('todoe_db');
  //   await box.put('intArray', [1, 2, 3, 3]);
  //   print('save data list');
  // }
  //
  // retrieveDataList() async {
  //   var box = Hive.box('todoe_db');
  //   _dataList = box.get('dataList') ?? [];
  //   print('retrieve data list');
  //   print('retrieve data list' + box.get('intArray'));
  // }
  //
  // deleteDataList() async {
  //   var box = Hive.box('todoe_db');
  //   await box.delete('dataList');
  // }
}
