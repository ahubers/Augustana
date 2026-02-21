import java.util.ArrayList;

/*
A demo of ArrayLists:
We implement Tic Tac Toe on an *infinitely expanding* board.
(Practically: it expands to the right and downward as needed.)

N.b. maybe first go over the planned interface before implementing 
the interface.
*/
public class TicTacToe {

    // 1. Marks a player can place.
    public static Boolean circle = true; 
    public static Boolean cross = false;

    public static String Mark(Boolean b) {
        if (b == circle) { 
            return "O";
        }
        return "X";
    }

    // 2. The board is an ArrayList of ArrayLists.
    private ArrayList<ArrayList<Boolean>> board = new ArrayList<>();

    // Make a move on the infinite board.
    public void makeMove(int x, int y, Boolean m) {

        // Step 1: Ensure enough rows.
        while (board.size() <= x) {
            board.add(new ArrayList<>());
        }

        // Step 2: Ensure row x has enough columns.
        ArrayList<Boolean> row = board.get(x);
        while (row.size() <= y) {
            row.add(null);  // null = empty square
        }

        // Step 3: Validate.
        if (row.get(y) != null) {
            throw new IllegalArgumentException(
                "Square (" + x + ", " + y + ") is already taken."
            );
        }

        // Step 4: Place the move.
        row.set(y, m);

        System.out.println("Placed " + Mark(m) + " at (" + x + ", " + y + ")");
        printBoard();

        // Step 5: Placeholder win check.
        if (checkWin()) {
            System.out.println(m + " wins!");
        }
    }

    private boolean checkWin() {
        return false; // not implemented
    }


    public static void main(String[] args) {
        TicTacToe t = new TicTacToe();

        t.makeMove(0,  0, cross);
        t.makeMove(1,  1, circle);
        t.makeMove(2,  2, cross);
        t.makeMove(5,  5, circle);
        t.makeMove(10, 10, cross);

        // Exception example:
        // t.makeMove(0, 0, Mark.Circle);
    }

       // ----------------------------------------------
    // Helper: print the current board state.
    // ----------------------------------------------
    public void printBoard() {
        int maxX = -1;
        int maxY = -1;

        // Find bounds of occupied area.
        for (int x = 0; x < board.size(); x++) {
            ArrayList<Boolean> row = board.get(x);
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
            ArrayList<Boolean> row = board.get(x);
            for (int y = 0; y <= maxY; y++) {
                Boolean m = (y < row.size()) ? row.get(y) : null;
                char c = (m == cross) ? 'X'
                        : (m == circle) ? 'O'
                        : '.';
                System.out.print(c + " ");
            }
            System.out.println();
        }
        System.out.println();
    }
}

