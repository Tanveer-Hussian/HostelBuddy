import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:smart_mess_bill_calculator/Controllers/MenuItemsController.dart';
import 'package:smart_mess_bill_calculator/DataBase/BillModel.dart';

class MessController extends GetxController{
  
   final box = Hive.box<BillModel>('Bill');
   final menuItemsController = Get.find<MenuItemsController>(); 

    RxList<int> quantities = <int>[].obs;
    RxList<int> prices = <int>[].obs;
    RxList<BillModel> allBills = <BillModel>[].obs;

    @override
   void onInit() {
      super.onInit(); 
      _initialSetup();
      loadBills();
   }

    void _initialSetup() {
      _syncQuantitiesWithMenu();

      // keep synced reactively when menu changes
      ever(menuItemsController.allMenuItems, (_) {
        _syncQuantitiesWithMenu();
      });
    }

    void _syncQuantitiesWithMenu() {
      final menuLength = menuItemsController.allMenuItems.length;

      if (quantities.length < menuLength) {
        final diff = menuLength - quantities.length;
        quantities.addAll(List<int>.filled(diff, 0));
        prices.addAll(List<int>.filled(diff, 0));
      } else if (quantities.length > menuLength) {
        quantities.removeRange(menuLength, quantities.length);
        prices.removeRange(menuLength, prices.length);
      }

      quantities.refresh();
      prices.refresh();
    }


    void loadBills() => allBills.assignAll(box.values.toList());

    void saveBill(String name, int price, String mealType){
        final today = DateTime.now();
        final existingIndex = box.values.toList().indexWhere((bill)=>
           bill.itemName == name && 
           bill.mealType == mealType && 
           bill.date.day == today.day &&
           bill.date.month == today.month &&
           bill.date.year == today.year
        );
        if(existingIndex != -1){
            final existing = box.getAt(existingIndex)!;
            existing.quantity += 1;
            existing.itemPrice += price;
          box.putAt(existingIndex, existing);
        }else{
            final bill = BillModel();
            bill.itemName = name;
            bill.itemPrice = price;
            bill.quantity = 1;
            bill.date = DateTime.now();
            bill.mealType = mealType;
          box.add(bill); 
        } 
       loadBills();  
    } 

    void removeBillQuantity(String name, int price, String mealType){
        final today = DateTime.now();
        final existingIndex = box.values.toList().indexWhere((bill)=> 
           bill.itemName == name &&
           bill.mealType == mealType && 
           bill.date.day == today.day && 
           bill.date.month == today.month && 
           bill.date.year == today.year
        ); 
        if(existingIndex != -1){
             final existing = box.getAt(existingIndex)!;
             if(existing.quantity > 1){
               existing.quantity -= 1;
               existing.itemPrice -= price; 
               box.putAt(existingIndex, existing); 
             }else{
               box.deleteAt(existingIndex);
             }
         }

        loadBills(); 
    }


    List<BillModel> getAllBills() => box.values.toList();

    void updateBill(int key, BillModel model) => box.put(key, model);

    void deleteBill(int key) => box.delete(key);

    void clearAllBills() => box.clear();


    void incrementQuantity(int id, int price){
       if(id>=quantities.length){
         _initialSetup();
       }
       quantities[id]++;
       prices[id] = prices[id]+price;
       quantities.refresh();
       prices.refresh();
    }

    void decrementQuantity(int id, int price){
      if(id>=quantities.length) return;
      if(quantities[id]>0){
         quantities[id]--;
         prices[id] = prices[id]-price;
         quantities.refresh(); 
         prices.refresh();
      }
    }

    int totalItemPrices(int id){
       return prices[id];
    } 
  

    int get totalItems => quantities.fold(0, (sum, itemQnty)=> sum+itemQnty);

    int get totalDailyBill => prices.fold(0, (sum, itemPrice)=> sum+itemPrice);
    
    double get totalMealBill => allBills
       .where((bill) => bill.mealType != 'Tea')
       .fold(0.0, (sum, bill) => sum + bill.itemPrice*bill.quantity);

    double get totalTeaBill => allBills
        .where((bill) => bill.mealType == 'Tea')
        .fold(0.0, (sum, bill) => sum + bill.itemPrice*bill.quantity);

    double get totalExtrasBill => allBills
         .where((bill)=> bill.mealType == 'Extras')
         .fold(0.0, (sum,bill)=> sum + bill.itemPrice*bill.quantity); 

    double get totalOutSideBill => allBills
       .where((bill)=> bill.mealType == 'Outside')
       .fold(0.0, (sum,bill)=> sum+bill.itemPrice);        


    // Returns a Map where keys = day of month, values = total amount
    Map<int, double> getDailyBillData({bool includeTea = true}) {
      final Map<int, double> dailyTotals = {};

      for (final bill in allBills) {
        final day = bill.date.day;
        final isTea = bill.mealType == 'Tea';

        if (!includeTea && isTea) continue;

        if (dailyTotals.containsKey(day)) {
          dailyTotals[day] = dailyTotals[day]! + bill.itemPrice*bill.quantity;
        } else {
          dailyTotals[day] = (bill.itemPrice*bill.quantity).toDouble();
        }
      }

      return dailyTotals; // e.g. {1: 250, 2: 310, 3: 180, ...}
    }    


 }
 