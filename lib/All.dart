import 'package:flutter/material.dart';
import 'package:flutter_application_1/S.dart';

import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/types.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    GuiBoard b = GuiBoard();
    return  MaterialApp(
      home: Scaffold(
      body: b
      ),

    );
  }


}





  void makeMove(int curX, int curY, Board board, int dstX, int dstY, bool move, bool isWhite){
    PieceSet attack;
    if(isWhite){
      attack = board.whiteSet;
    }else{
      attack = board.blackSet;
    }
    Piece p = board.find(curX, curY , attack) as Piece;
    if(p==null) return;
    if(board.makeMove(p, dstX, dstY, false)){
      //changeGui(int x, int )
    }
  }



