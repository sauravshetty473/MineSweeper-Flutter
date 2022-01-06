import 'package:flutter/material.dart';







class NormalTile extends StatefulWidget {          // This is the block widget

  List grid;                                       // The grid containing values from -1 to 8, defining the game
  List revGrid;                                    // grid to store the reveal values of blocks
  List flagGrid;                                   // grid to store the location of flags
  List flagNumber;                                 // List to store the flag number

  int row;                                         // [x] value of the block
  int col;                                         // [y] value of the block
  List pressedOnes;                                // List to store the number of revealed blocks
  int winningNumber;




  // bool values to store the state of the block
  bool isFlagged;
  bool isRevealed;
  bool isResponsive;


  // when tapped
  Function startFirst;

  // when the tapped block is empty
  Function getRemaining;
  //after losing
  Function death;
  //after winning
  Function win;
  //setting a flag
  Function setFlag;




  NormalTile(this.revGrid,this.grid, this.row, this.col,{ this.isFlagged = false, this.isRevealed = false, this.getRemaining, this.death, this.isResponsive, this.startFirst,this.pressedOnes, this.winningNumber, this.win, this.flagGrid, this.flagNumber, this.setFlag
  });
  @override
  _NormalTileState createState() => _NormalTileState();
}

class _NormalTileState extends State<NormalTile> {


  // bool values to reflect the changes locally (not redrawing the parent widget, since its expensive to do so, instead the current block is redrawn with new values
  bool isRevealed;
  bool isFlagged;




  String outputImage(int i){                // returning the image depending on the number of grid[x,y]
    switch(i){
      case -1:
        return 'assets/images/mine.png';
        break;
      case 0:
        return 'assets/images/zero.png';
        break;
      case 1:
        return 'assets/images/one.png';
        break;
      case 2:
        return 'assets/images/two.png';
        break;
      case 3:
        return 'assets/images/three.png';
        break;
      case 4:
        return 'assets/images/four.png';
        break;
      case 5:
        return 'assets/images/five.png';
        break;
      case 6:
        return 'assets/images/six.png';
        break;
      case 7:
        return 'assets/images/seven.png';
        break;
      case 8:
        return 'assets/images/eight.png';
        break;
    }
    return '';
  }

  @override
  void initState() {
    this.isRevealed = widget.isRevealed;            //setting the initial values of both bool values from the constructor values
    this.isFlagged = widget.flagGrid[widget.row][widget.col];
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NormalTile oldWidget) {
    this.isRevealed = widget.revGrid[widget.row][widget.col];
    this.isFlagged = widget.flagGrid[widget.row][widget.col];
    super.didUpdateWidget(oldWidget);
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, size){
            return GestureDetector(            // long press enables flagging
              onLongPress: (){

                if(!this.isRevealed){          // if already revealed, then flagging is not possible
                  if(this.isFlagged){          // if already flagged, then un flagged

                      this.isFlagged = false;  // unflagging
                      widget.flagNumber[0]--;  // decreasing the flag used number
                      widget.flagGrid[widget.row][widget.col] =false; // setting the flagGrid values on [x,y]
                      widget.setFlag();       // updating in the parent widget using callback function

                  }
                  else{                      // if not flagged, then flagged


                      if(widget.flagNumber[0]<10){       // flagging if number of flag placed has not reached its limit
                        this.isFlagged = true;            // flagging
                        widget.flagNumber[0]++;           // incrementing the number of flags
                        widget.flagGrid[widget.row][widget.col] =true;  // setting the flagGrid values on [x,y]
                      }
                      widget.setFlag();          // updating in the parent widget using callback function

                  }
                }
              },

              onTap: !widget.isResponsive||this.isRevealed||this.isFlagged?null: (){         // if the game is still responsive OR this block is not revealed OR this block is not flagged

                if(widget.grid[widget.row][widget.col] == -1){            //if tapped block contains a mine, the death function is called from the parent widget
                  widget.death();
                }
                else if(widget.grid[widget.row][widget.col] == 0){        //if blank block is tapped, the getRemaining(x,y) function of the parent is called
                  widget.startFirst();
                  widget.getRemaining(widget.row, widget.col);
                }
                else{                                                     //if number is tapped
                  if(widget.pressedOnes[0] + 1== widget.winningNumber){   // checking if win condition is fulfilled
                    widget.win(widget.row, widget.col);                   // if win, then win function of parent called
                    return;
                  }

                  widget.pressedOnes[0]++;                                // no. of blocks tapped on, is incremented
                  widget.startFirst();
                  setState(() {
                    this.isRevealed = true;                               // block is revealed, and the revealGrid[x,y] is set to true
                    widget.revGrid[widget.row][widget.col] = true;
                  });
                }

              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255,192,192,192),
                    border: Border(
                      top: BorderSide(width:  isRevealed?0:size.maxWidth/10, color: Colors.white),
                      left: BorderSide(width: isRevealed?0:size.maxWidth/10, color: Colors.white),
                      right: BorderSide(width: isRevealed?0:size.maxWidth/10, color: Color.fromARGB(255,128,128,128)),
                      bottom: BorderSide(width: isRevealed?0:size.maxWidth/10, color: Color.fromARGB(255,128,128,128)),
                    )
                ),



                // if not revealed, blank image is shown, else the corresponding, (number or mine) image is displayed, using the grid[x,y] value
                child: this.isRevealed?Image.asset(outputImage(widget.grid[widget.row][widget.col])): (this.isFlagged?Image.asset('assets/images/flag.png'):SizedBox()),
              ),
            );
          },
        ),
      ),
    );
  }
}
