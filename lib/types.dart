import "main.dart";
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


abstract class Piece {
  Piece(this.shape, this.x, this.y, this.isWhite, {this.isAlive = true}) {
    this.isAlive = true;
    if (index == 0) {
      troops = [];
      index = index + 1;
    }
    troops.add(this);
  }
  late bool isAlive;
  static int index = 0;
  String shape;
  int x;
  int y;
  bool isWhite;
  static late List<Piece> troops;
//This method gets a Shape of a piece and returns true if the Piece is an enemy of the current piece
  bool enemy(String shapeOther) {
    List<String> black = ['♚', '♛', '♜', '♝', '♞', '♟'];
    List<String> white = ['♔', '♕', '♖', '♗', '♘', '♙'];
    if (isWhite && black.contains(shapeOther)) return true;
    if (!isWhite && white.contains(shapeOther)) return true;
    return false;
  }

//This action returns true if the sqaure taken by another piece
  bool canMove(int x, int y) {
    for (int i = 0; i < troops.length; i++) {
      Piece p = troops[i];
      if (p.x == x && p.y == y) return false;
    }
    return true;
  }
}

class Bishop extends Piece {
  Bishop(shape, x, y, isWhite) : super(shape, x, y, isWhite);

  bool tryMove(List<List<String>> cells, Bishop p, int x, int y) {
    int xAdd = 0;
    int yAdd = 0;
    //left - right
    if (p.x < x) {
      xAdd = 1;
    } else
      xAdd = -1;
    //up - down
    if (p.y < y) {
      yAdd = 1;
    } else
      yAdd = -1;
    //counters for each x and y
    int spacex = (p.x - x).abs();

    for (int i = p.x + xAdd, j = p.y + yAdd;
        0 <= spacex && j < 8 && i < 8 && i >= 0 && j >= 0;
        i = i + xAdd, j = j + yAdd) {
      if (cells[j][i] != ' ' && i != x && j != y) {
        return false;
      }
      if (cells[j][i] == ' ' && i == x && j == y) return true;
      if ((x == i) && (y == j) && p.enemy(cells[j][i])) return true;
      spacex = spacex - 1;
    }
    return false;
  }
}

class Rook extends Piece {
  Rook(shape, x, y, isWhite) : super(shape, x, y, isWhite) {
    castled = false;
    moved = false;
  }
  late bool castled;
  late bool moved;
  bool tryMove(List<List<String>> cells, Rook p, int x, int y) {
    int add = 0;
    int space = 0;

    //left - right moves
    if (p.y == y) {
      if (p.x < x) {
        add = 1;
      } else {
        add = -1;
      }
      space = (x - p.x).abs();
      for (int i = p.x + add; space >= 0; i = i + add) {
        if (cells[y][i] != ' ' && i != x) {
          return false;
        }
        if (cells[y][i] == ' ' && x == i) {
         // print("here");
          return true;
        }
        if ((x == i) && p.enemy(cells[y][i])) return true;
        space = space - 1;
      }
    }
    //up - down movement
    if (p.x == x) {
      if (p.y < y) {
        add = 1;
      } else {
        add = -1;
      }
      space = (y - p.y).abs();
      for (int i = p.y; space >= 0; i = i + add) {
        //print(i);
        if (i != p.y) {
          if (cells[i][x] != ' ' && i != y) {
            return false;
          }
          if (cells[i][x] == ' ' && y == i) {
            return true;
          }
          if ((y == i) && p.enemy(cells[i][x])) return true;
          space = space - 1;
        }
      }
    }
    return false;
  }
}

class Pawn extends Piece {
  Pawn(
    shape,
    x,
    y,
    isWhite,
  ) : super(shape, x, y, isWhite) {
    if (isWhite)
      shape = '♙';
    else
      shape = '♟';
  }
  bool tryMove(int x, int y, List<List<String>> cells) {
    int add = 0;
    if (isWhite) {
      add = 1;
    } else {
      add = -1;
    }
    if (isWhite && this.y == 1 && y == 3 && x == this.x && cells[y][x] == ' ') {
      return true;
    }
    if (!isWhite && this.y == 6 && y == 4 && x == this.x && cells[y][x] == ' ')
      return true;

    if (x == this.x && y == this.y + add && cells[y][x] == ' ') return true;
    if (isWhite &&
        (x - this.x).abs() == 1 &&
        y == this.y + 1 &&
        enemy(cells[y][x])) return true;
    if (!isWhite &&
        (x - this.x).abs() == 1 &&
        y == this.y - 1 &&
        enemy(cells[y][x])) return true;
    return false;
  }
}

class Queen extends Piece {
  Queen(shape, x, y, isWhite) : super(shape, x, y, isWhite);
}

class Knight extends Piece {
  Knight(shape, x, y, isWhite) : super(shape, x, y, isWhite);
}

class King extends Piece {
  King(shape, x, y, isWhite) : super(shape, x, y, isWhite) {
    castled = false;
  }
  late bool castled;

  bool tryMove(List<List<String>> cells, King p, int x, int y) {
    if ((x - p.x).abs() < 2 && (y - p.y).abs() < 2) {
      if (p.enemy(cells[y][x]) || cells[y][x] == ' ') return true;
    }
    return false;
  }

  //This method gets the board Arr, Checks if King can make a move to escape check
  bool canEscape(Board b) {
    List<List> spots = [
      [x - 1, y + 1],
      [x - 1, y],
      [x - 1, y - 1],
      [x, y + 1],
      [x, y - 1],
      [x + 1, y + 1],
      [x + 1, y],
      [x + 1, y - 1]
    ];

    print(spots);
    for (int i = 0; i < spots.length; i++) {
      int xi = spots[i][0];
      int yi = spots[i][1];

      if ((xi < 0 || xi >= 8 || yi < 0 || yi >= 8) == false) {
        
        if (b.makeMove(this, xi, yi, false)) return true;
      }
    }
    return false;
  }
}

class PieceSet {
  bool _isWhite;
  late List<Pawn> _pawns;
  late King _k;
  late Queen _q;
  late Bishop _b1;
  late Bishop _b2;
  late Rook _r1;
  late Rook _r2;
  late Knight _n1;
  late Knight _n2;

  King getKing() {
    return _k;
  }

  Queen getQueen() {
    return _q;
  }

  Rook getR1() {
    return _r1;
  }

  Rook getR2() {
    return _r2;
  }

  Bishop getB1() {
    return _b1;
  }

  Bishop getB2() {
    return _b2;
  }

  Knight getN1() {
    return _n1;
  }

  Knight getN2() {
    return _n2;
  }

  List<Pawn> getPawns() {
    return _pawns;
  }

  PieceSet(this._isWhite) {
    List<String> black = ['♚', '♛', '♜', '♝', '♞', '♟'];
    List<String> white = ['♔', '♕', '♖', '♗', '♘', '♙'];
    List<String> shapeSet;
    int pawnIndex = 0, otherIndex = 0;
    _pawns = <Pawn>[];
    if (_isWhite) {
      shapeSet = white;
      pawnIndex = 1;
      otherIndex = 0;
    } else {
      pawnIndex = 6;
      shapeSet = black;
      otherIndex = 7;
    }

    for (int i = 0; i < 8; i++) {
      _pawns.add(Pawn(shapeSet[5], i, pawnIndex, _isWhite));
    }

    _k = King(shapeSet[0], 4, otherIndex, _isWhite);
    _q = Queen(shapeSet[1], 3, otherIndex, _isWhite);
    _r1 = Rook(shapeSet[2], 0, otherIndex, _isWhite);
    _r2 = Rook(shapeSet[2], 7, otherIndex, _isWhite);
    _b1 = Bishop(shapeSet[3], 2, otherIndex, _isWhite);
    _b2 = Bishop(shapeSet[3], 5, otherIndex, _isWhite);
    _n1 = Knight(shapeSet[4], 1, otherIndex, _isWhite);
    _n2 = Knight(shapeSet[4], 6, otherIndex, _isWhite);
  }
}

String combine(String str){

if(str == bKing) return "kingblack";
else if(str == bQueen) return "queenblack";
else if(str == bB) return "bishopblack";
else if(str == bR) return "rookblack";
else if(str == bN) return "knightblack";
else if(str == bP) return "pawnblack";


else if(str == wKing) return "kingwhite";
else if(str == wQueen) return "queenwhite";
else if(str == wB) return "bishopwhite";
else if(str == wR) return "rookwhite";
else if(str == wN) return "knightwhite";
else if(str == wP) return "pawnwhite";

return " ";

}
