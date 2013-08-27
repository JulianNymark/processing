void keyPressed(){
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
