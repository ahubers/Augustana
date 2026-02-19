package Demo;
import java.util.ArrayList;

/*
A demo of ArrayLists:
We implement Tic Tac Toe on an *infinitely expanding* board.
(Practically: it expands to the right and downward as needed.)
*/
public class TicTacToe {

    // Marks a player can place.
    public enum Mark {
        Cross,
        Circle
    }


    // Make a move on the infinite board.
    public void makeMove(int x, int y, Mark m) {
    }

    private boolean checkWin() {
        return false; // not implemented
    }

    public static void main(String[] args) {
        TicTacToe t = new TicTacToe();
    }


    // ----------------------------------------------
    // Helper: print the current board state.
    // (Ignore me!)
    // ----------------------------------------------
    public void printBoard() {
        int maxX = -1;
        int maxY = -1;

        // Find bounds of occupied area.
        for (int x = 0; x < board.size(); x++) {
            ArrayList<Mark> row = board.get(x);
            for (int y = 0; y < row.size(); y++) {
                if (row.get(y) != null) {
                    maxX = Math.max(maxX, x);
                    maxY = Math.max(maxY, y);
                }
            }
        }

        if (maxX == -1) {
            System.out.println("(board is empty)");
            return;
        }

        // Print the board.
        for (int x = 0; x <= maxX; x++) {
            ArrayList<Mark> row = board.get(x);
            for (int y = 0; y <= maxY; y++) {
                Mark m = (y < row.size()) ? row.get(y) : null;
                char c = (m == Mark.Cross) ? 'X'
                        : (m == Mark.Circle) ? 'O'
                        : '.';
                System.out.print(c + " ");
            }
            System.out.println();
        }
        System.out.println();
    }    
    
}

