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
boolean init_state; // set when changing state!

public void setup(){
    size(SCREEN_W,SCREEN_H);
  
    game_grid = new GameGrid();
    
    setGameState(STATE_MAIN_MENU);

    // init players
    p1 = new Player();
    //p2 = new Player();

    // draw starting piece
    addPiece();
}

public void draw(){
    switch (game_state) {
    case 0: // MAIN_MENU
	drawMainMenu();
	break;
    case 1: // GAME
	drawGame();
	break;
    case 2: // GAME_OVER
	drawGameOver();
	break;
    }
}

/* Infinite update loop for the game. 
 * this thread runs concurrently with that other infinite loop, draw()
 * separating the draw loop from 'game-time'
 */
public void update(){
    while (game_state == STATE_GAME) {
	// sleep game tick (based on level)
	try{
	    Thread.sleep(1000/p1.level);
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
	p1.cur.rot = (p1.cur.rot + 1) % p1.cur.max_rot;
	if (checkCollision()) {
	    if (p1.cur.rot == 0){
		p1.cur.rot = p1.cur.max_rot - 1;
	    }
	    else {
		p1.cur.rot = p1.cur.rot - 1;
	    }
	}
	break;
    case 'r': // clockwise
	if (p1.cur.rot == 0){
	    p1.cur.rot = p1.cur.max_rot - 1;
	}
	else {
	    p1.cur.rot = p1.cur.rot - 1;
	}
	if (checkCollision()){
	    p1.cur.rot = (p1.cur.rot + 1) % p1.cur.max_rot;
	}
	break;
    }
    addPiece();
}

public void addPiece(){
    for (int x=0; x<4; ++x) {
	for (int y=0; y<4; ++y) {
	    int block = p1.cur.data[p1.cur.rot][x][y];
	    if ( block > 0) {
		game_grid.grid[p1.piece_x + x][p1.piece_y + y] = block;
	    }
	}
    }
}

public void removePiece(){
    for (int x=0; x<4; ++x) {
	for (int y=0; y<4; ++y) {
	    int block = p1.cur.data[p1.cur.rot][x][y];
	    if ( block > 0) {
		game_grid.grid[p1.piece_x + x][p1.piece_y + y] = 0;
	    }
	}
    }
}

public void gameOver(){
    setGameState(STATE_GAME_OVER);
    
    // TODO submit highscore??
    System.out.printf("%d 0%n", p1.score*p1.level);
}

public boolean checkCollision(){
    for (int x=0; x<4; ++x) {
	for (int y=0; y<4; ++y) {
	    int block = p1.cur.data[p1.cur.rot][x][y];
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
		break;
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
	    lines_done += 1;
	}
    }
    
    // score calculation
    scoreCalc(lines_done);
    
    // get new piece
    newPiece();
}

public void scoreCalc(int lines_done){
    if (lines_done > 0) {
	// lines & score ++
	p1.score += (lines_done * lines_done);
	p1.lines += lines_done;
	if (p1.lines > p1.level*10) {
	    p1.level += 1;
	}
    }
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
	return;
    }
    
    addPiece(); // draw new piece
}

public void setGameState(int i){
    init_state = true;
    game_state = i;
}

// draw a given shape at given coordinates
public void drawPiece(Piece p, int loc_x, int loc_y){
    for (int y=0; y<4; ++y){
	for (int x=0; x<4; ++x){
	    int block = p.data[p.rot][x][y];
	    if (block > 0){
		setFillBlock(block);
		rect(loc_x+(x*GRID_SIZE), loc_y+(y*GRID_SIZE), 
		     GRID_SIZE, GRID_SIZE);
	    }
	}
    }
}

public void setFillBlock(int color_int){
    switch (color_int){
    case 0:
	noFill();
	break;
    case 1:
	fill(CYAN);
	break;
    case 2:
	fill(YELLOW);
	break;
    case 3:
	fill(PURPLE);
	break;
    case 4:
	fill(GREEN);
	break;
    case 5:
	fill(RED);
	break;
    case 6:
	fill(BLUE);
	break;
    case 7:
	fill(ORANGE);
	break;
    }
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
	    rot = 0;
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
	    rot = 1;
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
	    rot = 1;
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
	    rot = 1;
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
	    rot = 3;
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
	    rot = 3;
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
	    rot = 3;
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
    PGraphics next_panel; // next piece

    Player(){
	level = 1;
	lines = 0;
	score = 0;
	
	panel = createGraphics(512,512);
	next_panel = createGraphics(512,512);
	
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
    
    public void draw_next_panel(){
	next_panel.clear();
	next_panel.beginDraw();
	
	for (int y=0; y<4; ++y){
	    for (int x=0; x<4; ++x){
		int block = next.data[next.rot][x][y];
		if (block > 0){
		    switch (block){
		    case 0:
			next_panel.noFill();
			break;
		    case 1:
			next_panel.fill(CYAN);
			break;
		    case 2:
			next_panel.fill(YELLOW);
			break;
		    case 3:
			next_panel.fill(PURPLE);
			break;
		    case 4:
			next_panel.fill(GREEN);
			break;
		    case 5:
			next_panel.fill(RED);
			break;
		    case 6:
			next_panel.fill(BLUE);
			break;
		    case 7:
			next_panel.fill(ORANGE);
			break;
		    }
		    next_panel.rect((x*GRID_SIZE), (y*GRID_SIZE), 
			 GRID_SIZE, GRID_SIZE);
		}
	    }
	}
	
	next_panel.endDraw();
    }
}
public void initGame(){
    fill(255);
    textSize(20);
}

public void drawGame(){
    if (init_state) {
	initGame();
	init_state = false;
    }

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
    
    // draw next piece
    p1.draw_next_panel();
    image(p1.next_panel, P1_NEXT_PANEL_X, P1_NEXT_PANEL_Y);
}

public void inputGame(){
    if (key == CODED) {
	// arrow keys are CODED
	switch (keyCode) {
	case P2_UP:
	    break;
	case P2_DOWN:
	    break;
	case P2_LEFT:
	    break;
	case P2_RIGHT:
	    break;
	}
    }

    switch (key) {
    case START_BUTTON:
	break;
    case ENTER:
    case SELECT_BUTTON:
	break;
    case P1_ROTATE_LEFT:
	rotatePiece('l');
	break;
    case P1_ROTATE_RIGHT:
	rotatePiece('r');
	break;
    case P1_DROP:
	dropPiece();
	break;
    case P1_EXTRA_BUTTON:
	// p1.level += 1; // DEBUG
	break;
    case P1_UP:
	// movePiece('u'); // DEBUG
	dropPiece();
	break;
    case P1_DOWN:
	movePiece('d');
	break;
    case P1_LEFT:
	movePiece('l');
	break;
    case P1_RIGHT:
	movePiece('r');
	break;
    case P2_ROTATE_LEFT:
	break;
    case P2_ROTATE_RIGHT:
	break;
    case P2_DROP:
	break;
    case P2_EXTRA_BUTTON:
	break;
    }
}
PGraphics score_summary;

public void initGameOver(){
    
}

public void drawGameOver(){
    if (init_state) {
	initGameOver();
	init_state = false;
    }

    // DEBUG print random junk
    // for (int x=0; x<GRID_W; ++x){
    // 	for (int y=0; y<GRID_H; ++y){
    // 	    game_grid.grid[x][y] = (int) random(9);
    // 	}
    // }
	
    // print game over
    textAlign(CENTER);
    textSize(SCREEN_H/10);
    text("GAME OVER", random(SCREEN_W), random(SCREEN_H));
	
    // score summary box
    draw_summary();
    image(score_summary, SCREEN_W/4, SCREEN_H/4);
	
    // some sleeping
    try{
	Thread.sleep(1500);
    }
    catch (Exception e){
	System.out.println(e.toString());
    }
}

public void inputGameOver(){
    if (key == CODED) {
	// arrow keys are CODED
	switch (keyCode) {
	case P2_UP:
	    break;
	case P2_DOWN:
	    break;
	case P2_LEFT:
	    break;
	case P2_RIGHT:
	    break;
	}
    }

    switch (key) {
    case START_BUTTON:
	break;
    case ENTER:
    case SELECT_BUTTON:
	break;
    case P1_ROTATE_LEFT:
	break;
    case P1_ROTATE_RIGHT:
	break;
    case P1_DROP:
	break;
    case P1_EXTRA_BUTTON:
	exit();
	break;
    case P1_UP:
	break;
    case P1_DOWN:
	break;
    case P1_LEFT:
	break;
    case P1_RIGHT:
	break;
    case P2_ROTATE_LEFT:
	break;
    case P2_ROTATE_RIGHT:
	break;
    case P2_DROP:
	break;
    case P2_EXTRA_BUTTON:
	break;
    }
}

public void draw_summary(){
    score_summary = createGraphics(SCREEN_W/2, SCREEN_H/2);
    
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
    score_summary.text("FINAL SCORE: " + p1.score*(p1.level), 0, 90);
    score_summary.textAlign(RIGHT, BOTTOM);
    score_summary.text("press green to exit!", SCREEN_W/2, SCREEN_H/2);
    score_summary.endDraw();
}
float r, g, b;
int r_dir, g_dir, b_dir;
float r_vel, g_vel, b_vel;

int menu_selection;
int menu_selections;

int time_rot_piece;
int time_new_piece;

Piece menu_piece;

public void initMainMenu(){
    menu_selection = 0; // 
    menu_selections = 2; // number of menu items (start game, exit...)
    
    time_rot_piece = 0;
    time_new_piece = 0;
    menu_piece = new Piece(possible_pieces[(int) random(7)]);

    r = random(255);
    g = random(255);
    b = random(255);
    
    int[] dirs = {-1, 1};
    r_dir = dirs[PApplet.parseInt(random(2))];
    g_dir = dirs[PApplet.parseInt(random(2))];
    b_dir = dirs[PApplet.parseInt(random(2))];

    r_vel = random(1, 2);
    g_vel = random(1, 2);
    b_vel = random(1, 2);
}

public void drawMainMenu(){
    if (init_state) {
	initMainMenu();
	init_state = false;
    }
    
    // draw color shifting bg
    drawColorBG();
    
    // menu selection text
    String[] menu_text = { "Start game", "Exit" };
    textAlign(LEFT, CENTER);
    fill(255-r,255-g,255-b);
    int t_size = SCREEN_H/(menu_text.length*4);
    int t_x = SCREEN_W/3;
    int t_y = SCREEN_H/3;
    
    //line(SCREEN_W/2, 0, SCREEN_W/2, SCREEN_H);
    textSize(t_size);

    for (int i=0; i<menu_text.length; ++i) {
	if (menu_selection == i) {
	    text(menu_text[i], t_x + (GRID_SIZE*2), t_y+i*t_size);
	}
	else {
	    text(menu_text[i], t_x, t_y+i*t_size);
	}
    }

    // draw spinning piece as menu selector!
    int now = millis();
    
    if((now - time_rot_piece) > 150){
	menu_piece.rot = (menu_piece.rot + 1) % menu_piece.max_rot;
	time_rot_piece = now;
    }

    if((now - time_new_piece) > 1000){
	menu_piece = new Piece(possible_pieces[(int) random(7)]);
	time_new_piece = now;
    }
    
    drawPiece(menu_piece, t_x-(2*GRID_SIZE),
	      (t_y+menu_selection*t_size)-(2*GRID_SIZE));
}

public void inputMainMenu(){
    if (key == CODED) {
	// arrow keys are coded keys (CODED)
	switch (keyCode) {
	case P2_UP:
	    break;
	case P2_DOWN:
	    break;
	case P2_LEFT:
	    break;
	case P2_RIGHT:
	    break;
	}
    }

    switch (key) {
    case START_BUTTON:
	break;
    case ENTER:
    case SELECT_BUTTON:
	break;
    case P1_ROTATE_LEFT:
    case P1_ROTATE_RIGHT:
    case P1_DROP:
    case P1_EXTRA_BUTTON:
	switch(menu_selection){
	case 0:
	    // start the game!
	    thread("update"); // start the physics & update thread
	    setGameState(STATE_GAME);
	    break;
	case 1:
	    exit();
	    break;
	}
	break;
    case P1_UP:
	menu_selection += 1;
	if(menu_selection > menu_selections-1){
	    menu_selection = 0;
	}
	break;
    case P1_DOWN:
	menu_selection -= 1;
	if(menu_selection < 0){
	    menu_selection = menu_selections-1;
	}
	break;
    case P1_LEFT:
	break;
    case P1_RIGHT:
	break;
    case P2_ROTATE_LEFT:
	break;
    case P2_ROTATE_RIGHT:
	break;
    case P2_DROP:
	break;
    case P2_EXTRA_BUTTON:
	break;
    }
}

public void drawColorBG(){
    r += r_vel*r_dir;
    if(r >= 255 || r <= 0){
	r_dir *= (-1);
	r += r_vel*r_dir;
    }
    g += g_vel*g_dir;
    if(g >= 255 || g <= 0){
	g_dir *= -1;
	g += g_vel*g_dir;
    }
    b += b_vel*b_dir;
    if(b >= 255 || b <= 0){
	b_dir *= -1;
	b += b_vel*b_dir;
    }

    // color screen
    background( r, g, b );
}
// squaretris constants!!!

// atomic constants (less important & mainly visual)
final int SCREEN_W = 800;
final int SCREEN_H = 600;
final int SPACING = 50;

// atomic constants (important & affect gameplay)
final int GRID_W = 10; // game grid block count (width)
final int GRID_H = 22; // game grid block count (height) top 2 rows not drawn!

// for some reason, enums don't work in processing? D:
final int STATE_MAIN_MENU = 0;
final int STATE_GAME = 1;
final int STATE_GAME_OVER = 2;

// compound constants (magic)
final int GRID_SIZE = (SCREEN_H - SPACING*2)/GRID_H;
final float P1_PANEL_X = (2*SPACING) + GRID_SIZE*GRID_W;
final float P1_PANEL_Y = SCREEN_H*((float) 2/3);
final float P1_NEXT_PANEL_X = P1_PANEL_X;
final float P1_NEXT_PANEL_Y = SCREEN_H*((float) 1/3);

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
// keys and controls!

// player 1
final char P1_UP = 'w';
final char P1_DOWN = 's';
final char P1_LEFT = 'a';
final char P1_RIGHT = 'd';
final char P1_ROTATE_LEFT = 'r';
final char P1_ROTATE_RIGHT = 't';
final char P1_DROP = 'f';
final char P1_EXTRA_BUTTON = 'g';

// player 2
final char P2_UP = UP; // ARROW_UP
final char P2_DOWN = DOWN; // ARROW_DOWN
final char P2_LEFT = LEFT; // ARROW_LEFT
final char P2_RIGHT = RIGHT; // ARROW_RIGHT
final char P2_ROTATE_LEFT = 'o';
final char P2_ROTATE_RIGHT = 'p';
final char P2_DROP = 'k';
final char P2_EXTRA_BUTTON = 'l';

// other buttons
final char START_BUTTON = ' ';
final char SELECT_BUTTON = RETURN;


public void keyPressed(){
    switch (game_state) {
    case STATE_MAIN_MENU:
	inputMainMenu();
	break;
    case STATE_GAME:
	inputGame();
	break;
    case STATE_GAME_OVER:
	inputGameOver();
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
