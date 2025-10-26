import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_mess_bill_calculator/Controllers/MenuItemsController.dart';
import 'package:smart_mess_bill_calculator/Controllers/MessController.dart';
import 'package:smart_mess_bill_calculator/DataBase/BillModel.dart';
import 'package:smart_mess_bill_calculator/Widgets/ItemLists.dart';
import 'package:smart_mess_bill_calculator/Widgets/OutSideCard.dart';

class MessPage extends StatelessWidget{

   final controller = Get.find<MessController>();
   final menuController = Get.find<MenuItemsController>();
   // final itemObject = ItemLists();

   final amountController = TextEditingController();
   final nameController = TextEditingController();
   final quantityController = TextEditingController();

    // color palette
    final Color bg = const Color(0xFFFAF9F6);
    final Color cardBg = Colors.white;
    final Gradient headerGradient = const LinearGradient(
       colors: [Color(0xFF4B6CB7), Color(0xFF182848)],
       begin: Alignment.topLeft,
       end: Alignment.bottomRight,
     );
     

  @override
  Widget build(BuildContext context) {

     final screenWidth = MediaQuery.of(context).size.width;
     final screenHeight = MediaQuery.of(context).size.height;

     return Scaffold(

       body: SingleChildScrollView(
         physics: const BouncingScrollPhysics(),
         padding: EdgeInsets.symmetric(horizontal:screenWidth*0.05, vertical:screenHeight*0.015),
         child: Obx((){

              final itemObject = menuController.allMenuItems;
              final breakfastItems = itemObject.where((item)=> (item.mealType ?? '').toLowerCase()=='breakfast').toList();
              final lunchItems = itemObject.where((item)=> (item.mealType ?? '').toLowerCase()=='lunch').toList();
              final dinnerItems = itemObject.where((item)=> (item.mealType??'').toLowerCase()=='dinner').toList();
              final extrasItems = itemObject.where((item)=> (item.mealType??'').toLowerCase()=='extras').toList();
              final teaItems = itemObject.where((item)=> (item.mealType??'').toLowerCase()=='tea').toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              
             children: [
           
              header(context, screenWidth, screenHeight),   
              
               SizedBox(height: screenHeight*0.02,),
           
               
           
               categoryCard(
                  context, icon: Icons.local_cafe_rounded, title: 'Tea & Snacks', 
                  color: Colors.brown.shade400, items:teaItems, 
                  mealType: 'Tea', screenHeight: screenHeight, controller: controller,
                ),
               
               SizedBox(height: screenHeight*0.015,),
           
               categoryCard(
                   context, icon: Icons.free_breakfast_rounded, title:"Breakfast", 
                   color: Colors.orange.shade600, items: breakfastItems,
                   mealType: 'Breakfast', screenHeight: screenHeight, controller: controller
                ), 
           
               SizedBox(height: screenHeight*0.015),
           
               categoryCard(
                   context, icon: Icons.lunch_dining_rounded, title: 'Lunch',
                   color: Colors.green.shade700, items: lunchItems,
                   mealType:'Lunch', screenHeight: screenHeight, controller: controller
               ),
           
               SizedBox(height: screenHeight*0.015),
           
               categoryCard(
                   context, icon: Icons.dinner_dining_rounded, title: 'Dinner', 
                   color: Colors.deepPurple.shade600, items:dinnerItems, 
                   mealType:'Dinner', screenHeight: screenHeight, controller: controller
                ),
           
               SizedBox(height: screenHeight*0.015), 
           
               categoryCard(
                   context, icon: Icons.fastfood_rounded, title: 'Extras', 
                   color: Colors.blue.shade600, items:extrasItems, 
                   mealType:'Extras', screenHeight: screenHeight, controller: controller
                ),
           
               SizedBox(height: screenHeight*0.012),
           
               OutsideCard(screenHeight: screenHeight, screenWidth: screenWidth, nameController: nameController, amountController: amountController, controller: controller, quantityController: quantityController),
           
           
               Row(
                 children: [
                   SizedBox(width: screenWidth*0.3),
                   Container(
                     width: screenWidth*0.3,
                     height: screenHeight*0.25,
                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                     child: Image.asset('assets/IconImages/Eating.png'),
                    ),
                 ],
               ),
           
           
             ],
           );
          
         }
       ),
       ),
     );
  }


   Widget _buildItemImage(String? imagePath) {
      if (imagePath == null || imagePath.isEmpty) {
        return Icon(Icons.image_not_supported);
      }
      // crude file detection: absolute path starts with '/'
      if (imagePath.startsWith('/')) {
        final file = File(imagePath);
        if (file.existsSync()) return Image.file(file, fit: BoxFit.cover);
        // fallback to asset if not found
      }
      // fallback to asset
      return Image.asset(imagePath, fit: BoxFit.cover);
    }


  Widget ItemCard(int id, String title, int price, String imagePath, double screenHeight, String mealType, final MessController controller) {
     return AnimatedContainer(
       curve: Curves.easeInOut,
       duration: Duration(milliseconds: 300),
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(16),
         color: Colors.white,
         boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 6))]
       ),

       child: Padding(
         padding: const EdgeInsets.symmetric(horizontal:3, vertical:6),
         child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
                
                // Image
              Container(
                   height: 55,
                   width: 55,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(16),
                     gradient: LinearGradient(colors: [Colors.grey.shade50, Colors.grey.shade100],)
                   ),
                   child: ClipRRect(
                       borderRadius: BorderRadius.circular(16),
                       child: _buildItemImage(imagePath),
                   ),
                 ),

                 SizedBox(width: 6),
             
                 Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[900],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Rs. $price",
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),
      
                const Spacer(),

                 Obx((){
                     final qty = controller.quantities[id];            
                   return Row(
                     mainAxisSize: MainAxisSize.min,
                     children: [                              
                       circleIconButton(
                          Icons.remove, 
                        Colors.red.shade400,
                          (){
                             controller.decrementQuantity(id, price); 
                             controller.removeBillQuantity(title, price, mealType);
                            }
                        ),
                        const SizedBox(width: 8),
             
                        Container(
                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                           decoration: BoxDecoration(
                              color: qty > 0 ? Colors.green.shade50 : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.withOpacity(0.18)),
                            ),
                           child: AnimatedSwitcher(
                             duration: const Duration(milliseconds: 250),
                             transitionBuilder: (child, animation){
                               return ScaleTransition(scale: animation, child: child);
                             },
                             child: Text(
                                '$qty', 
                                 key: ValueKey<int>(qty),
                                 style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[900]),
                             ),
                           ),
                        ),
                      
                       const SizedBox(width: 10),
                       
                       circleIconButton(
                          Icons.add, 
                        Colors.green.shade600, 
                          (){
                            controller.incrementQuantity(id, price);
                            controller.saveBill(title, price, mealType);
                          }  
                        ),
                      
                     ],
                   );}
                 ),
             ]),
       ),
     );
   }

  Widget circleIconButton(IconData icon, Color color, VoidCallback onTapFunc){
     return GestureDetector(
       onTap: onTapFunc,
       child: Container(
         height: 38,
         width: 38,
         decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [color.withOpacity(0.95), color.withOpacity(0.75)]),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 6)),
            ],
          ),
         child: Icon(icon, color: Colors.white, size: 20,)
       ),
         
     );
   }

  Widget header(BuildContext context, double width, double height){
     return ClipRRect(
       borderRadius: BorderRadius.circular(18),
       child: Stack(
         children:[

           Container(
              height: height*0.20,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [Color(0xFFEEF2FF), Color(0xFFF7F9FB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
                ),
              ),
              child: Image.asset(
                 'assets/IconImages/Buffet.png', 
                 fit: BoxFit.cover, 
                 colorBlendMode:BlendMode.dstATop, 
                 color: Colors.white.withOpacity(0.05),),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: headerGradient.withOpacity(0.12)
                ),
              )
            ),
       
         // content on top
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.02),
              child: Row(
                children: [
                  // rounded emblem
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: headerGradient,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Center(child: Icon(Icons.restaurant_menu_rounded, color: Colors.white, size: 34)),
                  ),

                  SizedBox(width: width * 0.04),

                  // title & subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "What did you eat today?",
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Tap an item to add quantity. We'll track totals for you.",
                          style: GoogleFonts.poppins(fontSize: 12.5, color: Colors.grey[700]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
 
  Widget categoryCard( BuildContext context, {
      required IconData icon,
      required String title,
      required Color color,
      required List items,
      required String mealType,
      required double screenHeight,
      required final MessController controller
    }){
  
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [ BoxShadow(color: Colors.black12.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 6)) ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Theme(
           data: ThemeData().copyWith(dividerColor: Colors.transparent), 
           child: ExpansionTile(
              tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              collapsedBackgroundColor: Colors.transparent,
              collapsedIconColor: color,
              leading: Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                     gradient: LinearGradient(colors: [color.withOpacity(0.9), color.withOpacity(0.6)]),
                     borderRadius: BorderRadius.circular(16),
                     boxShadow: [BoxShadow(color: color.withOpacity(0.18), blurRadius: 8, offset: const Offset(0,6))]
                  ),
                  child: Icon(icon, color: Colors.white,),
               ),
          
              title: Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey[900]),), 
              subtitle: Text('${items.length} options', style: GoogleFonts.poppins(fontSize: 12.5, color: Colors.grey[600]),),
              children: [
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                   child: Column(
                     children: [
                       for(var item in items)
                         Padding(
                           padding: const EdgeInsets.symmetric(vertical: 6),
                           child: ItemCard(item.id, item.itemName, item.itemPrice, item.imagePath, screenHeight, mealType, controller),
                         )                       
                     ],
                   ),
                 )
              ],
           )
        ),
      ),
    );

  }


 }
