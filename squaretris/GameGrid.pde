class GameGrid {
    PGraphics pg; // game grid's buffer
    int[][] grid;
  
    GameGrid(){
	grid = new int[GRID_W][GRID_H];
	pg = createGraphics((GRID_W*GRID_SIZE) + 1,
			    ((GRID_H-2)*GRID_SIZE) + 1);
    }
  
    // draws grid to grids buffer
    public void draw(){
	pg.beginDraw();
	pg.background(0);
	pg.noStroke();
	pg.fill(255);
	
	int rect_size = GRID_SIZE -1;
    
	for (int x=0; x<GRID_W; ++x){
	    for (int y=2; y<GRID_H; ++y){
		switch (grid[x][y]){
		case 0:
		    pg.noFill();
		    break;
		case 1:
		    pg.fill(CYAN);
		    break;
		case 2:
		    pg.fill(YELLOW);
		    break;
		case 3:
		    pg.fill(PURPLE);
		    break;
		case 4:
		    pg.fill(GREEN);
		    break;
		case 5:
		    pg.fill(RED);
		    break;
		case 6:
		    pg.fill(BLUE);
		    break;
		case 7:
		    pg.fill(ORANGE);
		    break;
		}
		pg.rect(x*GRID_SIZE + 1,
			(y-2)*GRID_SIZE + 1, 
			rect_size, rect_size);
	    }
	}
	pg.endDraw();
    }
}
