import 'package:hive/hive.dart';
part 'MenuModel.g.dart';

@HiveType(typeId: 1)
class MenuModel extends HiveObject{

   @HiveField(0)
   late int id;

   @HiveField(1)
   late String itemName;

   @HiveField(2)
   late int itemPrice;

   @HiveField(3)
   late String imagePath;

   @HiveField(4)
   late String mealType;

}
