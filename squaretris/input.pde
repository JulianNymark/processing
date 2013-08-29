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
