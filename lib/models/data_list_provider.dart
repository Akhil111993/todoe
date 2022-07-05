import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:todoe/models/data.dart';

class DataListProvider extends ChangeNotifier {
  int _itemLength = 0;
  bool _isItemAdded = false;

  static Box<Data> getDataList() => Hive.box<Data>('todoe_db');

  void setItemLength(int itemLength) {
    _itemLength = itemLength;
  }

  int getItemLength() {
    return _itemLength;
  }

  bool isItemAdded() {
    return _isItemAdded;
  }

  void incrementLength() {
    _itemLength++;
    _isItemAdded = true;
    notifyListeners();
  }

  void decrementLength() {
    _itemLength--;
    _isItemAdded = false;
    notifyListeners();
  }
}
