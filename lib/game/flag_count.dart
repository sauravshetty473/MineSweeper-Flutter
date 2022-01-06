import 'package:flutter/material.dart';




class FlagCount extends StatelessWidget {
  int number;
  FlagCount({this.number});            // takes in the number of flags remaining


  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            right: BorderSide(width: 2, color: Colors.white),
            bottom: BorderSide(width: 2, color: Colors.white),
            top: BorderSide(width: 2, color: Color.fromARGB(255,128,128,128)),
            left: BorderSide(width: 2, color: Color.fromARGB(255,128,128,128)),
          )
      ),

      padding : EdgeInsets.all(1),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio : 0.5,
            child: Container(
              color: Colors.black,

              child: Image.asset('assets/images/${(this.number/100).floor()%10}.png'),          // depending on the number, respective [place value] of the number is displayed,
                                                                                                // the png file names are like [1.png,2.png etc.]
            ),
          ),

          AspectRatio(
            aspectRatio : 0.5,
            child: Container(
              color: Colors.black,
              child: Image.asset('assets/images/${(this.number/10).floor()%10}.png'),
            ),
          ),

          AspectRatio(
            aspectRatio : 0.5,
            child: Container(
              color: Colors.black,
              child: Image.asset('assets/images/${(this.number%10)}.png'),
            ),
          ),
        ],
      ),
    );
  }
}
