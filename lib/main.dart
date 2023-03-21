// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';

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
          print("here");
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
    if (isWhite && this.y == 1 && y == 3 && x == this.x && cells[y][x] == ' ')
      return true;
    if (!isWhite && this.y == 6 && y == 4 && x == this.x && cells[y][x] == ' ')
      return true;
    if (x == this.x && y == y + add && cells[y][x] == ' ') return true;
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
    for (int i = 0; i < spots.length; i++) {
      int x = spots[i][0];
      int y = spots[i][1];
      if ((x < 0 || x >= 8 || y < 0 || y >= 8) == false) {
        if (tryMove(b.cells, this, x, y) && (b.check(isWhite, x, y) == false))
          return true;
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

class Blocker extends Piece {
  Blocker(shape, x, y, isWhite) : super(shape, x, y, isWhite) {
    this.shape = "B";
  }
}

class Board {
  Board(this.whiteSet, this.blackSet) {
    cells = List.generate(
        8, (i) => List.generate(8, (j) => (i + j) % 2 == 0 ? ' ' : ' '));
    //cells = List.generate(
    //8, (i) => List.generate(8, (j) => (i + j) % 2 == 0 ? "'■'" : '□'));
    setCells();
  }
  late List<List<String>> cells;
  PieceSet whiteSet;
  PieceSet blackSet;

  //Sets all Board cells with the Pieces chars
  void setCells() {
    addSet(whiteSet);
    addSet(blackSet);
  }

  //gets a set of Pieces and adds it to the board
  void addSet(PieceSet troops) {
    var pawns = troops.getPawns();
    for (int i = 0; i < pawns.length; i++) {
      cells[pawns[i].y][pawns[i].x] = pawns[i].shape;
    }
    var r1 = troops.getR1();
    var r2 = troops.getR2();
    var q = troops.getQueen();
    var k = troops.getKing();
    var b1 = troops.getB1();
    var b2 = troops.getB2();
    var n1 = troops.getN1();
    var n2 = troops.getN2();
    cells[k.y][k.x] = k.shape;
    cells[q.y][q.x] = q.shape;
    cells[r1.y][r1.x] = r1.shape;
    cells[r2.y][r2.x] = r2.shape;
    cells[b1.y][b1.x] = b1.shape;
    cells[b2.y][b2.x] = b2.shape;
    cells[n1.y][n1.x] = n1.shape;
    cells[n2.y][n2.x] = n2.shape;
  }

  //draws the board with all the pieces on it

  void drawBoard() {
    print("  A  B  C  D  E  F  G  H");
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells.length; j++) {
        if (j == 0) stdout.write(i + 1);
        stdout.write("[" + cells[i][j] + "]");
      }
      print("");
    }
  }

  //Gets a generic Piece and a location returns if the Piece can move there
  bool tryMove(Piece p, int x, int y) {
    if (p is Pawn) {
      return (p as Pawn).tryMove(x, y, cells);
    }

    if (p is Rook) {
      return (p as Rook).tryMove(cells, p as Rook, x, y);
    }
    //Bishop
    if (p is Bishop) {
      return (p as Bishop).tryMove(cells, p as Bishop, x, y);
    }
    //Queen
    if (p is Queen) {
      String bishop = '';
      String rook = '';

      if (p.isWhite) {
        bishop = '♗';
        rook = '♖';
      } else {
        bishop = '♝';
        rook = '♜';
      }
      bool bishopMove = tryMove(Bishop(bishop, p.x, p.y, p.isWhite), x, y);
      //print(bishopMove);
      bool rookMove = tryMove(Rook(rook, p.x, p.y, p.isWhite), x, y);
      // print(rookMove);
      return bishopMove || rookMove;
    }
    //Knight
    if (p is Knight) {
      if (((y - p.y).abs() == 2 && (x - p.x).abs() == 1) ||
          ((x - p.x).abs() == 2 && (y - p.y).abs() == 1)) {
        if (cells[y][x] == ' ' || p.enemy(cells[y][x])) return true;
      }
    }
    //King
    if (p is King) {}
    return false;
  }

  //Gets a Piece and moves it if possible, if not return false
  bool makeMove(Piece p, int x, int y, bool move) {
    int xBefore = p.x;
    int yBefore = p.y;
    String shapeBefore = cells[y][x];
    PieceSet s;

    if (p.isWhite) {
      s = whiteSet;
    } else {
      s = blackSet;
    }

    if (tryMove(p, x, y)) {
      // move possible

      cells[p.y][p.x] = ' ';
      cells[y][x] = p.shape;
      p.y = y;
      p.x = x;
      cells[p.y][p.x] = p.shape;
      //checks if move cause check
      if (check(p.isWhite, s.getKing().x, s.getKing().y)) {
        cells[y][x] = shapeBefore;
        p.x = xBefore;
        p.y = yBefore;
        if (move) {
          print(
              "Can't allow this move, it cauese check, please make another move");
        }
        return false;
      }
      if (move == false) {
        cells[y][x] = shapeBefore;
        p.x = xBefore;
        p.y = yBefore;
        cells[p.y][p.x] = p.shape;
      }

      return true;
    }
    return false;
  }

  //This action gets a boolean, if true - returns if there is a check on white king
  // if false - returns if there is a check on the black king
  bool check(bool white, int x, int y) {
    PieceSet troops;
    King k;
    if (white) {
      troops = blackSet;
      k = whiteSet._k;
    } else {
      troops = whiteSet;
      k = blackSet._k;
    }

    for (int i = 0; i < troops.getPawns().length; i++) {
      if (tryMove(troops.getPawns()[i], x, y)) return true;
    }
    if ((tryMove(troops._q, x, y)) ||
        (tryMove(troops._r1, x, y)) ||
        (tryMove(troops._r2, x, y)) ||
        (tryMove(troops._b1, x, y)) ||
        (tryMove(troops._b2, x, y)) ||
        (tryMove(troops._n1, x, y)) ||
        (tryMove(troops._n2, x, y))) {
      return true;
    }
    return false;
  }

  //This method is called when king is in check,
  //returns true if check is blockable, else returns false
  bool canBlock(bool isWhite) {
    PieceSet defence;
    PieceSet attack;

    if (isWhite) {
      defence = whiteSet;
      attack = blackSet;
    } else {
      defence = blackSet;
      attack = whiteSet;
    }

    for (int y = 0; y < cells.length; y++) {
      for (int x = 0; x < cells.length; x++) {
        if (cells[y][x] == ' ') {
          cells[y][x] == 'B';
          if (check(isWhite, defence._k.x, defence._k.y) == false) {
            cells[y][x] = ' ';
            if (canMoveAll(defence, x, y)) return true;
          }
        }
      }
    }
    return false;
  }

  //This method is called when king is in check,
  //It gets a place on the board where if a Piece will move there it will block the check
  //returns if there is a move which can block the check
  bool canMoveAll(PieceSet defence, int x, int y) {
    for (int i = 0; i < defence._pawns.length; i++) {
      if (tryMove(defence._pawns[i], x, y)) return true;
    }
    if ((makeMove(defence._q, x, y, false)) ||
        (makeMove(defence._r1, x, y, false)) ||
        (makeMove(defence._r2, x, y, false)) ||
        (makeMove(defence._b1, x, y, false)) ||
        (makeMove(defence._b2, x, y, false)) ||
        (makeMove(defence._n1, x, y, false)) ||
        (makeMove(defence._n2, x, y, false))) {
      return true;
    }
    return false;
  }

  bool mate(bool white) {
    //first let's find if there is a possible king move which escapes the check
    PieceSet defend;
    PieceSet attack;
    if (white) {
      attack = blackSet;
      defend = whiteSet;
    } else {
      defend = blackSet;
      attack = whiteSet;
    }

    if (defend._k.canEscape(this)) return false;
    if (canBlock(white)) return false;

    //Now we check for each one of the defence piece if they can make a move to block the check

    return true;
  }

  //Gets a position on board and splits to x and y
  bool parse(String? spot) {
    var dict = {'A': 0, 'B': 1, 'C': 2, 'D': 3, 'E': 4, 'F': 5, 'G': 6, 'H': 7};
    var digs = {'0', '1', '2', '3', '4', '5', '6', '7'};
    spot = spot as String;
    if (dict.containsKey(spot[0]) == false) return false;
    if (digs.contains(spot[1]) == false) return false;

    return true;
  }

  bool validChoise(int? x, int? y, bool isWhite) {
    var white = ['♙', '♘', '♗', '♖', '♕', '♔'];
    var black = ['♟', '♞', '♝', '♜', '♛', '♚'];
    if ((white.contains(cells[y as int][x as int]) && isWhite) ||
        (black.contains(cells[y][x]) && isWhite == false)) {
      return true;
    }
    return false;
  }

  void game() {
    int i = 1;
    String text;
    bool stop = false;
    PieceSet attack;
    PieceSet defence;
    bool white = true;
    bool checked = false;

    while (stop == false) {
      int? x = 0, y = 0;
      drawBoard();
      if (i % 2 == 1) {
        white = true;
        text = "White to move";
        attack = whiteSet;
        defence = blackSet;
      } else {
        white = false;
        text = "Black to move";
        attack = blackSet;
        defence = whiteSet;
      }

      print(text);
      bool valid = false;
      //Takes user input for piece user want to move
      while (valid == false) {
        //user enters Piece to move
        print("Enter spot on board of the piece you want to move");
        String? current = stdin.readLineSync() as String;
        if (parse(current) == true) {
          var dict = {
            'A': 0,
            'B': 1,
            'C': 2,
            'D': 3,
            'E': 4,
            'F': 5,
            'G': 6,
            'H': 7
          };
          var digs = {'1', '2', '3', '4', '5', '6', '7', '8'};
          x = dict[current[0]];
          y = int.parse(current[1]) - 1;
          valid = true;
        } else {
          print("Spot not valid");
        }
      }
      x = x as int;
      y = y as int;
      print(x);
      print(y);
      //finds the piece on the board
      Piece p = find(x, y, attack) as Piece;
      String s = cells[y][x];
      if (s != p.shape) {
        print("Not found");
        exit(123);
      }

      valid = false;
      //Takes user input for wanted destanation for the piece
      while (valid == false) {
        //asks for place to move the piece
        print("Enter spot on board to move your Piece at :" + s);
        String? dst = stdin.readLineSync() as String;
        if (parse(dst) == true) {
          var dict = {
            'A': 0,
            'B': 1,
            'C': 2,
            'D': 3,
            'E': 4,
            'F': 5,
            'G': 6,
            'H': 7
          };
          var digs = {'0', '1', '2', '3', '4', '5', '6', '7'};
          x = dict[dst[0]];
          y = int.parse(dst[1]) - 1;
          valid = true;
        } else {
          print("Spot not valid");
        }
      }

      x = x as int;
      y = y as int;

      bool can = makeMove(p, x, y, true);
      drawBoard();

      if (check(!white, defence.getKing().x, defence.getKing().y)) {
        print("Check");
        checked = true;
      }
      if (mate(!white)) {
        stop = true;
        print("game ended");
      }
      i = i + 1;
    }
  }

  //This action gets a spot and returns the piece on board in the spot
  Piece? find(int? x, int? y, PieceSet attack) {
    for (int i = 0; i < attack.getPawns().length; i++) {
      Pawn pawn = attack.getPawns()[i];
      if (pawn.isAlive && pawn.x == x && pawn.y == y) {
        return pawn;
      }
    }

    if (attack.getB1().isAlive &&
        attack.getB1().x == x &&
        attack.getB1().y == y) {
      return attack.getB1();
    }
    if (attack.getB2().isAlive &&
        attack.getB2().x == x &&
        attack.getB2().y == y) {
      return attack.getB2();
    }
    if (attack.getR1().isAlive &&
        attack.getR1().x == x &&
        attack.getR1().y == y) {
      return attack.getR1();
    }
    if (attack.getR2().isAlive &&
        attack.getR2().x == x &&
        attack.getR2().y == y) {
      return attack.getR2();
    }

    if (attack.getN1().isAlive &&
        attack.getN1().x == x &&
        attack.getN1().y == y) {
      return attack.getN1();
    }
    if (attack.getN2().isAlive &&
        attack.getN2().x == x &&
        attack.getN2().y == y) {
      return attack.getN2();
    }
    if (attack.getKing().isAlive &&
        attack.getKing().x == x &&
        attack.getKing().y == y) {
      return attack.getKing();
    }
    if (attack.getQueen().isAlive &&
        attack.getQueen().x == x &&
        attack.getQueen().y == y) {
      return attack.getQueen();
    }
    return null;
  }
}

void main(List<String> args) {
  PieceSet s1 = PieceSet(true);
  PieceSet s2 = PieceSet(false);

  Board b = Board(s1, s2);
  b.game();
}
