import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:todoe/models/data_list_provider.dart';

import '../widgets/add_todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool dataRetrieved = false;
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  void dispose() {
    Provider.of<DataListProvider>(context).dispose();
    Hive.close;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var provider = Provider.of<DataListProvider>(context);
    // if (dataRetrieved) {
    //   provider.retrieveDataList();
    //   dataRetrieved = true;
    // }
    provider.addListener(() {
      if (provider.itemAdded && provider.dataList.length > 2) {
        itemScrollController.scrollTo(
            index: provider.dataList.length - 1,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOutCubic);
      }
      if (provider.itemAdded) {
        // provider.saveDataList();
      }
    });
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
                            .dataList
                            .length
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
                // Provider.of<DataListProvider>(context)
                //     .dataList[index]
                //     .title,
                child: Consumer<DataListProvider>(
                  builder:
                      (BuildContext context, providerValue, Widget? child) {
                    return ScrollablePositionedList.builder(
                      itemScrollController: itemScrollController,
                      itemCount: providerValue.dataList.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Text(
                            providerValue.dataList[index].title,
                            style: TextStyle(
                                fontSize: 19.0,
                                decoration:
                                    providerValue.dataList[index].isChecked
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                          ),
                          activeColor: Colors.red,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          value: providerValue.dataList[index].isChecked,
                          onChanged: (isCheckChanged) {
                            providerValue.onCheckChange(isCheckChanged!, index);
                          },
                        );
                      },
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
