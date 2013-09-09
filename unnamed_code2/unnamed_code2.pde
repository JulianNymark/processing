int grid_x, grid_y;
float square_w;
float square_h;
Square[][] squares;

// run once!
void setup(){
    size(800, 600);
    
    
    grid_x = 30;
    grid_y = 16;
    
    squares = new Square[grid_x][grid_y];

    square_w = width/ (float) grid_x;
    square_h = height/ (float) grid_y;
    
    for(int y=0; y<grid_y; ++y){
	for(int x=0; x<grid_x; ++x){
	    squares[x][y] = new Square(x*square_w, y*square_h);
	}
    }
    
}

// draw = loop's inf.
void draw(){
    background(100);
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
	noStroke();
	boolean mouse_on_square = mouseX >= draw_loc.x && 
	    mouseX < draw_loc.x + square_w &&
	    mouseY >= draw_loc.y && 
	    mouseY < draw_loc.y + square_h;
	
	if(mouse_on_square){
	    if(mousePressed){
		draw_square('l');
	    }
	    else{
		draw_square('d');
	    }
	}
	else {
	    draw_square('x');
	}
    }

    private void draw_square(char state){
	switch(state){
	case 'l':
	    // draw 2 triangles behind each square (the shading)
	    fill(80);
	    triangle(draw_loc.x, draw_loc.y,
		     draw_loc.x, draw_loc.y + square_h,
		     draw_loc.x + square_w, draw_loc.y);
	    fill(200);
	    triangle(draw_loc.x + square_w, draw_loc.y + square_h, 
		     draw_loc.x, draw_loc.y + square_h,
		     draw_loc.x + square_w, draw_loc.y);
	    // draw rect surface (button surface!)
	    fill(150);
	    rect(draw_loc.x + 3, draw_loc.y + 3, square_w-6, square_h -6);
	    break;
	case 'd':	
	    // draw 2 triangles behind each square (the shading)
	    fill(255);
	    triangle(draw_loc.x, draw_loc.y, 
		     draw_loc.x, draw_loc.y + square_h,
		     draw_loc.x + square_w, draw_loc.y);
	    fill(80);
	    triangle(draw_loc.x + square_w, draw_loc.y + square_h, 
		     draw_loc.x, draw_loc.y + square_h,
		     draw_loc.x + square_w, draw_loc.y);
	    // draw rect surface (button surface!)
	    fill(240);
	    rect(draw_loc.x + 3, draw_loc.y + 3, square_w-6, square_h -6);
	    break;
	default:
	    // draw 2 triangles behind each square (the shading)
	    fill(255);
	    triangle(draw_loc.x, draw_loc.y, 
		     draw_loc.x, draw_loc.y + square_h,
		     draw_loc.x + square_w, draw_loc.y);
	    fill(80);
	    triangle(draw_loc.x + square_w, draw_loc.y + square_h, 
		     draw_loc.x, draw_loc.y + square_h,
		     draw_loc.x + square_w, draw_loc.y);
	    // draw rect surface (button surface!)
	    fill(200);
	    rect(draw_loc.x + 3, draw_loc.y + 3, square_w-6, square_h -6);
	    break;
	}
    }
}