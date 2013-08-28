void initGame(){
    fill(255);
    textSize(20);
}

void drawGame(){
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
    text("FPS: " + int(frameRate), 10, 20);

    // draw player 1 info panel
    p1.draw_panel();
    image(p1.panel, P1_PANEL_X, P1_PANEL_Y);
    
    // draw next piece
    p1.draw_next_panel();
    image(p1.next_panel, P1_NEXT_PANEL_X, P1_NEXT_PANEL_Y);
}

void inputGame(){
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