import java.util.ArrayList;

/*
A demo of ArrayLists:
We implement Tic Tac Toe on an *infinitely expanding* board.
(Practically: it expands to the right and downward as needed.)

--------------------
Order of Operations:
--------------------
- Hide implementation
- Demo the code by playing with a student
- Ask students how we could use ArrayLists to represent the "board"
- Describe class attributes
- Describe makeMove() implementation

*/
public class TicTacToe {

    // The board is an ArrayList of ArrayLists,
    // much like a 2D-array is an array of arrays.
    private ArrayList<ArrayList<Boolean>> board = new ArrayList<>();

    // Marks a player can place.
    public static final Boolean circle = true; 
    public static final Boolean cross = false;
    private Boolean mark = circle;

    // Make a move on the infinite board.
    public void makeMove(int x, int y) {

        // We start with board = [[]]
        // Suppose x = 2, y = 2, and m = circle.
        // Then we need to add two rows:
        // Start with:
        //   [[]]
        // End with:
        //   [[],
        //    [],
        //    []] 
        while (board.size() <= x) {
            board.add(new ArrayList<>());
        }

        // Step 2: Ensure row x has enough columns.
        // We need to do the same thing except in a specific row.
        // Start with:
        //   [[],
        //    [],
        //    []] 
        // End with:
        //   [[],
        //    [],
        //    [null, null, null]] 
        ArrayList<Boolean> row = board.get(x);
        while (row.size() <= y) {
            row.add(null);  // null = empty square
        }

        // Step 3: Validate.
        // (We need to check that the player is marking an empty square.)
        if (row.get(y) != null) {
            throw new IllegalArgumentException(
                "Square (" + x + ", " + y + ") is already taken."
            );
        }

        // Step 4: Place the move.
        // Start with:
        //   [[],
        //    [],
        //    [null, null, null]] 
        // End with:
        //   [[],
        //    [],
        //    [null, null, circle]]         
        row.set(y, this.mark);

        // Let's announce that we placed a mark and then print the board.
        System.out.println("Placed " + Mark(m) + " at (" + x + ", " + y + ")");
        printBoard();

        // Step 5: Placeholder win check.
        if (checkWin()) {
            System.out.println(m + " wins!");
        }

        // toggle the marker
        this.mark = ! this.mark;
    }

    private boolean checkWin() {
        return false; // not implemented
    }


    public static void main(String[] args) {
        TicTacToe t = new TicTacToe();

        // Exception example:
        // t.makeMove(0, 0, Mark.Circle);
    }

    // ----------------------------------------------
    // Helper: print a mark. 
    // ----------------------------------------------

    public static String Mark(Boolean b) {
        if (b == circle) { 
            return "O";
        }
        return "X";
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

