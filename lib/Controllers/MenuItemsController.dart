import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:smart_mess_bill_calculator/DataBase/MenuModel.dart';
import 'package:smart_mess_bill_calculator/Widgets/ItemLists.dart';

class MenuItemsController extends GetxController{

   final box = Hive.box<MenuModel>('Menu');
   RxList<MenuModel> allMenuItems = <MenuModel>[].obs;

  @override
  void onInit(){
     super.onInit(); 

     if(box.isEmpty){
       _loadDefaultMenuItems();
     }
     _loadData(); 
  }

   List<MenuModel> getAllItems() => box.values.toList();

   void _loadDefaultMenuItems() {
      final itemsList = ItemLists();

      for (var i in itemsList.BreakFast){
        final model = MenuModel();
      
         model.id = i.id;
         model.itemName = i.name;
         model.itemPrice = i.price;
         model.imagePath = i.imagePath;
         model.mealType = 'BreakFast';

        box.put(model.id,model);
      }  

      for (var i in itemsList.Lunch){
        final model = MenuModel();     
         model.id = i.id;
         model.itemName = i.name;
         model.itemPrice = i.price;
         model.imagePath = i.imagePath;
         model.mealType = 'Lunch';
        box.put(model.id,model);
      } 

      for (var i in itemsList.Dinner){
        final model = MenuModel();     
         model.id = i.id;
         model.itemName = i.name;
         model.itemPrice = i.price;
         model.imagePath = i.imagePath;
         model.mealType = 'Dinner';
        box.put(model.id, model);
      } 

      for (var i in itemsList.Extras){
        final model = MenuModel();     
         model.id = i.id;
         model.itemName = i.name;
         model.itemPrice = i.price;
         model.imagePath = i.imagePath;
         model.mealType = 'Extras';
        box.put(model.id,model);
      } 
   
      for (var i in itemsList.Tea){
        final model = MenuModel();     
         model.id = i.id;
         model.itemName = i.name;
         model.itemPrice = i.price;
         model.imagePath = i.imagePath;
         model.mealType = 'Tea';
        box.put(model.id,model);
      } 

   }

   void _loadData(){
      allMenuItems.assignAll(box.values.toList());
   }

   void addItem(int id,String name, int price, String imagePath, String category){
      final model = MenuModel();
       model.id = id;
       model.itemName = name;
       model.itemPrice = price;
       model.imagePath = imagePath;
       model.mealType = category;

      box.put(model.id, model); 
      _loadData();
   }

   void updateItem(final id, String name, int price, String imagePath, String category){
      final model = box.get(id)!;
    
       model.itemName = name;
       model.itemPrice = price;
       model.imagePath = imagePath;
       model.mealType = category; 
      
      box.put(id, model);
      _loadData();
   }

   void deleteItem(final id){
      box.delete(id);
      _loadData();
   }

 }
 
