import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_mess_bill_calculator/Controllers/MessController.dart';

class BillPage extends StatelessWidget{

  final controller = Get.find<MessController>();

  @override
  Widget build(BuildContext context) {
     final screenWidth = MediaQuery.of(context).size.width;
    
     return Scaffold(

       backgroundColor: const Color(0xFFF8F9FC),
       
       body: Obx((){
          final bills = controller.allBills;
          if(bills.isEmpty){
            return Center(
              child: Text('No bills available yet!', style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),),
            );
          }
 
         // Group bills by date (day level)
          final groupedBills = <String, List<dynamic>> {};
          for (var bill in bills){
             final dateKey = DateFormat('yyyy-MM-dd').format(bill.date);
             groupedBills.putIfAbsent(dateKey, ()=>[]).add(bill);
          }

         // Sort newest Date first 
          final sortedKeys = groupedBills.keys.toList()
             ..sort((a,b)=> b.compareTo(a));


          return Padding(
            padding: EdgeInsets.symmetric(horizontal:screenWidth*0.05, vertical:16),
            child: ListView.builder(

              itemCount: sortedKeys.length,
              itemBuilder: (context, dateIndex){

                 final dateKey = sortedKeys[dateIndex];
                 final billsForDate = groupedBills[dateKey]!;
                 final formattedDate = DateFormat('EEEE, MMM dd yyyy').format(DateTime.parse(dateKey));
                
                  num dailyBill = 0;
                 for(int i=0; i<billsForDate.length;i++){
                    dailyBill += billsForDate[i].itemPrice; 
                 }

                return Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Date and Daily Total Bill
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate,
                            style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.blueGrey[800]),
                          ),

                          Text('Rs. ${dailyBill}', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.blueGrey[800]),),

                        ],
                      ),
                    ),
                    
                  ...billsForDate.map((bill){
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            leading: CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.blueAccent.withOpacity(0.1),
                              child: Icon(
                                Icons.receipt_long_rounded,
                                color: Colors.blueAccent,
                              ),                  
                            ),
                            title: Text(bill.itemName, style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black87),),
                            subtitle: Text('${bill.mealType}', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Rs. ${bill.itemPrice}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13,color: Colors.grey[800])),
                                Text('Qty: ${bill.quantity}', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[800]),)
                              ],
                            ),
                        
                          ),
                      
                       );
                     }
                    ).toList(),
               
                  ],
                );
              }
            ),
         );
       }
       ),

      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom:60),
      //   child: FloatingActionButton(
      //      shape: CircleBorder(),
      //      backgroundColor: Colors.purple[400],
      //      onPressed: (){},
      //      child: Icon(Icons.print, color: Colors.white,),      
      //    ),
      // ),
       

     );
  }
}
