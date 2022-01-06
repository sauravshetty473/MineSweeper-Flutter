import 'package:flutter/material.dart';


class Help extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text('Help'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Color.fromARGB(255, 192, 192, 192),
              padding: EdgeInsets.all(20),

              child: LayoutBuilder(
                  builder: (context, size){
                    return Container(
                        padding: EdgeInsets.all(15),


                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border(
                              right: BorderSide(width: size.maxWidth/100, color: Colors.white),
                              bottom: BorderSide(width: size.maxWidth/100, color: Colors.white),
                              top: BorderSide(width: size.maxWidth/100, color: Color.fromARGB(255,128,128,128)),
                              left: BorderSide(width: size.maxWidth/100, color: Color.fromARGB(255,128,128,128)),
                            )
                        ),



                        width: double.infinity,

                        child: Text('1. Click on any block to start the game.\n2. The game ends if selected block contains a mine.\n3. The number on a block specifies the no. of mines surrounding it.\n4. Long press to flag or unflag a block.\n5. Play safe, good luck!', style: TextStyle(fontFamily: 'Command', color: Colors.green, fontSize: 20),)



                    );
                  }
              ),
            ),
          ),
        ],

      ),
    );
  }
}
