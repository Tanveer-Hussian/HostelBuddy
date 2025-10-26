import 'package:hive/hive.dart';
part 'BillModel.g.dart';

@HiveType(typeId:0)
class BillModel extends HiveObject {
  
    @HiveField(0)
    late String itemName;

    @HiveField(1)
    late int itemPrice;

    @HiveField(2)
    late DateTime date;

    @HiveField(3)
    late String mealType;  // Breakfast or Lunch or Dinner or Tea or Extras

    @HiveField(4)
    int quantity = 1;


 }
