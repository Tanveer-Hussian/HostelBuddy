import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_mess_bill_calculator/Controllers/MessController.dart';

class OutsideCard extends StatelessWidget {
  const OutsideCard({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.nameController,
    required this.amountController,
    required this.controller,
    required this.quantityController,
  });

  final double screenHeight;
  final double screenWidth;
  final TextEditingController nameController;
  final TextEditingController amountController;
  final MessController controller;
  final TextEditingController quantityController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight*0.11,
      width: screenWidth*0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [ BoxShadow(color: Colors.black12.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 6)) ]
      ),
      child: Center(
        child: ListTile(
          leading: Container(
            width: 46, height: 46,
             decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.redAccent.withOpacity(0.9), Colors.redAccent.withOpacity(0.6)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.18), blurRadius: 8, offset: const Offset(0,6))]
              ),
             child: Icon(Icons.outdoor_grill, size:32, color: Colors.white),
           ),
    
          title: Text('OutSide', style: GoogleFonts.poppins(fontSize:16, fontWeight: FontWeight.w600),),
          trailing: IconButton(
             onPressed: (){
             // showDialog(context: context, builder: builder)
    
              showDialog(
                 context: context,
                 builder: (context){
                   return AlertDialog(
                    title: Text('Add outSide Food Expense', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                   
    
                    content: SingleChildScrollView(
                        child: Column(
                          children: [
    
                             TextFormField(
                               controller: nameController,
                               decoration: InputDecoration(
                                 border: OutlineInputBorder(),
                                 hintText: 'Enter Item name',
                               ),
                              ),
    
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter amount',
                              ),
                             ),
    
                          ],
                        ),
                      ),
                      
                    actions: [
                        
                         TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Cancel')),
                      
                         ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                               backgroundColor: Colors.redAccent,
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                             ),
                            label: const Text('Save', style: TextStyle(color: Colors.white)),
                            icon: Icon(Icons.save),
                            onPressed: (){
                               final amount = amountController.text;
                               final name = nameController.text.trim();
    
                               controller.saveBill(name,int.parse(amount), 'Outside');
                               
                               amountController.clear(); 
                               nameController.clear();
                               quantityController.clear();                                      
                               Navigator.pop(context);
    
                             }, 
                          ),
    
                        ],
    
                  );},
                );
              },
             
             icon: Icon(Icons.edit_note_rounded, color: Colors.redAccent),
    
          ),
        ),
      ), 
    );
  }
}

