GameGrid game_grid;

Player p1;
Player p2;

int game_state; // 0 = main_menu, 1 = game, 2 = game_over

void setup(){
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

void draw(){
    // clear screen
    background(100);
  
    // draw grid
    game_grid.draw(); // draw grid -> grid's buffer
    image(game_grid.pg, SPACING, SPACING); // draw grid's buffer
    
    // DEBUG FPS counter
    text("FPS: " + int(frameRate), 10, 20);

    // draw player 1 info panel
    p1.draw_panel();
    image(p1.panel, P1_PANEL_X, P1_PANEL_Y);
}


/* Infinite update loop for the game. 
 * this thread runs concurrently with that other infinite loop, draw()
 * separating the draw loop from 'game-time'
 */
void update(){
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

void addPiece(){
    for (int x=0; x<4; ++x) {
	for (int y=0; y<4; ++y) {
	    int block = p1.next.data[p1.next.rot][x][y];
	    if ( block > 0) {
		game_grid.grid[p1.piece_x + x][p1.piece_y + y] = block;
	    }
	}
    }
}

void removePiece(){
    for (int x=0; x<4; ++x) {
	for (int y=0; y<4; ++y) {
	    int block = p1.next.data[p1.next.rot][x][y];
	    if ( block > 0) {
		game_grid.grid[p1.piece_x + x][p1.piece_y + y] = 0;
	    }
	}
    }
}

void gameOver(){
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

boolean checkCollision(){
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
    }
    
    addPiece(); // draw new piece
}