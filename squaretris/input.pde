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


void keyPressed(){
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