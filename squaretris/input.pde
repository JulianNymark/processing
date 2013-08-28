void keyPressed(){
    switch (game_state) {
    case 0: // MAIN_MENU
	inputMainMenu();
	break;
    case 1: // GAME
	inputGame();
	break;
    case 2: // GAME_OVER
	inputGameOver();
	break;
    }
}
