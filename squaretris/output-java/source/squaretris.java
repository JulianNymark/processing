import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class squaretris extends PApplet {

GameGrid game_grid;

Player p1;
Player p2;

int game_state; // 0 = main_menu, 1 = game, 2 = game_over

public void setup(){
    size(SCREEN_W,SCREEN_H);
  
    game_grid = new GameGrid();
    
    game_state = 0;

    // init players
    p1 = new Player();
    //p2 = new Player();

    // draw starting piece
    addPiece();
    
    // start the game!
    thread("update"); // start the physics / update thread
}

public void draw(){
    // clear screen
    background(100);
  
    // draw grid
    game_grid.draw(); // draw grid -> grid's buffer
    image(game_grid.pg, SPACING, SPACING); // draw grid's buffer
    
    // DEBUG FPS counter
    text("FPS: " + PApplet.parseInt(frameRate), 10, 20);

    // draw player 1 info panel
    p1.draw_panel();
    image(p1.panel, P1_PANEL_X, P1_PANEL_Y);
}


/* Infinite update loop for the game. 
 * this thread runs concurrently with that other infinite loop, draw()
 * separating the draw loop from 'game-time'
 */
public void update(){
    while (true) {
	// sleep game tick (based on level)
	try{
	    Thread.sleep(1000/(p1.level + 1));
	}
	catch (Exception e){
	    System.out.println(e.toString());
	}

	// move piece 1 place down
	movePiece('d');
    }
}

public void movePiece(char dir){
    removePiece(); // remove (don't collide vs self)

    switch (dir) {
    case 'u':
	p1.piece_y -= 1;
	if (checkCollision()){
	    p1.piece_y +=1;
	    addPiece();
	}
	break;
    case 'd':
	p1.piece_y += 1;
	if (checkCollision()){
	    p1.piece_y -=1;
	    landedPiece();
	}
	break;
    case 'l':
	p1.piece_x -= 1;
	if (checkCollision()){
	    p1.piece_x +=1;
	    addPiece();
	}
	break;
    case 'r':
	p1.piece_x += 1;
	if (checkCollision()){
	    p1.piece_x -=1;
	    addPiece();
	}
	break;
    }

// add current piece at its new location -> grid
    addPiece();
}

public void rotatePiece(char dir){
    removePiece();
    
    switch (dir) {
    case 'l': // counter_clockwise
	p1.next.rot = (p1.next.rot + 1) % p1.next.max_rot;
	if (checkCollision()) {
	    if (p1.next.rot == 0){
		p1.next.rot = p1.next.max_rot - 1;
	    }
	    else {
		p1.next.rot = p1.next.rot - 1;
	    }
	}
	break;
    case 'r': // clockwise
	if (p1.next.rot == 0){
	    p1.next.rot = p1.next.max_rot - 1;
	}
	else {
	    p1.next.rot = p1.next.rot - 1;
	}
	if (checkCollision()){
	    p1.next.rot = (p1.next.rot + 1) % p1.next.max_rot;
	}
	break;
    }
    addPiece();
}

public void addPiece(){
    for (int x=0; x<4; ++x) {
	for (int y=0; y<4; ++y) {
	    int block = p1.next.data[p1.next.rot][x][y];
	    if ( block > 0) {
		game_grid.grid[p1.piece_x + x][p1.piece_y + y] = block;
	    }
	}
    }
}

public void removePiece(){
    for (int x=0; x<4; ++x) {
	for (int y=0; y<4; ++y) {
	    int block = p1.next.data[p1.next.rot][x][y];
	    if ( block > 0) {
		game_grid.grid[p1.piece_x + x][p1.piece_y + y] = 0;
	    }
	}
    }
}

public void gameOver(){
    game_state = 2;
    
    PGraphics score_summary = createGraphics(SCREEN_W/2, SCREEN_H/2);
    
    score_summary.beginDraw();
    score_summary.fill(0);
    score_summary.rect(0,0,SCREEN_W/2, SCREEN_H/2);

    score_summary.fill(255);
    score_summary.textSize(30);
    score_summary.textAlign(LEFT, TOP);
    score_summary.text("SCORE: " + p1.score, 0, 0);
    score_summary.text("LEVEL MULTIPLIER: x" + p1.level, 0, 40);
    score_summary.stroke(255);
    score_summary.line(0,80,(SCREEN_W/3)-SPACING,80);
    score_summary.text("FINAL SCORE: " + p1.score*p1.level, 0, 90);
    score_summary.textAlign(RIGHT, BOTTOM);
    score_summary.text("press green to exit!", SCREEN_W/2, SCREEN_H/2);
    score_summary.endDraw();
    
    // submit highscore? TODO
    
    while(true){
	// print random junk
	for (int x=0; x<GRID_W; ++x){
	    for (int y=0; y<GRID_H; ++y){
		game_grid.grid[x][y] = (int) random(9);
	    }
	}
	
	// print game over
	textAlign(CENTER);
	textSize(SCREEN_H/10);
	text("GAME OVER", random(SCREEN_W), random(SCREEN_H));
	
	// score summary box
	image(score_summary, SCREEN_W/4, SCREEN_H/4);
    }
}

public boolean checkCollision(){
    for (int x=0; x<4; ++x) {
	for (int y=0; y<4; ++y) {
	    int block = p1.next.data[p1.next.rot][x][y];
	    if ( block > 0) {
		if (p1.piece_y + y > (GRID_H-1) ||
		    p1.piece_x + x > (GRID_W-1) ||
		    p1.piece_y + y < 0 ||
		    p1.piece_x + x < 0 ||
		    game_grid.grid[p1.piece_x + x][p1.piece_y + y] > 0){
		    return true;
		}
	    }
	}
    }
    return false;
}


public void landedPiece(){
    // add piece where it last collided (landed)
    addPiece();
    
    // check lines
    int lines_done = 0;
    for (int y =0; y<GRID_H; ++y) {
	boolean full_line = true;
	for (int x=0; x<GRID_W; ++x) {
	    if(game_grid.grid[x][y] == 0){
		full_line = false;
	    }
	}
	if (full_line) {
	    // shift all above line down 1
	    for (int y2=y; y2>1; --y2){
		for (int x=0; x<GRID_W; ++x) {
		    game_grid.grid[x][y2] =
			game_grid.grid[x][y2-1];
		}
	    }
	    lines_done +=1;
	}
    }
    
    // lines & score ++
    p1.score += (lines_done * lines_done);
    p1.lines += lines_done;
    if (p1.lines > p1.level*10 + 10) {
	p1.level += 1;
    }
    
    newPiece();
}

public void dropPiece(){
    removePiece();
    boolean dropped = false;
    while(!dropped){
	p1.piece_y += 1;
	if (checkCollision()){
	    dropped = true;
	    p1.piece_y -=1;
	    landedPiece();
	}
    }
}

public void newPiece(){
    p1.cur = p1.next;
    p1.next = new Piece(possible_pieces[(int) random(7)]);
    p1.piece_x = 3;
    p1.piece_y = 0;
    
    // if collide on new piece = game over
    if (checkCollision()){
	gameOver();
    }
    
    addPiece(); // draw new piece
}
class GameGrid {
    PGraphics pg; // game grid's buffer
    int[][] grid;
  
    GameGrid(){
	grid = new int[GRID_W][GRID_H];
	pg = createGraphics((GRID_W*GRID_SIZE) + 1,
			    ((GRID_H-2)*GRID_SIZE) + 1);
    }
  
    // draws grid to grids buffer
    public void draw(){
	pg.beginDraw();
	pg.background(0);
	pg.noStroke();
	pg.fill(255);
	
	int rect_size = GRID_SIZE -1;
    
	for (int x=0; x<GRID_W; ++x){
	    for (int y=2; y<GRID_H; ++y){
		switch (grid[x][y]){
		case 0:
		    pg.noFill();
		    break;
		case 1:
		    pg.fill(CYAN);
		    break;
		case 2:
		    pg.fill(YELLOW);
		    break;
		case 3:
		    pg.fill(PURPLE);
		    break;
		case 4:
		    pg.fill(GREEN);
		    break;
		case 5:
		    pg.fill(RED);
		    break;
		case 6:
		    pg.fill(BLUE);
		    break;
		case 7:
		    pg.fill(ORANGE);
		    break;
		}
		pg.rect(x*GRID_SIZE + 1,
			(y-2)*GRID_SIZE + 1, 
			rect_size, rect_size);
	    }
	}
	pg.endDraw();
    }
}
class Piece {
    int[][][] data; // 0 = none, 1-8 = color
    int rot; // 0 = 0deg, 1 = 90deg etc...
    int max_rot;
    
    Piece(char type){
	switch (type) {
	case 'o':
	    int[][][] o = { { { 0, 0, 0, 0 }, 
			      { 0, 2, 2, 0 },
			      { 0, 2, 2, 0 },
			      { 0, 0, 0, 0 } } };
	    data = o;
	    max_rot = 1;
	    break;
	case 'i':
	    int[][][] i = { { { 0, 0, 0, 0 }, 
			      { 1, 1, 1, 1 },
			      { 0, 0, 0, 0 },
			      { 0, 0, 0, 0 } },
			    { { 0, 0, 1, 0 }, 
			      { 0, 0, 1, 0 },
			      { 0, 0, 1, 0 },
			      { 0, 0, 1, 0 } } };
	    data = i;
	    max_rot = 2;
	    break;
	case 's':
	    int[][][] s = { { { 0, 0, 0, 0 }, 
			      { 0, 0, 4, 4 },
			      { 0, 4, 4, 0 },
			      { 0, 0, 0, 0 } },
			    { { 0, 0, 4, 0 }, 
			      { 0, 0, 4, 4 },
			      { 0, 0, 0, 4 },
			      { 0, 0, 0, 0 } } };
	    data = s;
	    max_rot = 2;
	    break;
	case 'z':
	    int[][][] z = { { { 0, 0, 0, 0 }, 
			      { 0, 5, 5, 0 },
			      { 0, 0, 5, 5 },
			      { 0, 0, 0, 0 } },
			    { { 0, 0, 0, 5 }, 
			      { 0, 0, 5, 5 },
			      { 0, 0, 5, 0 },
			      { 0, 0, 0, 0 } } };
	    data = z;
	    max_rot = 2;
	    break;
	case 'l':
	    int[][][] l = { { { 0, 0, 0, 0 }, 
			      { 0, 7, 7, 7 },
			      { 0, 7, 0, 0 },
			      { 0, 0, 0, 0 } },
			    { { 0, 0, 7, 0 }, 
			      { 0, 0, 7, 0 },
			      { 0, 0, 7, 7 },
			      { 0, 0, 0, 0 } },
			    { { 0, 0, 0, 7 }, 
			      { 0, 7, 7, 7 },
			      { 0, 0, 0, 0 },
			      { 0, 0, 0, 0 } },
			    { { 0, 7, 7, 0 }, 
			      { 0, 0, 7, 0 },
			      { 0, 0, 7, 0 },
			      { 0, 0, 0, 0 } } };
	    data = l;
	    max_rot = 4;
	    break;
	case 'j':
	    int[][][] j = { { { 0, 0, 0, 0 }, 
			      { 0, 6, 6, 6 },
			      { 0, 0, 0, 6 },
			      { 0, 0, 0, 0 } },
			    { { 0, 0, 6, 6 }, 
			      { 0, 0, 6, 0 },
			      { 0, 0, 6, 0 },
			      { 0, 0, 0, 0 } },
			    { { 0, 6, 0, 0 }, 
			      { 0, 6, 6, 6 },
			      { 0, 0, 0, 0 },
			      { 0, 0, 0, 0 } },
			    { { 0, 0, 6, 0 }, 
			      { 0, 0, 6, 0 },
			      { 0, 6, 6, 0 },
			      { 0, 0, 0, 0 } } };
	    data = j;
	    max_rot = 4;
	    break;
	case 't':
	    int[][][] t = { { { 0, 0, 0, 0 }, 
			      { 0, 3, 3, 3 },
			      { 0, 0, 3, 0 },
			      { 0, 0, 0, 0 } },
			    { { 0, 0, 3, 0 }, 
			      { 0, 0, 3, 3 },
			      { 0, 0, 3, 0 },
			      { 0, 0, 0, 0 } },
			    { { 0, 0, 3, 0 }, 
			      { 0, 3, 3, 3 },
			      { 0, 0, 0, 0 },
			      { 0, 0, 0, 0 } },
			    { { 0, 0, 3, 0 }, 
			      { 0, 3, 3, 0 },
			      { 0, 0, 3, 0 },
			      { 0, 0, 0, 0 } } };
	    data = t;
	    max_rot = 4;
	    break;
	}
    }
}

class Player{
    // values & info
    int level;
    int lines;
    int score;
    
    // pieces & positions
    Piece cur;
    Piece next;
    int piece_x, piece_y; // where on game_grid
    
    // panels
    PGraphics panel;
    PGraphics next_piece;

    Player(){
	level = 0;
	lines = 0;
	score = 0;
	
	panel = createGraphics(256,256);
	//next_piece = createGraphics(256,256);
	
	// assign pieces & location
	next = new Piece(possible_pieces[(int) random(7)]);
	cur = new Piece(possible_pieces[(int) random(7)]);
	piece_x = 3;
	piece_y = 0;
    }
    
    public void draw_panel(){
	panel.clear();
	panel.beginDraw();

	panel.textAlign(LEFT, TOP);
	panel.textSize(30);
	
	panel.text("LEVEL: " + level, 0, 0);
	panel.text("LINES: " + lines, 0, 40);
	panel.text("SCORE: " + score, 0, 80);

	panel.endDraw();
    }
}
// squaretris constants!!!

// atomic constants (less important & mainly visual)
final int SCREEN_W = 800;
final int SCREEN_H = 600;
final int SPACING = 50;

// atomic constants (important & affect gameplay)
final int GRID_W = 10;
final int GRID_H = 22; // only displaying 20!

// compound constants (magic)
final int GRID_SIZE = (SCREEN_H - SPACING*2)/GRID_H;
final float P1_PANEL_X = (2*SPACING) + GRID_SIZE*GRID_W;
final float P1_PANEL_Y = SCREEN_H*((float) 2/3);

// colors
int CYAN = color(200,255,255);
int YELLOW = color(255,255,200);
int PURPLE = color(235,200,255);
int GREEN = color(215,255,200);
int RED = color(255,200,200);
int BLUE = color(200,200,255);
int ORANGE = color(255,210,150);

// pieces
final char[] possible_pieces = {'o','i','s','z','l','j','t'};
public void keyPressed(){
    if (key == CODED) {
	// player 2 arrows
	switch (keyCode) {
	case UP:
	    break;
	case DOWN:
	    break;
	case LEFT:
	    break;
	case RIGHT:
	    break;
	}
    }
    switch (key) {
	// start & select
    case ' ':
	// start
	break;
    case ENTER:
    case RETURN:
	// select
	break;
	// player 1 buttons
    case 'r':
	rotatePiece('l');
	break;
    case 't':
	rotatePiece('r');
	break;
    case 'f':
	dropPiece();
	break;
    case 'g':
	// p1.level += 1; DEBUG
	if (game_state == 2) {
	    exit();
	}
	break;
	// player 1 arrows
    case 'w': // up
	// movePiece('u'); DEBUG
	dropPiece();
	break;
    case 's': // down
	movePiece('d');
	break;
    case 'a': // left
	movePiece('l');
	break;
    case 'd': // right
	movePiece('r');
	break;
	// player 2 buttons
    case 'o':
	break;
    case 'p':
	break;
    case 'k':
	break;
    case 'l':
	break;
    }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "squaretris" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
