import 'package:hive/hive.dart';
import 'package:smart_mess_bill_calculator/DataBase/BillModel.dart';
import 'package:smart_mess_bill_calculator/DataBase/MenuModel.dart';

class Boxes{
  
    static Box<BillModel> getBill() => 
       Hive.box<BillModel>('Bill');

    static Box<MenuModel> getMenu() =>
        Hive.box<MenuModel>('Menu');   
 
 }
