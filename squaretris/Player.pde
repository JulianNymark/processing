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
}