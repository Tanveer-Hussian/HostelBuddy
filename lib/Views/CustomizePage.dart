import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_mess_bill_calculator/Controllers/MenuItemsController.dart';

class CustomizePage extends StatelessWidget{

   final menuController = Get.find<MenuItemsController>();

   var nameController = TextEditingController();
   var priceController = TextEditingController();
   
   final newItemIdController = TextEditingController();
   final newItemNameController = TextEditingController();
   final newItemPriceController = TextEditingController();
   final newItemCategoryController = TextEditingController();

   final Rx<File?> _selectedImage = Rx<File?>(null);
   final imagePicker = ImagePicker();

   Future<void> _pickImageFromGallery() async{
      final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
      if(pickedImage==null) return;
      _selectedImage.value = File(pickedImage.path);
      Get.back();
   }

   Future<void> _pickImageFromCamera() async{
      final pickedImage = await imagePicker.pickImage(source:ImageSource.camera);
      if(pickedImage==null) return;
      _selectedImage.value = File(pickedImage.path);
      Get.back();
   }


  @override
  Widget build(BuildContext context) {
     final screenWidth = MediaQuery.of(context).size.width;
     final screenHeight = MediaQuery.of(context).size.height;
     final length = menuController.allMenuItems.length;

    return Scaffold(

       body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEEF2FF), Color(0xFFF7F9FB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
             ),
           ),
         
        child: Obx((){
         
           return SingleChildScrollView(
             physics: const BouncingScrollPhysics(),
             child: Padding(
               padding: EdgeInsets.symmetric(horizontal: screenWidth*0.01),
               child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                        
                   SizedBox(height:screenHeight*0.02),
                   Row(
                     children: [
                       SizedBox(width: 15),
                       Icon(Icons.restaurant_menu_rounded, color:Colors.blueGrey[900], size:26,),
                       SizedBox(width:15),
                       Text('Add, Edit or Delete Item', style: GoogleFonts.poppins(color:Colors.blueGrey[700], fontSize:18, fontWeight: FontWeight.w600),),
                     ],
                   ),
               
                   SizedBox(height:screenHeight*0.02),
              
                   AnimatedSwitcher(
                     duration: const Duration(milliseconds:400),
                     child: ListView.builder(
                        key: ValueKey(menuController.allMenuItems.length),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: menuController.allMenuItems.length,
                        itemBuilder: (context, index){
                           final item = menuController.allMenuItems[index];
                           return Padding(
                             padding: EdgeInsets.only(left:screenWidth*0.04, right:screenWidth*0.04, top: screenWidth*0.01, bottom: screenWidth*0.01),
                           
                             child: AnimatedContainer(
                                duration: const Duration(milliseconds:350),
                                curve: Curves.easeInOutCubic,
                                margin: const EdgeInsets.symmetric(vertical:2),
                                width: screenWidth*0.9,
                                height: screenHeight*0.1,
                                decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(17),
                                   color: Colors.white.withOpacity(0.5),
                                   border: Border.all(
                                       color: Colors.white.withOpacity(0.3),
                                       width: 1.2,
                                    ),
                                   boxShadow: [
                                     BoxShadow(
                                       color: Colors.black.withOpacity(0.05),
                                       blurRadius: 10,
                                       offset: const Offset(0, 5),
                                     ),
                                   ],
                                 ),

                               child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.symmetric(horizontal:14, vertical:8),
                                        leading: Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFF4B6CB7),
                                                Color(0xFF182848)
                                              ],
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: const Icon(Icons.fastfood_rounded,
                                              color: Colors.white, size: 20),
                                         ),
                                        title: Text(
                                          item.itemName,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                         ),
                                        subtitle: Text(
                                          "Rs. ${item.itemPrice}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                   
                         
                                  trailing: Wrap(
                                       children: [
                          
                        // -----<< Edit Item >>------ \\  
                                    IconButton(
                                        onPressed: (){
                                            nameController.text = item.itemName;
                                            priceController.text = item.itemPrice.toString();
                                            Get.dialog(
                                                AlertDialog(
                                                  content: Column(
                                                     mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      TextFormField(
                                                          controller: nameController,
                                                          decoration: InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            labelText: 'Item Name'
                                                          ),
                                                        ),
                                                        SizedBox(height:10),
                                                        TextFormField(
                                                          controller: priceController,
                                                          decoration: InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            labelText: "Price",
                                                          ),
                                                        ),                                              
                                                    ],
                                                  ),
                                         
                                                title: Text('Edit Item', style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
                                                actions: [
                                                    TextButton(onPressed: (){Get.back();}, child:Text('Cancel')),
                                                  
                                                    InkWell(
                                                       onTap: (){                                        
                                                           menuController.updateItem(item.id, nameController.text, int.parse(priceController.text), item.imagePath, item.mealType);                                            
                                                           Get.back();
                                                         },
                                                      child: Container(
                                                         width: 85,
                                                         height: 40,
                                                         decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            color: Colors.purple[400],
                                                          ),
                                                         child: Row(
                                                            children: [
                                                                SizedBox(width: 4),
                                                                Icon(Icons.save, color: Colors.white70,),
                                                                SizedBox(width: 6),
                                                                Text('Save', style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: Colors.white),),
                                                             ],
                                                          )
                                                        ),
                                                    ),
                                              
                                                  ],
                                                )
                                              );
                                            }, 
                                        
                                          icon:Icon(Icons.edit, color: Color.fromARGB(255, 41, 65, 111),)
                          
                                         ),
                          
                        // ----<< Delete Item >>----- \\          
                                   IconButton(
                                      onPressed: () {
                                        Get.dialog(
                                            AlertDialog(
                                              backgroundColor: Colors.white,
                                              title: Text('Delete Item?', style:GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                              content: Text('This action can not be undone', style:GoogleFonts.poppins(fontWeight: FontWeight.w400, color: Colors.blueGrey[600])),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Get.back(); // close dialog
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    menuController.deleteItem(item.id);
                                                    Get.back(); // close dialog
                                                  },
                                                  child: const Text('Delete', style: TextStyle(color: Colors.red),),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                          
                                       icon: const Icon(Icons.delete, color: Color.fromARGB(255, 237, 69, 57),),
                                     
                                      ),
                          
                                     ],
                                   
                                    ),
                           
                                 ),
                                   
                                )
                                  
                                  ),
                              ),
                          );}
                       
                       ),
                   ),
                      
                   SizedBox(height: screenHeight*0.02),
                      
                 ],

               ),
             ),
           );
               }),
     
       ),
  
      floatingActionButton: Padding(
         padding: const EdgeInsets.only(bottom:62),
         child: FloatingActionButton(

            onPressed: (){
               Get.dialog(
                 AlertDialog(
     
                    scrollable: true,
                    title: Text('Add new Item', style:GoogleFonts.poppins(fontWeight: FontWeight.w600),),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                         GestureDetector(
                           onTap: (){
                             Get.bottomSheet(
                               Container(
                                 decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                  ),
                                 padding: EdgeInsets.all(15),
                                 child: Wrap(
                                   children: [
                                      Center(
                                        child: Text("Select Image Source"),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text("Camera"),
                                        onTap: (){_pickImageFromCamera();},
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.photo_library),
                                        title: Text("Gallery"),
                                        onTap: (){_pickImageFromGallery();},
                                      )
                                   ],
                                 ), 
                               )
                             );
                           },
                           child: Obx(()=>
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: _selectedImage.value!=null? FileImage(_selectedImage.value!):null,
                                child: _selectedImage.value==null ? Icon(Icons.add_a_photo): null,
                              ),
                           ),
                         ),
                         SizedBox(height:10),

                         TextFormField(
                           controller: newItemIdController,
                           keyboardType: TextInputType.number,
                           decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'ID: ${menuController.allMenuItems.isNotEmpty ? menuController.allMenuItems.last.id+1 : 0}',
                            ),
                          ),
                         SizedBox(height:10),

                         TextFormField(
                           controller: newItemNameController,
                           keyboardType: TextInputType.text,
                           decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Item Name',
                            ),
                          ),

                         SizedBox(height:10),
                         TextFormField(
                           controller: newItemPriceController,
                           keyboardType: TextInputType.number,
                           decoration: InputDecoration(
                             border: OutlineInputBorder(),
                             hintText: 'Price',
                           ),
                         ),
                          
                         SizedBox(height:10),
                         TextFormField(
                           controller: newItemCategoryController,
                           keyboardType: TextInputType.text,
                           decoration: InputDecoration(
                             border: OutlineInputBorder(),
                             hintText: 'Category',
                           ),
                         ),
                      ],
                    ),

                    actions: [
                       TextButton(
                         onPressed: (){Get.back();},
                         child: Text('Cancel'),
                       ),
                       InkWell(
                         onTap: (){

                          if(_selectedImage.value==null){
                              Get.snackbar('Image required', 'Please select image');
                              return;
                           }

                            menuController.addItem(
                                int.parse(newItemIdController.text),
                                newItemNameController.text, 
                                int.parse(newItemPriceController.text), 
                                _selectedImage.value!.path,
                                newItemCategoryController.text
                             );
                            
                            newItemIdController.clear();
                            newItemNameController.clear();
                            newItemPriceController.clear();
                            newItemCategoryController.clear();
                            _selectedImage.value = null;

                           Get.back();
                          },
                         child: Container(
                           width: 85,
                           height: 42,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                             color: Colors.purple[400],
                           ),
                           child: Row(
                             children: [
                               SizedBox(width:4),
                               Icon(Icons.save, color: Colors.white.withOpacity(0.9),),
                               SizedBox(width:6),
                               Text('Save', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),),
                             ],
                           ),
                         ),
                       ),

                    ],
                
                 )
               );
            }, 
            shape: CircleBorder(),
            backgroundColor: Colors.white,
            child: Icon(Icons.add_rounded, color: Colors.purple, size: 30,), 
         ),
       ),

     );

  }
}




//                                 trailing: Wrap(
//                                   children: [
//                                     IconButton(
//                                       icon: const Icon(Icons.edit,
//                                           color: Color(0xFF4B6CB7)),
//                                       onPressed: () {
//                                         nameController.text = item.itemName;
//                                         priceController.text =
//                                             item.itemPrice.toString();
//                                         Get.dialog(
//                                           FadeTransitionDialog(
//                                             child: _buildEditDialog(
//                                                 item, context),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                     IconButton(
//                                       icon: const Icon(Icons.delete,
//                                           color: Colors.redAccent),
//                                       onPressed: () {
//                                         Get.dialog(
//                                           FadeTransitionDialog(
//                                             child: AlertDialog(
//                                               backgroundColor:
//                                                   Colors.white.withOpacity(0.95),
//                                               shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(18)),
//                                               title: Text('Delete Item?',
//                                                   style: GoogleFonts.poppins(
//                                                       fontWeight:
//                                                           FontWeight.w600)),
//                                               content: Text(
//                                                 'This action cannot be undone.',
//                                                 style: GoogleFonts.poppins(
//                                                     fontWeight: FontWeight.w400,
//                                                     color: Colors.grey[700]),
//                                               ),
//                                               actions: [
//                                                 TextButton(
//                                                   onPressed: () => Get.back(),
//                                                   child: const Text('Cancel'),
//                                                 ),
//                                                 TextButton(
//                                                   onPressed: () {
//                                                     menuController
//                                                         .deleteItem(item.id);
//                                                     Get.back();
//                                                   },
//                                                   child: const Text('Delete',
//                                                       style: TextStyle(
//                                                           color: Colors.red)),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),

//                   SizedBox(height: screenHeight * 0.12),
//                 ],
//                ),
//              ),
//            );
//          }),
//        ),

//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(bottom:60),
//         child: Container(
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//             gradient: LinearGradient(
//               colors: [Color(0xFF4B6CB7), Color(0xFF182848)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 10,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: FloatingActionButton(
//             onPressed: () {
//               Get.dialog(FadeTransitionDialog(child: _buildAddDialog(context)));
//             },
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
//           ),
//         ),
//       ),
//     );
//   }

//   // 🧱 Dialogs and helpers stay same except color harmony
//   Widget _buildAddDialog(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       backgroundColor: Colors.white.withOpacity(0.95),
//       title: Text('Add New Item',
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
//       content: SingleChildScrollView(
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Get.bottomSheet(_imageSourceSheet());
//               },
//               child: Obx(
//                 () => CircleAvatar(
//                   radius: 45,
//                   backgroundImage: _selectedImage.value != null
//                       ? FileImage(_selectedImage.value!)
//                       : null,
//                   backgroundColor: Colors.grey[200],
//                   child: _selectedImage.value == null
//                       ? const Icon(Icons.add_a_photo, color: Colors.grey)
//                       : null,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             _buildTextField(newItemIdController, hint: 'ID${menuController.allMenuItems.length}'),
//             const SizedBox(height: 10),
//             _buildTextField(newItemNameController, hint: 'Item Name'),
//             const SizedBox(height: 10),
//             _buildTextField(newItemPriceController, hint: 'Price'),
//             const SizedBox(height: 10),
//             _buildTextField(newItemCategoryController, hint: 'Category'),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
//         ElevatedButton.icon(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF4B6CB7), // 🎨 changed
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           ),
//           onPressed: () {
//             if (_selectedImage.value == null) {
//               Get.snackbar('Image required', 'Please select an image');
//               return;
//             }
//             menuController.addItem(
//               int.parse(newItemIdController.text),
//               newItemNameController.text,
//               int.parse(newItemPriceController.text),
//               _selectedImage.value!.path,
//               newItemCategoryController.text,
//             );
//             newItemIdController.clear();
//             newItemNameController.clear();
//             newItemPriceController.clear();
//             newItemCategoryController.clear();
//             _selectedImage.value = null;
//             Get.back();
//           },
//           icon: const Icon(Icons.save, color: Colors.white),
//           label: Text('Save',
//               style: GoogleFonts.poppins(
//                   color: Colors.white, fontWeight: FontWeight.w500)),
//         ),
//       ],
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, {required String hint}) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hint,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         filled: true,
//         fillColor: Colors.white,
//       ),
//     );
//   }

//   Widget _imageSourceSheet() {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       padding: const EdgeInsets.all(15),
//       child: Wrap(
//         children: [
//           const Center(
//               child: Text("Select Image Source",
//                   style: TextStyle(fontWeight: FontWeight.w600))),
//           ListTile(
//             leading: const Icon(Icons.camera_alt),
//             title: const Text("Camera"),
//             onTap: _pickImageFromCamera,
//           ),
//           ListTile(
//             leading: const Icon(Icons.photo_library),
//             title: const Text("Gallery"),
//             onTap: _pickImageFromGallery,
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildEditDialog(item, BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       backgroundColor: Colors.white.withOpacity(0.95),
//       title: Text('Edit Item',
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _buildTextField(nameController, hint: 'Item Name'),
//           const SizedBox(height: 10),
//           _buildTextField(priceController, hint: 'Price'),
//         ],
//       ),
//       actions: [
//         TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
//         ElevatedButton.icon(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF4B6CB7), // 🎨 changed
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           ),
//           onPressed: () {
//             menuController.updateItem(
//               item.id,
//               nameController.text,
//               int.parse(priceController.text),
//               item.imagePath,
//               item.mealType,
//             );
//             Get.back();
//           },
//           icon: const Icon(Icons.save, color: Colors.white),
//           label: Text('Save',
//               style: GoogleFonts.poppins(
//                   color: Colors.white, fontWeight: FontWeight.w500)),
//         ),
//       ],
//     );
//   }
// }

// // ✨ same fade transition for dialogs
// class FadeTransitionDialog extends StatelessWidget {
//   final Widget child;
//   const FadeTransitionDialog({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: AnimatedScale(
//         scale: 1,
//         duration: const Duration(milliseconds: 350),
//         curve: Curves.easeOutBack,
//         child: AnimatedOpacity(
//           opacity: 1,
//           duration: const Duration(milliseconds: 300),
//           child: child,
//         ),
//       ),
//     );
//   }
// }
