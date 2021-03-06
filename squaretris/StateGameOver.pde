PGraphics score_summary;

void initGameOver(){
    
}

void drawGameOver(){
    if (init_state) {
	initGameOver();
	init_state = false;
    }

    // DEBUG print random junk
    // for (int x=0; x<GRID_W; ++x){
    // 	for (int y=0; y<GRID_H; ++y){
    // 	    game_grid.grid[x][y] = (int) random(9);
    // 	}
    // }
	
    // print game over
    textAlign(CENTER);
    textSize(SCREEN_H/10);
    text("GAME OVER", random(SCREEN_W), random(SCREEN_H));
	
    // score summary box
    draw_summary();
    image(score_summary, SCREEN_W/4, SCREEN_H/4);
	
    // some sleeping
    try{
	Thread.sleep(1500);
    }
    catch (Exception e){
	System.out.println(e.toString());
    }
}

void inputGameOver(){
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
	break;
    case P1_ROTATE_RIGHT:
	break;
    case P1_DROP:
	break;
    case P1_EXTRA_BUTTON:
	exit();
	break;
    case P1_UP:
	break;
    case P1_DOWN:
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

void draw_summary(){
    score_summary = createGraphics(SCREEN_W/2, SCREEN_H/2);
    
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
    score_summary.text("FINAL SCORE: " + p1.score*(p1.level), 0, 90);
    score_summary.textAlign(RIGHT, BOTTOM);
    score_summary.text("press green to exit!", SCREEN_W/2, SCREEN_H/2);
    score_summary.endDraw();
}