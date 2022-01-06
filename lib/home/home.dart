import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minesweeper/game/game_page.dart';
import 'package:minesweeper/home/difficulty.dart';
import 'package:minesweeper/home/help.dart';
import 'package:minesweeper/main.dart';
import 'package:shared_preferences/shared_preferences.dart';




class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPressed = 0;
  int opacity = 0;
  Timer _timer;
  int seconds = 0;          // storing the seconds passed
  var levels = [           //defining the levels
    Level(name: 'Easy', height: 10, width: 10, mineCount: 10),
    Level(name: 'Medium', height: 20, width: 30, mineCount: 50),
    Level(name: 'Difficult', height: 30, width: 40, mineCount: 100),
  ];

  var selected;


  void onPressed(int i){        // when a difficulty level is pressed, the index i is received
    if(currentPressed == i)       // if its already selected, then exit from the function
      return;
    setState(() {

      selected[i] = true;        // else setting the ith selected to true, and setting the previous selected to false
      selected[currentPressed] = false;

      // setting the current pressed to i
      currentPressed = i;
    });
  }


  @override
  void initState() {           // at the start of the homepage

    for(var i in levels){       // each high score is accessed from local storage and is stored in level.high score
      try{
        i.highScore = pref.getInt(i.name);
      }
      catch(e){
        //nothing is stored in level object, if high score is not stored in local storage, i.e when an error is encountered

      }
    }


    selected = List.generate(levels.length, (index) => false);          // List to store the status of Levels(true if selected)
    selected[0] = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {             // changing the opacity every 1 second using timer variable
      if(mounted){
        setState(() {
          seconds ++;
          opacity = seconds%2;        // flipping the opacity [0/1]
        });
      }
      else{
        _timer.cancel();
      }

    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: Icon(Icons.help), onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Help()),
            );

          })
        ],
      ),


      backgroundColor: Colors.black,
      body: Center(

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Row(
              children: [
                SizedBox(width: 50,),
                Expanded(child: Image.asset('assets/images/minesweeper.png')),
                Text(' Minesweeper', style: TextStyle(
                    fontSize: 50, fontFamily: 'Command', color: Colors.white
                ),),

                SizedBox(width: 50,)
              ],
            ),

            SizedBox(height: 20,),


            SizedBox(height: 20,),


            Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: levels.asMap().entries.map((level) => Difficulty(level: level.value, isPressed: selected[level.key], function: onPressed, number: level.key,)).toList()
              ),
            ),


            AnimatedOpacity(                   // using this widget, to change the opacity smoothly, depending on the current opacity
              duration: Duration(seconds: 1),
              opacity: this.opacity/1 ,
              child: TextButton(
                child:Text('Tap here to start', style: TextStyle(
                    fontSize: 30, fontFamily: 'Command', color: Colors.white
                ),),


                onPressed: (){
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration.zero,
                      pageBuilder: (_, __, ___) => GamePage(height: levels[currentPressed].height, width:  levels[currentPressed].width, mineCount:  levels[currentPressed].mineCount, name: levels[currentPressed].name,),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


