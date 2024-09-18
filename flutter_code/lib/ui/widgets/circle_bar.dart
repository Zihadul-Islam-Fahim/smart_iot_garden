
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';

class CircleProgress extends StatelessWidget {
  int barValue = 0;
  Color barColor = Colors.blue;
  String barName = "demoName";
  CircleProgress({
    super.key,required this.barValue,required this.barColor,required this.barName
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      widthFactor: 0.8,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleProgressBar(
              strokeWidth: 25,
              foregroundColor: barColor,
              backgroundColor: Colors.black12,
              value: barValue/100.toDouble(),
              animationDuration: Duration(milliseconds: 2200),

              child: Center(
                child: Text(barValue.toString() + "%",style: TextStyle(fontFamily: 'sans',color: barColor,fontWeight: FontWeight.bold,fontSize: 25),),
              ),
            ),
            Text(barName,style: TextStyle(fontSize: 20,color: Colors.white,fontFamily: 'samsung'),)
          ],
        ), ),
    );
  }
}
