import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:todoe/screens/homescreen.dart';

import 'models/data_list_provider.dart';

void main() async {
  await Hive.initFlutter();
  // await Hive.openBox('todoe_db');
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  runApp(
    ChangeNotifierProvider<DataListProvider>(
      create: (BuildContext context) => DataListProvider(),
      child: const MaterialApp(
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
