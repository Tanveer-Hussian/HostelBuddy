import 'package:get/get.dart';
import 'package:smart_mess_bill_calculator/Views/BillPage.dart';
import 'package:smart_mess_bill_calculator/Views/CustomizePage.dart';
import 'package:smart_mess_bill_calculator/Views/VisualizePage.dart';
import 'package:smart_mess_bill_calculator/Views/MessPage.dart';

class NavController extends GetxController{
   
    RxInt index = 0.obs;
  
    final pages = [
       MessPage(),
       CustomizePage(),
       VisualizePage(),
       BillPage(),
    ]; 

}
