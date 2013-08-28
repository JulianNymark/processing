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
    
    void draw_panel(){
	panel.clear();
	panel.beginDraw();

	panel.textAlign(LEFT, TOP);
	panel.textSize(30);
	
	panel.text("LEVEL: " + level, 0, 0);
	panel.text("LINES: " + lines, 0, 40);
	panel.text("SCORE: " + score, 0, 80);

	panel.endDraw();
    }
    
    void draw_next_panel(){
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