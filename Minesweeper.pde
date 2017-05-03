

import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private static int NUM_ROWS = 20;
private static int NUM_COLS = 20;
private static int NUM_BOMBS = 35;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int y = 0; y < NUM_ROWS; y++)
    {
        for (int x = 0; x < NUM_COLS; x++)
        {
            buttons[y][x] = new MSButton(y,x);
        }
    }
    setBombs();
}
public void setBombs()
{
    for(int i = 0; i < NUM_BOMBS; i++)
    {
        int col = (int)(Math.random()*NUM_COLS);
        int row = (int)(Math.random()*NUM_ROWS);  
        if (!bombs.contains(buttons[row][col]))
        {
            bombs.add(buttons[row][col]);
        }
        else
        {
            i--;
        }
    }

}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    for(int r = 0; r < NUM_ROWS; r++)
        for(int c = 0; c < NUM_COLS; c++)
        {
            if(!bombs.contains(buttons[r][c]) && !buttons[r][c].isClicked())
                return false;
         }
    return true;
    
}
public void displayLosingMessage()
{
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("l");
}
public void displayWinningMessage()
{
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("w");
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if (keyPressed == true)
        {
            marked = !marked;
            if (marked == false)
            {
                clicked = false;
            }
        }
        else if (bombs.contains(this))
            displayLosingMessage();
        else if (countBombs(r,c) > 0)
            label = "" + countBombs(r,c);
        else
        {
            for(int i = -1; i <= 1; i++)
                for(int j = -1; j <= 1; j++)
                {
                    if(r==0 && c==0)
                    {

                    }
                    else if(isValid(r + i, c + j) && buttons[r + i][c + j].isClicked() == false)
                        buttons[r + i][c + j].mousePressed();
                }            
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if(clicked && bombs.contains(this))
            fill(64,77,223);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if (r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0)
        {
            return true;
        }
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int i = -1; i <= 1; i++)
            for(int j = -1; j <= 1; j++)
                if(isValid(r + i, c + j))
                    if(bombs.contains(buttons[r+i][c+j]))
                        numBombs++;

        return numBombs;
    }
}



