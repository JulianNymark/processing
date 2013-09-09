int grid_x, grid_y;
float square_w;
float square_h;
Square[][] squares;

// run once!
void setup(){
    size(800, 600);
    
    
    grid_x = 10;
    grid_y = 10;
    
    squares = new Square[10][10];

    square_w = width/grid_x;
    square_h = height/grid_y;
    
    for(int y=0; y<grid_y; ++y){
	for(int x=0; x<grid_x; ++x){
	    squares[x][y] = new Square(x*square_w, y*square_h);
	}
    }
}

// draw = loop's inf.
void draw(){
    background(0);
    for(int y=0; y<grid_y; ++y){
	for(int x=0; x<grid_x; ++x){
	    squares[x][y].draw();
	}
    }
}

class Square{
    PVector draw_loc;
    
    Square(float x, float y){
	draw_loc = new PVector(x, y);
    }

    // mouse "bounding box" collision trigger
    void draw(){
	if(mouseX >= draw_loc.x && mouseX < draw_loc.x + square_w &&
	   mouseY >= draw_loc.y && mouseY < draw_loc.y + square_h ){
	    fill(255);
	}
	else {
	    fill(0);
	}
	rect(draw_loc.x, draw_loc.y, square_w, square_h);
    }
}