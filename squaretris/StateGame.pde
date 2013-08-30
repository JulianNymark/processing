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
	rotatePiece('r');
	break;
    case P1_ROTATE_RIGHT:
	rotatePiece('l');
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