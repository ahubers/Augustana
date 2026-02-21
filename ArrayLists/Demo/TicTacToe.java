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

    // The board is going to be an ArrayList of ArrayLists!
    private ArrayList<ArrayList<Mark>> board = new ArrayList<>();

    // Make a move on the infinite board.
    public void makeMove(int x, int y, Mark m) {

        // We start with this list [[]]
        // Say x = 1. Then we need to modify our list to be:
        // 0 [ [] ,
        // 1   [] ]
        while (board.size() <= x) {
            board.add(new ArrayList<>());
        }

        // Step 2: Ensure row x has enough columns.
        // Suppose y = 2 and m = Cross
        // Then need to turn (the above board) into:
        // 0 [ [] ,
        // 1   [null , null, x] ]
        ArrayList<Mark> row = board.get(x);
        while (row.size() <= y) {
            row.add(null);
        }

        if (row.get(y) != null) {
            throw new IllegalArgumentException(
                "Square (" + x + ", " + y + ") is already taken."
            );            
        }

        row.set(y, m);

        if (checkWin()) {
            System.out.println(m + " wins!");
        }

        System.out.println("Placed " + m + " at (" + x + ", " + y + ")");
        printBoard();        

    }

    private boolean checkWin() {
        return false; // not implemented
    }

    public static void main(String[] args) {
        TicTacToe t = new TicTacToe();

        t.makeMove(0, 0, Mark.Cross);
        t.makeMove(1 , 1 , Mark.Circle);
        t.makeMove(10 , 10 , Mark.Cross);
        t.makeMove(2 , 2 , Mark.Circle);
        t.makeMove(100, 100, Mark.Cross);
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

