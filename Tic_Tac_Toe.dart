import 'dart:io';
import 'dart:math';

List<List<String>> board = [
  [' ', ' ', ' '],
  [' ', ' ', ' '],
  [' ', ' ', ' '],
];

Map<int, List<int>> moveMapping = {
  1: [0, 0],
  2: [0, 1],
  3: [0, 2],
  4: [1, 0],
  5: [1, 1],
  6: [1, 2],
  7: [2, 0],
  8: [2, 1],
  9: [2, 2],
};

void printBoard() {
  // Print the board, showing the numbers for empty spots
  int num = 1;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] == ' ') {
        stdout.write(' $num ');  // Print the number for empty spaces
      } else {
        stdout.write(' ${board[i][j]} ');  // Print X or O for filled spaces
      }
      if (j < 2) stdout.write('|');  // Separate columns with a |
      num++;
    }
    print('');  // Move to the next line after printing a row
    if (i < 2) {
      print('---|---|---');  // Print the horizontal divider after rows
    }
  }
}

bool isValidMove(int move) {
  if (move < 1 || move > 9) return false;
  List<int> pos = moveMapping[move]!;
  return board[pos[0]][pos[1]] == ' ';
}

bool checkWinner(String player) {
  // Check rows
  for (int i = 0; i < 3; i++) {
    if (board[i][0] == player && board[i][1] == player && board[i][2] == player) {
      return true;
    }
  }

  // Check columns
  for (int i = 0; i < 3; i++) {
    if (board[0][i] == player && board[1][i] == player && board[2][i] == player) {
      return true;
    }
  }

  // Check diagonals
  if (board[0][0] == player && board[1][1] == player && board[2][2] == player) {
    return true;
  }
  if (board[0][2] == player && board[1][1] == player && board[2][0] == player) {
    return true;
  }

  return false;
}

// Check if the board is full
bool isFull() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] == ' ') {
        return false;
      }
    }
  }
  return true;
}
// Easy AI
int randomMove() {
  Random rand = Random();
  int move;
  do {
    move = rand.nextInt(9) + 1;  // Picks a number from 1 to 9
  } while (!isValidMove(move));
  print('AI has played at position $move');
  return move;
}

int minimaxAI() {
  int bestScore = -1000;
  int bestMove = 0;

  for (int i = 1; i <= 9; i++) {
    if (isValidMove(i)) {
      List<int> pos = moveMapping[i]!;
      board[pos[0]][pos[1]] = 'O';  // AI is 'O'

      int score = minimax(0, false);
      board[pos[0]][pos[1]] = ' ';  // Undo move

      if (score > bestScore) {
        bestScore = score;
        bestMove = i;
      }
    }
  }

  print('AI has played at position $bestMove');
  return bestMove;
}

int minimax(int depth, bool isMaximizing) {
  if (checkWinner('O')) return 10 - depth;
  if (checkWinner('X')) return depth - 10;
  if (isFull()) return 0;  // Draw

  if (isMaximizing) {
    int bestScore = -1000;
    for (int i = 1; i <= 9; i++) {
      if (isValidMove(i)) {
        List<int> pos = moveMapping[i]!;
        board[pos[0]][pos[1]] = 'O';
        int score = minimax(depth + 1, false);
        board[pos[0]][pos[1]] = ' ';
        bestScore = max(score, bestScore);
      }
    }
    return bestScore;
  } else {
    int bestScore = 1000;
    for (int i = 1; i <= 9; i++) {
      if (isValidMove(i)) {
        List<int> pos = moveMapping[i]!;
        board[pos[0]][pos[1]] = 'X';
        int score = minimax(depth + 1, true);
        board[pos[0]][pos[1]] = ' ';
        bestScore = min(score, bestScore);
      }
    }
    return bestScore;
  }
}

void playGame(bool isAI, bool isHard) {
  String currentPlayer = 'X';
  int moves = 0;
  bool gameWon = false;

  while (moves < 9 && !gameWon) {
    printBoard();

    int move;
    if (currentPlayer == 'O' && isAI) {
      move = isHard ? minimaxAI() : randomMove();  // AI's move (easy or hard)
    } else {
      do {
        print('Player $currentPlayer, enter your move (1-9): ');
        move = int.parse(stdin.readLineSync()!);
      } while (!isValidMove(move));
    }

    List<int> pos = moveMapping[move]!;
    board[pos[0]][pos[1]] = currentPlayer;
    moves++;

    if (checkWinner(currentPlayer)) {
      printBoard();
      print('Player $currentPlayer wins!');
      gameWon = true;
    } else if (moves == 9) {
      printBoard();
      print('It\'s a draw!');
    }

    currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
  }
}

void main() {
  print('Welcome to Tic-Tac-Toe!');
  print('Select game mode:');
  print('1. Player vs Player');
  print('2. Player vs Easy AI');
  print('3. Player vs Hard AI');

  int mode = int.parse(stdin.readLineSync()!);

  if (mode == 1) {
    playGame(false, false);  // Player vs Player
  } else if (mode == 2) {
    playGame(true, false);   // Player vs Easy AI
  } else if (mode == 3) {
    playGame(true, true);    // Player vs Hard AI
  } else {
    print('Invalid selection!');
  }
}