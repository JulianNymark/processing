GameGrid game_grid;

Player p1;
Player p2;

int game_state; // 0 = main_menu, 1 = game, 2 = game_over
boolean init_state; // set when changing state!

void setup(){
    size(SCREEN_W,SCREEN_H);
  
    game_grid = new GameGrid();
    
    setGameState(STATE_MAIN_MENU);

    // init players
    p1 = new Player();
    //p2 = new Player();

    // draw starting piece
    addPiece();
}

void draw(){
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
void update(){
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

void movePiece(char dir){
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

void rotatePiece(char dir){
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

void addPiece(){
    for (int x=0; x<4; ++x) {
	for (int y=0; y<4; ++y) {
	    int block = p1.cur.data[p1.cur.rot][x][y];
	    if ( block > 0) {
		game_grid.grid[p1.piece_x + x][p1.piece_y + y] = block;
	    }
	}
    }
}

void removePiece(){
    for (int x=0; x<4; ++x) {
	for (int y=0; y<4; ++y) {
	    int block = p1.cur.data[p1.cur.rot][x][y];
	    if ( block > 0) {
		game_grid.grid[p1.piece_x + x][p1.piece_y + y] = 0;
	    }
	}
    }
}

void gameOver(){
    setGameState(STATE_GAME_OVER);
    
    // TODO submit highscore??
    System.out.printf("%d 0%n", p1.score*p1.level);
}

boolean checkCollision(){
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


void landedPiece(){
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

void scoreCalc(int lines_done){
    if (lines_done > 0) {
	// lines & score ++
	p1.score += (lines_done * lines_done);
	p1.lines += lines_done;
	if (p1.lines > p1.level*10) {
	    p1.level += 1;
	}
    }
}

void dropPiece(){
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

void newPiece(){
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

void setGameState(int i){
    init_state = true;
    game_state = i;
}

// draw a given shape at given coordinates
void drawPiece(Piece p, int loc_x, int loc_y){
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

void setFillBlock(int color_int){
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