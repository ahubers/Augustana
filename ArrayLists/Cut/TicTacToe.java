package Cut;


// 1. First import ArrayLists
import java.util.ArrayList;

public class TicTacToe {
    /*

    SAY:
    We're going to represent a single move using an enum.
    If you haven't seen an enum before, do not fear:
    it's as if we are using 0-8 for each move, but
    giving a label to each. 

    -------------------------------------------------
    | TopLeft (0)    | Top (1)    | TopRight (2)    |
    | --------------------------------------------- |
    | MiddleLeft (3) | Middle (4) | MiddleRight (5) |
    | --------------------------------------------- |
    | BottomLeft (6) | Bottom (7) | BottomRight (8) |
    -------------------------------------------------
    */
    public enum Move {
        TopLeft, 
        Top,
        TopRight, 
        MiddleLeft, 
        Middle, 
        MiddleRight,
        BottomLeft, 
        Bottom,
        BottomRight
    }

    // The game of tic tac toe is represented 
    // as a list of moves. 
    private ArrayList<Move> moves = new ArrayList<>();

    // 
    public void makeMove(Move m) {

    }

    // 

    public static void main(String[] args) {

    }
}

    // CUT
    // // We initialize this class by letting the user specify
    // // the list of moves. 
    // public TicTacToe(ArrayList<Move> moves) {
    //     this.moves = moves;
    // }

    // Our task is to first validate that this is a legitimate
    // game of tic tac toe. 
    // public Boolean validate() {
    //     for (int i = 0 ; i < this.moves.size() ; i++) {

    //     }
    //     return false;
    // }Z