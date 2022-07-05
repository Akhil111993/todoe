import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:todoe/models/data.dart';
import 'package:todoe/models/data_list_provider.dart';

import '../widgets/add_todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  void dispose() {
    Hive.close;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Provider.of<DataListProvider>(context)
        .setItemLength(DataListProvider.getDataList().values.length);

    if (Provider.of<DataListProvider>(context).isItemAdded()) {
      itemScrollController.scrollTo(
          index: DataListProvider.getDataList().values.length,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              backgroundColor: const Color(0xff757575),
              context: context,
              builder: (BuildContext context) {
                return AddToDo();
              });
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.list),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  const Text(
                    'Todoe',
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    Provider.of<DataListProvider>(context)
                            .getItemLength()
                            .toString() +
                        ' Tasks',
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 20.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  color: Colors.white,
                ),
                child: ValueListenableBuilder<Box<Data>>(
                  valueListenable: DataListProvider.getDataList().listenable(),
                  builder: (context, box, _) {
                    final dataList = box.values.toList().cast<Data>();
                    return ScrollablePositionedList.builder(
                      itemScrollController: itemScrollController,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) => InkWell(
                        onLongPress: () {
                          box.deleteAt(index);
                          Provider.of<DataListProvider>(context, listen: false)
                              .decrementLength();
                        },
                        child: CheckboxListTile(
                          title: Text(
                            dataList[index].title,
                            style: TextStyle(
                                fontSize: 19.0,
                                decoration: dataList[index].isChecked
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          ),
                          activeColor: Colors.red,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          value: dataList[index].isChecked,
                          onChanged: (isCheckChanged) {
                            Data data = Data(dataList[index].title);
                            data.isChecked = isCheckChanged ?? false;
                            box.putAt(index, data);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
