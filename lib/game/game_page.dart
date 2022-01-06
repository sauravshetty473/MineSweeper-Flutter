import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweeper/game/flag_count.dart';
import 'package:minesweeper/game/tiles.dart';
import 'package:minesweeper/game/timer.dart';
import 'package:minesweeper/game/winner_banner.dart';
import 'package:minesweeper/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';





class GamePage extends StatefulWidget {            //This is the main Screen that shows up, once the game is started
  int width;
  int height;
  int mineCount;
  String name;


  GamePage({this.width = 10, this.height = 10, this.mineCount = 10, this.name = 'Easy'}); //The constructor takes in width, height and the mine count of the board, according to the level
                              //10, 10, 10 and 'Easy' are the default values, if no value has been passed

  @override
  _GamePageState createState() => _GamePageState();
}




class _GamePageState extends State<GamePage> {


  var flagCount = 10;                      //Stores the number of flags available by the player
  var winningNumber = 0;                   //Stores the no. of revealed blocks to be won. in case of 10x10 with 10 mines, winningNumber is 90. Incremented each time a block is revealed
  var pressedOnes = [0, ];                 //Stores the no. of blocks that are pressed, stored in a list, so that it can be accessed and modified in the child widget
  var counter = [0, ];
  Timer _timer;                            //Timer object to carry out a function at regular intervals
  var grid = [];                           //This stores the info of the game, it is populated with values from -1 to 8, depending on whether the block is a mine(-1)
  var revGrid =[];                         //This stores info of the reveal status of the block
  var flagGrid = [];                       //This stores info of which blocks are flagged
  var flagNumber = [0, ];                  //Stores the no. of flags used
  var mines = [];                          //stores the location of all mines
  var smiley = true;                       //To decide, whether to show a smiley or a frown face
  var isResponsive = true;                 //Makes the complete block responsive or non responsive, based on the games state

  var isStarted = false;                   //is true when the game is started


  void firstStart(){                       //Function to be executed when any block is tapped at first
    if(!isStarted){
      setState(() {                        // if loop so that the set State is called only once, or the game can be started only once
        isStarted = true;
      });
    }
  }


  void setFlag(){                         //Function, when a flag is set on a black
    setState(() {
      flagCount = 10 - flagNumber[0];
    });
  }


  void death(){                          //Function, when tapped on a mine
    setState(() {
      smiley = false;                     // frown face
      isResponsive = false;               // game has ended, so the blocks must be non responsive
      for(var i in mines){
        revGrid[i[0]][i[1]] = true;        // revealing all the mines, once any mine is pressed on,  mines variable stores list of the [x,y] of mine, so setting revGrid[x,y] to true
      }
    });
    Navigator.of(context).push(PageRouteBuilder(             //Showing the winner/loser banner
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return WinnerBanner(won: false,);
        }
    ));
  }

  void win(int row, int col){              //Function, when the player wins, row and col is the [x,y] of the block last pressed
    setState(() {
      revGrid[row][col] = true;           //Revealed the last tapped block
      isResponsive = false;                //making game non responsive

      try{                                     //This try catch is used to set the high score, acc to the level, widget.name gives the level
        var input = pref.getInt('${widget.name}');
        if(input>counter[0]){                  // if the new counter is less than before, the high score is updated
          pref.setInt(widget.name, this.counter[0]);
          //new High score
        }
      }
      catch(e){                      // if high score was not set initially, then catch block will be executed, so directly setting the high score, without checking
        pref.setInt(widget.name, this.counter[0]);
        //new High score
      }
    });
    Navigator.of(context).push(PageRouteBuilder(           //Showing the winner banner
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return WinnerBanner(won: true,);
        }
    ));
  }

  void placeMines(){                               // Function, to place mines, randomly at the start of the game
    var row = <int>[];                              // keeping track of x from [x,y] of placed mines
    var col = <int>[];                              // keeping track of y from [x,y] of placed mines
    var surrAdds = [ [-1, 1], [0,1],  [1,1],          //array containing values, to be added to [x,y] to get its 8 surroundings
                      [-1,0],          [1, 0],
                      [-1,-1], [0,-1], [1,-1]];
    var rand = Random();

    var count = 0;
    while(count < widget.mineCount){                     //condition the check the no. of mines placed

      var rowMid = rand.nextInt(widget.height);          // getting random x
      var colMid = rand.nextInt(widget.width);            // getting random y

      if(grid[rowMid][colMid] != -1){                    // if the mine is not already placed in the grid



        //print(rowMid.toString() + '   ' + colMid.toString());
        grid[rowMid][colMid] = -1; //placed a mine


        mines.add([rowMid, colMid]);  // added to the mines list

        for(var i in surrAdds){                   //accessing all surrounding blocks
          var midRow = rowMid + i[0];
          var midCol = colMid + i[1];


          if(!(midRow == -1|| midRow == widget.height || midCol == -1 || midCol == widget.width)){   // if the new [x,y] obtained is inside the grid, the if loop is executed
            if(grid[midRow][midCol] != -1){

              grid[midRow][midCol] += 1;   // incrementing surrounding areas with 1

            }
          }
        }

        count++;                       //count is increased
      }
    }
  }



  void floodFillCover(int row, int col){                               // Function, to be executed when empty block is tapped. accepts [x,y] of the tapped block


    void floodFill(int row, int col){
      if(row<0 || row == widget.height || col < 0 || col == widget.width)           //if out of range
        return;

      if(grid[row][col] == -1 || revGrid[row][col] || flagGrid[row][col]) {                               // if its a mine or already true i.e revealed // or encounter a flag then stop the function
        return;
      }


      if(![0,-1].contains(grid[row][col])){                                       // if any number, then reveal the number, and stop the function there itself
        revGrid[row][col] = true;
        pressedOnes[0]++;                   // increasing the pressed number, since it is revealed
        return;
      }


      revGrid[row][col] = true; // mark the point so that I know if I passed through it.
      pressedOnes[0]++;         // increasing the pressed number, since it is revealed



      //exploring all 8 directions
      floodFill(row + 1, col);  // then i can either go south
      floodFill(row - 1, col);  // or north
      floodFill(row, col + 1);  // or east
      floodFill(row, col - 1);  // or west

      floodFill(row + 1, col+1);  // north east
      floodFill(row - 1, col+1);  // north west
      floodFill(row+1, col - 1);  // south east
      floodFill(row-1, col - 1);  // south west

      return;
    }

    floodFill(row, col);
    if(pressedOnes[0] == winningNumber){       // checking if win condition is met
      win(row, col);
      return;
    }
    setState(() {           // ro reveal the new grid, since some values has changed


    });
  }



  @override
  void initState() {
    winningNumber = widget.width*widget.height - widget.mineCount;        //calculating the winning number at the start
    grid  = List.generate(widget.height, (row) => List.generate(widget.width, (col) => 0));      // populating the main grid, reveal Grid, and the flag Grid
    revGrid  = List.generate(widget.height, (row) => List.generate(widget.width, (col) => false));
    flagGrid  = List.generate(widget.height, (row) => List.generate(widget.width, (col) => false));

    placeMines();                       // initialising the values, by placing the mines

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return InteractiveViewer(             //widget to zoom in, out, pan
      child: Scaffold(
        backgroundColor: Color.fromARGB(255,192,192,192),

        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                color: Color.fromARGB(255,192,192,192),
                padding: EdgeInsets.all(20),
                child: Column(

                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: Icon( Icons.arrow_back, color: Colors.black, size: 50,),

                          onPressed: (){

                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration.zero,
                                pageBuilder: (_, __, ___) => Home(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),




                    LayoutBuilder(
                        builder: (context, size){
                          return Container(
                            padding: EdgeInsets.all(5),
                            height: 70,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255,192,192,192),
                                border: Border(
                                  right: BorderSide(width: size.maxWidth/100, color: Colors.white),
                                  bottom: BorderSide(width: size.maxWidth/100, color: Colors.white),
                                  top: BorderSide(width: size.maxWidth/100, color: Color.fromARGB(255,128,128,128)),
                                  left: BorderSide(width: size.maxWidth/100, color: Color.fromARGB(255,128,128,128)),
                                )
                            ),


                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [

                                GameTimer(isResponsive: this.isResponsive, letsStart: this.isStarted, counter: counter,),  //widget for the time

                                AspectRatio(         // widget for the smiley face
                                  aspectRatio : 1,
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration: Duration.zero,
                                          pageBuilder: (_, __, ___) => GamePage(height: widget.height, width: widget.width, mineCount: widget.mineCount,),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(255,192,192,192),
                                          border: Border(
                                            top: BorderSide(width: 1, color: Colors.white),
                                            left: BorderSide(width: 1, color: Colors.white),
                                            right: BorderSide(width: 1, color: Color.fromARGB(255,128,128,128)),
                                            bottom: BorderSide(width: 1, color: Color.fromARGB(255,128,128,128)),
                                          )
                                      ),

                                      child: Image.asset('assets/images/${smiley?'smiley':'frowney'}.png'),
                                    ),
                                  ),
                                ),

                                FlagCount(number: this.flagCount,),       // widget for the flag count
                              ],
                            ),

                          );
                        }
                    ),


                    SizedBox(height: 20,),




                    LayoutBuilder(
                        builder: (context, size){
                          return Container(

                            decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border(
                                  right: BorderSide(width: size.maxWidth/100, color: Colors.white),
                                  bottom: BorderSide(width: size.maxWidth/100, color: Colors.white),
                                  top: BorderSide(width: size.maxWidth/100, color: Color.fromARGB(255,128,128,128)),
                                  left: BorderSide(width: size.maxWidth/100, color: Color.fromARGB(255,128,128,128)),
                                )
                            ),


                            child: Column(               // widget for the board, containing the boards.
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(widget.height, (row) => Row(
                                  children: List.generate(widget.width, (col) => NormalTile(revGrid, grid, row, col, getRemaining: floodFillCover, isRevealed: revGrid[row][col], death: death, isResponsive: this.isResponsive, startFirst: firstStart, pressedOnes: pressedOnes, winningNumber: winningNumber, win: win, flagGrid: this.flagGrid, flagNumber: this.flagNumber, setFlag: this.setFlag,)),
                                ))
                            ),
                          );
                        }
                    ),

                    SizedBox(height: 20,),


                  ],
                )
            ),
          )
        ),
      ),
    );
  }
}
