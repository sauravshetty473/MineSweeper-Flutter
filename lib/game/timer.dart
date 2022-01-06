import 'dart:async';

import 'package:flutter/material.dart';


class GameTimer extends StatefulWidget {
  List counter;                   // reference to the counter list of parent widget
  bool isResponsive;              // when not responsive, the timer is stopped
  bool letsStart;                 // when first started


  GameTimer({this.isResponsive, this.letsStart, this.counter});
  @override
  _GameTimerState createState() => _GameTimerState();
}

class _GameTimerState extends State<GameTimer> {
  bool isStarted = false;
  Timer _timer;
  int seconds = 0;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);     //setting the duration variable to 1 second
    _timer = new Timer.periodic(                   // every one second this function is executed
      oneSec,
          (Timer timer){
            if(mounted){
              setState(
                    () {
                  widget.counter[0] +=1;          // counter is incremented every duration(1 second)
                },
              );
            }
          }
    );
  }


  @override
  void initState() {

    super.initState();
  }


  @override
  void didUpdateWidget(covariant GameTimer oldWidget) {
    if(!widget.isResponsive&&_timer!=null){
      _timer.cancel();          // if game has ended, then stopping the timer
      return;
    }
    if(widget.letsStart && !isStarted){       // happens only once in a game, timer is started once the first block is pressed
      isStarted = true;
      startTimer();
    }
    super.didUpdateWidget(oldWidget);
  }

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

              // depending on the counter, respective [place value] of the number is displayed,
              // the png file names are like [1.png,2.png etc.]
              child: Image.asset('assets/images/${(widget.counter[0]/100).floor()%10}.png'),

            ),
          ),

          AspectRatio(
            aspectRatio : 0.5,
            child: Container(
              color: Colors.black,
              // depending on the counter, respective [place value] of the number is displayed,
              // the png file names are like [1.png,2.png etc.]
              child: Image.asset('assets/images/${(widget.counter[0]/10).floor()%10}.png'),
            ),
          ),

          AspectRatio(
            aspectRatio : 0.5,
            child: Container(
              color: Colors.black,
              // depending on the counter, respective [place value] of the number is displayed,
              // the png file names are like [1.png,2.png etc.]
              child: Image.asset('assets/images/${(widget.counter[0]%10)}.png'),
            ),
          ),
        ],
      ),
    );
  }
}

