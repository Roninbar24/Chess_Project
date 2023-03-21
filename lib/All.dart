import 'dart:io';
export 'dart:ui' show Brightness;
abstract class Piece {
  Piece(this.shape, this.x, this.y, this.isWhite) {
    if (index == 0) {
      troops = [];
      index = index + 1;
    }
    troops.add(this);
  }
  static int index = 0;
  String shape;
  int x;
  int y;
  bool isWhite;
  static late List<Piece> troops;

//This action returns true if the sqaure taken by another piece
  bool canMove(int x, int y) {
    for (int i = 0; i < troops.length; i++) {
      Piece p = troops[i];
      if (p.x == x && p.y == y) return false;
    }
    return true;
  }
}

class Rook extends Piece {
  Rook(shape, x, y, isWhite) : super(shape, x, y, isWhite) {
    castled = false;
    moved = false;
    if (isWhite)
      shape = '♖';
    else
      shape = '♜';
  }
  late bool castled;
  late bool moved;
}

class Pawn extends Piece {
  Pawn(shape, x, y, isWhite) : super(shape, x, y, isWhite) {
    if (isWhite)
      shape = '♙';
    else
      shape = '♟';
  }
  bool tryMove(int x, int y) {
    int add;
    if (isWhite)
      add = 1;
    else
      add = -1;
    if (this.x == x && (this.y + add) == y && this.canMove(x, y)) return true;
    if (this.x == x &&
        this.y + 2 * add == y &&
        this.y == 1 &&
        this.canMove(x, y)) return true;
    if ((this.x + 1) == x && (this.y + add) == y && this.canMove(x, y))
      return true;
    if ((this.x - 1) == x && (this.y + add) == y && this.canMove(x, y))
      return true;
    return false;
  }
}

class Board {
  Board() {
    cells = List.generate(
        8, (i) => List.generate(8, (j) => (i + j) % 2 == 0 ? '■' : '□'));
    setCells();
  }
  late List<List<String>> cells;
  //Sets all Board cells with the Pieces chars
  void setCells() {
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells.length; j++) {
        //  if (i == 1)
        //cells[i][j] = "♙";
        //  else if (i == 6)
        //    cells[i][j] = "♟";
        //  else
        cells[i][j] = " ";
      }
    }
  }

  //draws the board with all the pieces on it
  void drawBoard() {
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells.length; j++) {
        stdout.write("[" + cells[i][j] + "]");
      }
      print("");
    }
  }

  bool tryMove(Piece p, int x, int y) {
    if (p.shape == '' || p.shape == '') {
      return p.canMove(x, y);
    }

    if (p.shape == '♖' || p.shape == '♜') {
      int bigger = 0;
      int smaller = 0;
      //Rook check
      int add = 0;
      if (x == p.x) {
        //if moves upwords or downwords
        if (y > p.y) {
          add = 1;
          bigger = y;
          smaller = p.y;
        } else {
          add = -1;
          bigger = p.y;
          smaller = y;
        }
        for (int i = smaller; i < bigger; i++) {
          if (cells[i][x] != ' ' && i != y)
            return false;
          else if ((cells[i][x] != ' ' && i == y) ||
              (cells[i][x] == ' ' && i == y)) return true;
        }
      } else if (y == p.y) {
        //moves left or right
        if (x > p.x) {
          add = 1;
          bigger = x;
          smaller = p.x;
        } else {
          add = -1;
          bigger = p.x;
          smaller = x;
        }
        for (int i = smaller; i < bigger; i++) {
          if (cells[i][y] != ' ' && i != x)
            return false;
          else if ((cells[i][y] != ' ' && i == x) ||
              (cells[i][y] == ' ' && i == x)) return true;
        }
      }
    }
    return false;
  }


}

void main(List<String> args) {
  Board b = Board();
  
  
  Rook r1 = Rook('♖', 1, 2, true);
  print(b.tryMove(r1, 1, 0));
  print(b.tryMove(r1, 0, 2));
  print(b.tryMove(r1, 1, 4));
  print(b.tryMove(r1, 4, 1));
  print(b.tryMove(r1, 4, 2));


  b.cells[2][1] = '♖';
  
  b.drawBoard();
}
