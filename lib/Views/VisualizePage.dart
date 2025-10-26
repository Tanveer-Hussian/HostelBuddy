import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_mess_bill_calculator/Controllers/MessController.dart';

class VisualizePage extends StatefulWidget {

  @override
  State<VisualizePage> createState() => _VisualizePageState();
}

class _VisualizePageState extends State<VisualizePage> {

  final controller = Get.find<MessController>();

  List<String> pieChartList = ['Jan', 'Feb', 'Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  late String pieChoosenValue;

  List<String> lineChartList = ['This week','This month','All Time'];
  late String lineChoosenValue;

  @override   
  void initState(){
     pieChoosenValue = pieChartList[DateTime.now().month-1];
     lineChoosenValue = lineChartList[1]; 
     super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
        child: Obx(() {
      
          final teaBill = controller.totalTeaBill;
          final mealBill = controller.totalMealBill;
          final extrasBill = controller.totalExtrasBill;
          final outsideBill = controller.totalOutSideBill;

          final totalBill = teaBill + mealBill + extrasBill + outsideBill;
          
  //---------------------------------------------------------------------------------------
      
      // Map for storing TotalTeaBill per day (key will be date and value will be Tea bill on that date) 
         Map<int, double> dailyTeaBillMap = {};
      
         for (final bill in controller.allBills){
            if(bill.mealType.trim().toLowerCase()=='tea'){
               final day = bill.date.day;
               final dailyTotal = bill.itemPrice;
              //  print('${day}--${dailyTotal}');
              if(dailyTeaBillMap.containsKey(day)){
                 dailyTeaBillMap[day] = dailyTeaBillMap[day]!+dailyTotal;
              }else{
                 dailyTeaBillMap[day] = dailyTotal.toDouble();
              } 
            }
         }
      
      // Map for storing TotalMealBill per day (key will be date and value will be Meal bill on that date) 
          Map<int, double> dailyMealBillMap = {};
      
          for (final bill in controller.allBills){
              if(['breakfast','lunch','dinner'].contains(bill.mealType.trim().toLowerCase())) {
                 final day = bill.date.day;
                 final dailyTotal  = bill.itemPrice;        
                 if(dailyMealBillMap.containsKey(day)){
                    dailyMealBillMap[day] = dailyMealBillMap[day]!+dailyTotal;
                 }else{
                   dailyMealBillMap[day] = dailyTotal.toDouble();
                 }
              }   
          }
      
      //  Map for storing TotalExtrasBills per day 
         Map<int, double> dailyExtrasBillMap = {};
        
         for(final bill in controller.allBills){
            if(bill.mealType.trim().toLowerCase()=='extras'){
               final day = bill.date.day;
               final dailyTotal = bill.itemPrice;
               if(dailyExtrasBillMap.containsKey(day)){
                  dailyExtrasBillMap[day] = dailyExtrasBillMap[day]!+dailyTotal;
               }else{
                  dailyExtrasBillMap[day] = dailyTotal.toDouble();
               }
            }
         } 

      //  Map for storing TotalOutSideBills per day  
        Map<int, double> dailyOutsideBillMap = {};
        
         for(final bill in controller.allBills){
            if(bill.mealType.trim().toLowerCase()=='outside'){
               final day = bill.date.day;
               final dailyTotal = bill.itemPrice;
               if(dailyOutsideBillMap.containsKey(day)){
                  dailyOutsideBillMap[day] = dailyOutsideBillMap[day]! + dailyTotal;
               }else{
                  dailyOutsideBillMap[day] = dailyTotal.toDouble();
               }
            }
         } 


      // Merge and sort all days
         final allDays = {
           ...dailyMealBillMap.keys,
           ...dailyTeaBillMap.keys,
           ...dailyExtrasBillMap.keys,
           ...dailyOutsideBillMap.keys,
         }.toList()
         ..sort();
      
      // Convert to flSpot
         final mealSpots = allDays.map((day)=>
               FlSpot(day.toDouble(), dailyMealBillMap[day]?.toDouble() ?? 0 )
            ).toList();
      
         final teaSpots = allDays.map((day)=>
                FlSpot(day.toDouble(), dailyTeaBillMap[day]?.toDouble() ?? 0 )    
         ).toList();  

         final extrasSpots = allDays.map((day)=>
               FlSpot(day.toDouble(), dailyExtrasBillMap[day]?.toDouble() ?? 0 )
          ).toList();

         final outSideSpots = allDays.map((day)=>
               FlSpot(day.toDouble(), dailyOutsideBillMap[day]?.toDouble() ?? 0 )
          ).toList(); 
      
          // Compute max value of Y 
      
        double maxMeal = 0;
        double maxTea = 0;
        double maxExtras = 0;
        double maxOutSide = 0;
      
        // Defensive guards against null or empty maps
        if (dailyMealBillMap.isNotEmpty) {
          maxMeal = dailyMealBillMap.values.reduce((a, b) => a > b ? a : b);
        }
        if (dailyTeaBillMap.isNotEmpty) {
          maxTea = dailyTeaBillMap.values.reduce((a, b) => a > b ? a : b);
        }
        if(dailyExtrasBillMap.isNotEmpty){
           maxExtras = dailyExtrasBillMap.values.reduce((a, b)=> a > b ? a:b);
        }
        if(dailyOutsideBillMap.isNotEmpty){
           maxOutSide = dailyOutsideBillMap.values.reduce((a, b)=> a > b ? a:b);
        }
      
       
     //--- Computing maxYValue for LineChart ---
        final double maxYValue;

        if (maxMeal >= maxTea && maxMeal >= maxExtras && maxMeal >= maxOutSide) {
           maxYValue = maxMeal;
        } else if (maxTea >= maxMeal && maxTea >= maxExtras && maxTea >= maxOutSide) {
           maxYValue = maxTea;
        } else if(maxExtras >= maxMeal && maxExtras >= maxTea && maxExtras >= maxOutSide) {
           maxYValue = maxExtras;
        } else{
           maxYValue = maxOutSide;
        }
 
      
  //---------------------------------------------------------------------------------------------
           
          if (totalBill == 0) {
            return Center(
              child: Text(
                'No Expense Tracked yet',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[600]),
              ),
            );
          }
      
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
          // ---- Overview Header ----

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                     //   mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Expense Overview', style: GoogleFonts.poppins(fontSize:19, fontWeight: FontWeight.w700, color: Colors.grey[800]),),
                          SizedBox(height: 4), 
                          Text('Track how you spend in Hostel', style: GoogleFonts.poppins(fontSize:14.5, fontWeight: FontWeight.w500, color: Colors.grey[600]),),
                        ],
                      ),
                    ),

                     DropdownButtonHideUnderline(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal:6, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue[50]!, Colors.blue[100]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],  
                        ),
                        child: DropdownButton(
                          value: pieChoosenValue,
                          dropdownColor: Colors.white,
                          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blueAccent, size: 22,),
                          isDense: true,
                          style: GoogleFonts.poppins(fontSize: 14.5, fontWeight: FontWeight.w500, color: Colors.blueGrey[800]),
                          items: pieChartList.map((String value){
                               return DropdownMenuItem<String>(
                                  value: value, 
                                  child: Text(value)
                               );
                            }
                          ).toList(), 
                          onChanged: (String? newValue){
                            setState(() {
                              pieChoosenValue = newValue!;
                            });
                          }
                        ),
                      ),
                    ),

                  ],
                ),

          // ---- Summary Cards ----
             SizedBox(height: screenHeight*0.02),
    
             Row(
               children: [
                  summaryCard('Total Bill : ',screenWidth, screenHeight, totalBill, [Colors.indigoAccent.shade100, Colors.blueAccent.shade200],),
                  SizedBox(width: screenWidth*0.015),
                  summaryCard('Meal Bill : ', screenWidth, screenHeight, mealBill, [Colors.greenAccent.shade100, Colors.tealAccent.shade200],),
                  SizedBox(width: screenWidth*0.015),
                  summaryCard('Tea Bill : ', screenWidth, screenHeight, teaBill,  [Colors.orangeAccent.shade100, Colors.deepOrangeAccent.shade200]),            
               ],
             ),

    //-----------------------------------------------------------------------------------
                     
          // ---- Pie Chart ----

                SizedBox(height: screenHeight*0.02),

                Text('Expense Breakdown',
                    style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.blueGrey[800])),
                
                const SizedBox(height: 15),
                  
                _pieChartWidget(mealBill, totalBill, teaBill, extrasBill, outsideBill),
                  
                SizedBox(height: screenHeight*0.03),
//----------------------------------------------------------------------------------------------
                     
        // --- Line Chart ----

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  
                  Text('Daily Spending Trend', style: GoogleFonts.poppins(fontSize:16, fontWeight: FontWeight.w600),),
                  
                  Container(
                     width: 95,
                     height: 34,
                     decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                        gradient: LinearGradient(
                           colors: [Colors.blue[50]!, Colors.blue[100]!],
                           begin: Alignment.topLeft,
                           end: Alignment.bottomRight,
                         ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0,3),
                          ),
                         ],  
                      ),
                     child: Center(
                       child: DropdownButton(
                          value: lineChoosenValue,
                          dropdownColor: Colors.white,
                           icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blueAccent, size: 22,),
                            isDense: true,
                            style: GoogleFonts.poppins(fontSize:12, fontWeight: FontWeight.w500, color: Colors.blueGrey[800]),
                       
                          items: lineChartList.map((String? value){
                             return DropdownMenuItem(
                               value: value,
                               child: Text('$value'),
                             );
                           }).toList(), 
                       
                          onChanged: (String? newValue){
                            setState(() {
                              lineChoosenValue = newValue!;
                            });
                          }
                        ),
                     ),
                   )
           
                ],
              ),

              SizedBox(height: screenHeight*0.04),
                                      
             _lineChartWidget(screenWidth, allDays, maxYValue, mealSpots, teaSpots, extrasSpots, outSideSpots),
              
              SizedBox(height: 100),   
                   
            ],       
        ),);
      
      })),
    );
  }



  Container summaryCard(String title,double screenWidth, double screenHeight, double bill, List<Color> gradient) {
    return Container(
        width: screenWidth*0.29,
        height: screenHeight*0.065,
        decoration: BoxDecoration(
           gradient: LinearGradient(
             colors: gradient,
             begin: Alignment.topLeft,
             end: Alignment.bottomRight,
           ),
           borderRadius: BorderRadius.circular(13),
           boxShadow: [
             BoxShadow(
               color: gradient.last.withOpacity(0.3),
               blurRadius: 10,
               offset: const Offset(2, 4),
             ),
           ],
         ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title, style: GoogleFonts.poppins(fontSize:11, fontWeight: FontWeight.w600),),
              Text('${bill.toInt()}', style: GoogleFonts.poppins(fontSize:11, fontWeight: FontWeight.w600),),
            ]
          ),
        ),
            
    );
  }


  SizedBox _pieChartWidget(double mealBill, double totalBill, double teaBill, double extrasBill, double outsideBill) {
     return SizedBox(
        width: double.infinity,
        height: 250,
        child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             SizedBox(width: 40),
          // Pie Chart
            Expanded(
               flex: 6,
               child: PieChart(              
                  PieChartData(
                    sectionsSpace: 1, // space between different pie's. e.g: Pie of Tea and Pie of Meal
                    centerSpaceRadius: 40,
                    startDegreeOffset: -90,
                    sections: [
                      PieChartSectionData(
                          value: mealBill,
                          color: Colors.blueAccent,
                          title:'${(mealBill / totalBill * 100).toStringAsFixed(1)}%',
                          radius: 70,
                          titleStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
                        ),                     
                      PieChartSectionData(
                         value: teaBill,
                         color: Colors.orangeAccent,
                         title: '${(teaBill / totalBill * 100).toStringAsFixed(1)}%',
                         radius: 70,
                         titleStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
                       ),
                      PieChartSectionData(
                         value: extrasBill,
                         color: Colors.deepPurple,
                         title: '${(extrasBill / totalBill *100).toStringAsFixed(1)}%',  
                         radius: 70,
                         titleStyle: GoogleFonts.poppins(fontSize: (extrasBill/totalBill) < 0.1 ? 12: 13, color: Colors.white, fontWeight: FontWeight.w600),
                       ), 
                      PieChartSectionData(
                        value: outsideBill,
                        color: Colors.lightGreen,
                        title: '${(outsideBill / totalBill*100).toStringAsFixed(1)}%',
                        radius: 70,
                        titlePositionPercentageOffset: 0.65,
                        titleStyle: GoogleFonts.poppins(fontSize:(outsideBill/totalBill) < 0.1 ? 12: 13, color: Colors.white, fontWeight: FontWeight.w600), 
                      ) 
                
                    ],
                  ),
                ),
            ),
             SizedBox(width: 40),
          // Legends
             Expanded(
               flex: 4,
               child: Padding(
                 padding: const EdgeInsets.only(left:12),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center, 
                   children: [
                     _legendItem(Colors.blueAccent, "Meals", mealBill),
                        const SizedBox(height:12),
                       _legendItem(Colors.orangeAccent, "Tea", teaBill),
                        const SizedBox(height:12),
                       _legendItem(Colors.purple, 'Extras', extrasBill),
                       const SizedBox(height:12),
                       _legendItem(Colors.lightGreen, 'OutSide', outsideBill),
                   ],
                 ),
               ),
             )
          
            ],
          ),
        );
  }


   Widget _lineChartWidget(double screenWidth, List<int> allDays, double maxYValue, List<FlSpot> mealSpots, List<FlSpot> teaSpots, List<FlSpot> extrasSpots, List<FlSpot> outsideSpots) {
     return Container(
          height: 250,
          width: screenWidth*0.8,
           decoration: BoxDecoration(
             color: Colors.white,
             boxShadow: [
               BoxShadow(
                 color: Colors.white.withOpacity(0.05),
                 blurRadius: 0.8,
                 offset: Offset(0,3)
               )
             ]
           ),
          child: LineChart(
          
            LineChartData(
          
              minX: allDays.first.toDouble(),
              maxX: (allDays.last).toDouble(),
              minY: 0,
              maxY: (maxYValue==0 ? 100 : maxYValue*1.15),
          
              titlesData: FlTitlesData(
          
                  bottomTitles:  AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: (allDays.length/5).ceilToDouble(),
                        getTitlesWidget: (value,meta){
                          return Text(value.toInt().toString(), style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[700]));
                        }
                      ),
                  ),
          
                  leftTitles:  AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      interval: (maxYValue/4).ceilToDouble(),
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString(), style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[700]));
                      },
                    ),
                  ),
          
                  topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                  ),
          
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
          
              ),
              
              gridData: FlGridData(show: true, drawVerticalLine: true),
              
              borderData: FlBorderData(show: false),
              
              lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        final label;
                          if(spot.bar.color == Colors.blueAccent){
                            label = 'meal'; 
                          }else if(spot.bar.color == Colors.orangeAccent){
                              label = 'tea';
                          }else if(spot.bar.color == Colors.purple){
                              label = 'extras';
                          }else{
                              label = 'outside';
                          } 

                        return LineTooltipItem(
                          '$label: Rs ${spot.y.toStringAsFixed(0)}',
                          GoogleFonts.poppins(
                              fontSize: 11, fontWeight: FontWeight.w500),
                        );
                      }).toList();
                      },
                    )
                ),
              
              lineBarsData: [

                LineChartBarData(
                  spots: mealSpots,
                  isCurved: true,
                  color: Colors.blueAccent,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blueAccent.withOpacity(0.15),
                  ),
                ),

                LineChartBarData(
                  spots: teaSpots,
                  isCurved: true,
                  color: Colors.orangeAccent,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.orangeAccent.withOpacity(0.15),
                  ),
                ),

                LineChartBarData(
                    spots: extrasSpots,
                    isCurved: true,
                    color: Colors.purple,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.purpleAccent.withOpacity(0.15),
                    ),
                ),
                
                LineChartBarData(
                  spots: outsideSpots,
                  isCurved: true,
                  color: Colors.lightGreen,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.lightGreenAccent.withOpacity(0.15),
                  )
                )

              ],                                       
          
            ),
          
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOut,
          
          ),
          
      );
  }


  Widget _legendItem(Color color, String title, double bill) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[800], fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left:8),
          child: Text('${bill}', style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w600),),
        ),


      ],
    );
  }


 }
