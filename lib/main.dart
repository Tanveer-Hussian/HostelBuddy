import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_mess_bill_calculator/Controllers/MenuItemsController.dart';
import 'package:smart_mess_bill_calculator/Controllers/MessController.dart';
import 'package:smart_mess_bill_calculator/DataBase/BillModel.dart';
import 'package:smart_mess_bill_calculator/DataBase/MenuModel.dart';
import 'package:smart_mess_bill_calculator/SplashScreen.dart';

void main() async{

    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();

    Hive.registerAdapter(BillModelAdapter());
    Hive.registerAdapter(MenuModelAdapter());

    await Hive.openBox<BillModel>('Bill');
    await Hive.openBox<MenuModel>('Menu');

    Get.put(MenuItemsController());
    Get.put(MessController());

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(),
    );
  }
}
