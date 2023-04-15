


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/types.dart';
import 'dart:ui' show lerpDouble;


var white = ['♙', '♘', '♗', '♖', '♕', '♔'],
 black = ['♟', '♞', '♝', '♜', '♛', '♚'],
 wKing = white[5],
 wQueen = white[4],
 wR = white[3],
 wB = white[2],
 wN = white[1],
 wP = white[0],
 bKing = black[5],
 bQueen = black[4],
 bR = black[3],
 bB = black[2],
 bN = black[1],
 bP = black[0];



//Square class
class Square extends StatefulWidget {
  //Every Square has a x and y
  // May have a piece on it
  late String shape;
  Image? shapeOn;
  int _x;
  int _y;
  late Color color;
  final onTap;

  Square(this.shape ,this._x, this._y,this.color,this.onTap, {Key? key}) : super(key: key){
    if(shape == " "){
      shapeOn = null;
    }else{
      shapeOn = Image.asset("lib/images/" + shape+".png");
    }
  }

  @override
  State<Square> createState() => _SquareState();
}

class _SquareState extends State<Square> {





  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: widget.onTap
      ,
      child: Padding(
        padding: EdgeInsets.all(2.0),

        child: Container(
          height: 50,
          width: 50,
          color: widget.color,
          padding: EdgeInsetsDirectional.all(10),

          child: Center(child: widget.shapeOn)
        ),
      ),
    );


  }
}


class GuiBoard extends StatefulWidget {
   late Board _board;
   late List<List<Square>> _Cells;
   var colors = List.generate(8, (i) => List.generate(8, (j) => Colors.brown));
   var shapes = List.generate(8, (i) => List.generate(8, (j) => " "));


   GuiBoard({Key? key}) : super(key: key){


    _Cells = List.generate(8, (i) => List.generate(8, (j) =>Square('a', 1, 1,Colors.white,null)));
    PieceSet whiteSet = PieceSet(true);
    PieceSet blackSet  = PieceSet(false);
    _board = Board(whiteSet,blackSet);
    var white = Colors.white;
    int counter = 0;

    for(int y = 0; y < 8;y++){
      counter = counter + 1;
      for(int x = 0; x < 8; x++){
        if(counter%2==1) white = Colors.white;
        else white = Colors.brown;
        //print(_board.cells[y][x]);

        _Cells[y][x] = Square(_board.cells[y][x], x, y, white,null);
        counter = counter + 1;


      }
    }
    for(int i = 0; i < 8; i++){
      for(int j = 0; j<8; j++){
        if((i%2==0 && j%2==1) || (i%2==1 && j%2==0)) colors[i][j] = Colors.grey;
        if(_board.cells[i][j]!=" "){
          shapes[i][j] = combine(_board.cells[i][j]);
        }
      }

    }

  }
   getCells(){
     return _Cells;
   }
   getBoard(){
     return _board;
   }


  @override
  State<GuiBoard> createState() => _GuiBoardState();
}



class _GuiBoardState extends State<GuiBoard> {
  //Square selectedSquare = Square("shape", -1, -1, false,null);
  tappedPiece(Board b, int x, int y) {
    PieceSet attack;
    if (index % 2 == 1)
      attack = b.whiteSet;
    else
      attack = b.blackSet;
    List<String> white = [wKing, wQueen, wR, wB, wN, wP];
    List<String> black = [bKing, bQueen, bR, bB, bN, bP];
    print(x);
    print(y);


    if (selected == null && b.cells[y][x] != ' ') {
      //No piece was selected - selcet clicked piece
      if ((index % 2 == 1 && white.contains(b.cells[y][x])) ||
          index % 2 == 0 && black.contains(b.cells[y][x])) {
        selected = widget._Cells[y][x];
        setState(() {
          widget.colors[selected!._y][selected!._x] = Colors.green;
          return;
        });
      }
    } else if (selected != null) {

      if(selected!._x == x && selected!._y==y){
        setState(() {
          for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) {
              if ((i % 2 == 0 && j % 2 == 1) || (i % 2 == 1 && j % 2 == 0))
                widget.colors[i][j] = Colors.grey;
              else
                widget.colors[i][j] = Colors.brown;
            }
          }
          //selected!.shape = " ";
          //widget._Cells[y][x].shape = p.shape;

          selected = null;
          return;
        });
      }
      else{
        int oldX = selected!._x;
        int oldY = selected!._y;
      Piece p = b.find(selected?._x, selected?._y, attack) as Piece;
      print(p.shape);
      bool possibleLogic = b.tryMove(p, x, y);



      if(b.makeMove(p, x, y, false)==false) return;
      if((b.makeMove(p, x, y, false)==false) && checked && possibleLogic) return;
      if (b.makeMove(p, x, y, true)) {
        setState(() {
          widget.shapes[oldY][oldX] = " ";
          widget.shapes[y][x] = combine(p.shape);
          for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) {
              if ((i % 2 == 0 && j % 2 == 1) || (i % 2 == 1 && j % 2 == 0))
                widget.colors[i][j] = Colors.grey;
              else
                widget.colors[i][j] = Colors.brown;
            }
          }
          //selected!.shape = " ";
          //widget._Cells[y][x].shape = p.shape;

          selected = null;
          index = index + 1;
        });
      }}
    }
    //widget._board.drawBoard();
  }

  Board b = Board(PieceSet(true), PieceSet(false));
  Square? selected = null;
  int index = 1;
  bool checked = false;
  String color= "";







   void mate(){



   }

  void mateAlert(){

  }
    //This action gets an index and returns if the defence king is in check
   String check(int index){

     String status = "Not in Check";
      bool white = index%2==1;
      PieceSet attack, defence;
      String defenceColor;
      //after white's turn
     if(white){
       defenceColor = "Black";
       attack = b.whiteSet;
       defence = b.blackSet;
     }else{
       //after black's turn
       defenceColor = "White";
       attack = b.blackSet;
       defence = b.whiteSet;
     }


     //print(b.check(!white, defence.getKing().x, defence.getKing().y));
     if(b.check(!white, defence.getKing().x, defence.getKing().y)){
      setState(() {
        status =  "Check";
        checked = true;
      });

     }

     return status;

   }

    //Returns whether white or black will move at current turn
   String getText(int index) {
    if(index %2 == 1){
      //whites turn
      return "White to move";
    }
    //blacks turn
    return "Black to move";

}

  String isMate(){
     if(checked == true) {
       bool white = b.mate(true);
       bool black = b.mate(false);

       return "white: $white \n  black: $black";
     }
     else return " ";
  }


@override
  Widget build(BuildContext context) {

    return MaterialApp(
        home: Scaffold(

            backgroundColor: Colors.blueGrey,
            appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: AppBar(
              title: Column(

                children: [
                  Text(getText(index)),


                    ],


                  )
            ),),
            body:
          

                  Column(

                  children: [
                    SizedBox(
                      height: 100,

                    ),

                  Expanded(
                    child: Column(
                        children:   List.generate(8, (Y) {
                          return Row(
                              children: List.generate(8, (X){
                                if(widget.colors[Y][X] == Colors.grey) color = "white";
                                else color = "black";
                                String piece = combine(widget._board.cells[Y][X]);

                                return Expanded(child:
                                  Square(widget.shapes[Y][X], X,Y,widget.colors[Y][X],() => tappedPiece(b, X, Y))
                                  );
                              }
                              )
                          );
                        })
                    ),
                  ),





                  ]),


            ),



    );
  }
}


