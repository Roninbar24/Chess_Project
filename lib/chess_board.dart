import 'dart:io';

void draw_board() {
  // Define the size of the chessboard
  final int size = 8;

  // Define the chess pieces for each player
  final String blackKing = "♚";
  final String blackQueen = '♛';
  final String blackRook = '♜';
  final String blackBishop = '♝';
  final String blackKnight = '♞';
  final String blackPawn = '♟';

  final String whiteKing = '♔';
  final String whiteQueen = '♕';
  final String whiteRook = '♖';
  final String whiteBishop = '♗';
  final String whiteKnight = '♘';
  final String whitePawn = '♙';

  // Create the chessboard as a list of lists, with alternating colors
  final List<List<String>> chessboard = List.generate(
      size, (i) => List.generate(size, (j) => (i + j) % 2 == 0 ? '■' : '□'));

  // Add the black pieces to the board
  chessboard[0][0] = blackRook;
  chessboard[0][1] = blackKnight;
  chessboard[0][2] = blackBishop;
  chessboard[0][3] = blackQueen;
  chessboard[0][4] = blackKing;
  chessboard[0][5] = blackBishop;
  chessboard[0][6] = blackKnight;
  chessboard[0][7] = blackRook;

  for (int i = 0; i < size; i++) {
    chessboard[1][i] = blackPawn;
  }

  // Add the white pieces to the board
  chessboard[7][0] = whiteRook;
  chessboard[7][1] = whiteKnight;
  chessboard[7][2] = whiteBishop;
  chessboard[7][3] = whiteQueen;
  chessboard[7][4] = whiteKing;
  chessboard[7][5] = whiteBishop;
  chessboard[7][6] = whiteKnight;
  chessboard[7][7] = whiteRook;

  for (int i = 0; i < size; i++) {
    chessboard[6][i] = whitePawn;
  }
  String board = "";
  // Print the chessboard
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      board = board + (chessboard[i][j] + ' ');
    }
    board = board + ('\n');
  }
  print(board);
}
