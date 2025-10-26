import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_mess_bill_calculator/Controllers/NavController.dart';

class HomePage extends StatelessWidget{

   final controller = Get.put(NavController());

   final List<String> titles = [
     'Mess Menu',
     'Customize Menu',
     'Stats and Insights',
     'Bills & History',
  ];

  @override
  Widget build(BuildContext context) {

    final themeGradient = const LinearGradient(
      colors: [Color(0xFF4B6CB7), Color(0xFF182848)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Obx(()=>
      Scaffold(
        extendBody: true,
         appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: themeGradient
              ),
            ),
            title: Text(titles[controller.index.value], style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),), 
            centerTitle: true, 
            backgroundColor: Colors.green,
          ),

         body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: controller.pages[controller.index.value],
          ),

         bottomNavigationBar: Container(
           decoration: const BoxDecoration(
               gradient: LinearGradient(
                 colors: [Color(0xFF182848), Color(0xFF4B6CB7)],
                 begin: Alignment.topLeft,
                 end: Alignment.bottomRight,
               )
           ),
           child: CurvedNavigationBar(
             index: controller.index.value,
             color: Colors.white.withOpacity(0.15),
             backgroundColor: Colors.transparent,
             height: 65,
             buttonBackgroundColor: const Color(0xFF4B6CB7),
             animationDuration: const Duration(milliseconds: 350),
             animationCurve: Curves.easeInOut,
             items: const [
               Icon(Icons.restaurant_menu_rounded, color: Colors.white, size: 28,),
               Icon(Icons.edit, color: Colors.white, size: 28),
               Icon(Icons.bar_chart_rounded, color: Colors.white, size: 28,),
               Icon(Icons.receipt_long_rounded, color: Colors.white, size: 28,),
             ],
             onTap: (value){
               controller.index.value = value;
             },
           ),
         ),
      ),
    );
  }
}
