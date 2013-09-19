float r, g, b;
int r_dir, g_dir, b_dir;
float r_vel, g_vel, b_vel;

int menu_selection;
int menu_selections;

int time_rot_piece;
int time_new_piece;

Piece menu_piece;

void initMainMenu(){
    menu_selection = 0; // 
    menu_selections = 3; // number of menu items (1 player, 2..., exit...)
    
    time_rot_piece = 0;
    time_new_piece = 0;
    menu_piece = new Piece(possible_pieces[(int) random(7)]);

    r = random(255);
    g = random(255);
    b = random(255);
    
    int[] dirs = {-1, 1};
    r_dir = dirs[int(random(2))];
    g_dir = dirs[int(random(2))];
    b_dir = dirs[int(random(2))];

    r_vel = random(1, 2);
    g_vel = random(1, 2);
    b_vel = random(1, 2);
}

void drawMainMenu(){
    if (init_state) {
		initMainMenu();
		init_state = false;
    }
    
    // draw color shifting bg
    drawColorBG();
    
    // menu selection text
    String[] menu_text = { "1 Player", "2 Player", "Exit" };
    textAlign(LEFT, CENTER);
    fill(255-r,255-g,255-b);
    int t_size = SCREEN_H/(menu_text.length*4);
    int t_x = SCREEN_W/3;
    int t_y = SCREEN_H/3;
    
    //line(SCREEN_W/2, 0, SCREEN_W/2, SCREEN_H);
    textSize(t_size);

    for (int i=0; i<menu_text.length; ++i) {
		if (menu_selection == i) {
			text(menu_text[i], t_x + (GRID_SIZE*2), t_y+i*t_size);
		}
		else {
			text(menu_text[i], t_x, t_y+i*t_size);
		}
    }

    // draw spinning piece as menu selector!
    int now = millis();
    
    if((now - time_rot_piece) > 150){
		menu_piece.rot = (menu_piece.rot + 1) % menu_piece.max_rot;
		time_rot_piece = now;
    }

    if((now - time_new_piece) > 1000){
		menu_piece = new Piece(possible_pieces[(int) random(7)]);
		time_new_piece = now;
    }
    
    drawPiece(menu_piece, t_x-(2*GRID_SIZE),
			  (t_y+menu_selection*t_size)-(2*GRID_SIZE));
}

void inputMainMenu(){
    if (key == CODED) {
		// arrow keys are coded keys (CODED)
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
    case P1_ROTATE_RIGHT:
    case P1_DROP:
    case P1_EXTRA_BUTTON:
		switch(menu_selection){
		case 0:
			// start the game!
			thread("update"); // start the physics & update thread
			setGameState(STATE_GAME);
			break;
		case 1:
			thread("update");
			thread("update2");
			setGameState(STATE_GAME);
			break;
		case 2:
			exit();
			break;
		}
		break;
    case P1_UP:
		menu_selection += 1;
		if(menu_selection > menu_selections-1){
			menu_selection = 0;
		}
		break;
    case P1_DOWN:
		menu_selection -= 1;
		if(menu_selection < 0){
			menu_selection = menu_selections-1;
		}
		break;
    case P1_LEFT:
		break;
    case P1_RIGHT:
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

void drawColorBG(){
    r += r_vel*r_dir;
    if(r >= 255 || r <= 0){
		r_dir *= (-1);
		r += r_vel*r_dir;
    }
    g += g_vel*g_dir;
    if(g >= 255 || g <= 0){
		g_dir *= -1;
		g += g_vel*g_dir;
    }
    b += b_vel*b_dir;
    if(b >= 255 || b <= 0){
		b_dir *= -1;
		b += b_vel*b_dir;
    }

    // color screen
    background( r, g, b );
}
