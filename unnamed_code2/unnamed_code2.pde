int grid_x, grid_y, mine_count, game_state;
float bx, by, bw, bh;
float square_size;
Square[][] squares;

PImage bomb;

// run once!
void setup(){
    size(800, 600);

    // game over button
    bx = width/2;
    by = height * ((float) 7/8);
    bw = (float) width/1.75;
    bh = height/5;

    initialize();
}

void initialize(){
    grid_x = 30;
    grid_y = 16;
    mine_count = 99;

    squares = new Square[grid_x][grid_y];

    square_size = width/ (float) max(grid_x, grid_y);

    for(int y=0; y<grid_y; ++y){
        for(int x=0; x<grid_x; ++x) {
            squares[x][y] = new Square(x*square_size, y*square_size);
        }
    }

    bomb = loadImage("bomb.png");

    assign_mines();
    calculate_proximity();

    game_state = 0; // 0 start, 1 game_over
}

// draw = loop's inf.
void draw(){
    rectMode(CORNER);
    background(100);
    for(int y=0; y<grid_y; ++y){
        for(int x=0; x<grid_x; ++x){
            squares[x][y].draw();
        }
    }

    if(game_state == 1){
        stroke(3);

        if(abs(bx - mouseX) < bw/2 &&
           abs(by - mouseY) < bh/2) {
            fill(0);
            rectMode(CENTER);
            rect(bx, by, bw, bh);
            fill(255);
            textAlign(CENTER, CENTER);
            textSize(bh - 3);
            text("Restart!", bx, by*0.95);
        }
        else{
            fill(255);
            rectMode(CENTER);
            rect(bx, by, bw, bh);
            fill(0);
            textAlign(CENTER, CENTER);
            textSize(bh - 3);
            text("Restart!", bx, by*0.95);
       } 
    }
}

class Square{
    PVector draw_loc;
    int number;
    int status;

    Square(float x, float y){
        draw_loc = new PVector(x, y);
        status = 0; // 0 not revealed, 1 revealed
        number = 0; // 0 blank, -1 mine, 1..8 mine proximity
    }

    // mouse "bounding box" collision trigger
    void draw(){
        noStroke();
        boolean mouse_on_square = mouseX >= draw_loc.x &&
            mouseX < draw_loc.x + square_size &&
            mouseY >= draw_loc.y &&
            mouseY < draw_loc.y + square_size;

        if(status == 0){
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
        else {
            draw_square('r');
        }
    }

    private void draw_square(char state){
        switch(state){
        case 'l':
            // draw 2 triangles behind each square (the shading)
            fill(80);
            triangle(draw_loc.x, draw_loc.y,
                     draw_loc.x, draw_loc.y + square_size,
                     draw_loc.x + square_size, draw_loc.y);
            fill(200);
            triangle(draw_loc.x + square_size, draw_loc.y + square_size,
                     draw_loc.x, draw_loc.y + square_size,
                     draw_loc.x + square_size, draw_loc.y);
            // draw rect surface (button surface!)
            fill(150);
            rect(draw_loc.x + 3, draw_loc.y + 3, square_size-6, square_size -6);
            break;
        case 'd':
            // draw 2 triangles behind each square (the shading)
            fill(255);
            triangle(draw_loc.x, draw_loc.y,
                     draw_loc.x, draw_loc.y + square_size,
                     draw_loc.x + square_size, draw_loc.y);
            fill(80);
            triangle(draw_loc.x + square_size, draw_loc.y + square_size,
                     draw_loc.x, draw_loc.y + square_size,
                     draw_loc.x + square_size, draw_loc.y);
            // draw rect surface (button surface!)
            fill(240);
            rect(draw_loc.x + 3, draw_loc.y + 3, square_size-6, square_size -6);
            break;
        case 'r':
            // draw a rect (border)
            fill(100);
            rect(draw_loc.x, draw_loc.y, square_size, square_size);
            // draw rect surface (button surface!)
            fill(200);
            rect(draw_loc.x + 1, draw_loc.y + 1, square_size-2, square_size -2);
            // draw number (or bomb texture if -1)
            textSize(grid_x-5);
            textAlign(LEFT, TOP);
            if(number > 0){
                fill(0);
                text(number, draw_loc.x, draw_loc.y);
            }
            if(number == -2){
                fill(255,0,0);
                rect(draw_loc.x + 1, draw_loc.y + 1, square_size-2, square_size -2);
            }
            if(number < 0){
                image(bomb, draw_loc.x, draw_loc.y, square_size, square_size);
            }
            break;
        default:
            // draw 2 triangles behind each square (the shading)
            fill(255);
            triangle(draw_loc.x, draw_loc.y,
                     draw_loc.x, draw_loc.y + square_size,
                     draw_loc.x + square_size, draw_loc.y);
            fill(80);
            triangle(draw_loc.x + square_size, draw_loc.y + square_size,
                     draw_loc.x, draw_loc.y + square_size,
                     draw_loc.x + square_size, draw_loc.y);
            // draw rect surface (button surface!)
            fill(200);
            rect(draw_loc.x + 3, draw_loc.y + 3, square_size-6, square_size -6);
            break;
        }
    }
}

void assign_mines(){
    int i = mine_count;

    while(i > 0){
        int g_x = (int) random(grid_x);
        int g_y = (int) random(grid_y);
        if(squares[g_x][g_y].number != -1){
            squares[g_x][g_y].number = -1;
            --i;
        }
    }
}

void mouseReleased(){
    int m_x = mouseX;
    int m_y = mouseY;

    if(game_state == 0){
        for(int y=0; y<grid_y; ++y){
            for(int x=0; x<grid_x; ++x){
                Square s = squares[x][y];
                boolean mouse_on_square = mouseX >= s.draw_loc.x &&
                    mouseX < s.draw_loc.x + square_size &&
                    mouseY >= s.draw_loc.y &&
                    mouseY < s.draw_loc.y + square_size;

                if(mouse_on_square){
                    reveal_square(x, y);
                }
            }
        }
    }
}

void calculate_proximity(){
    for(int y=0; y<grid_y; ++y){
        for(int x=0; x<grid_x; ++x){
            // at each mine, add 1 to each neighbor
            if(squares[x][y].number == -1){
                int proximity_count = 0;
                for(int x1= -1; x1<2; ++x1){
                    for(int y1= -1; y1<2; ++y1){
                        // don't touch self... or step outside grid...
                        if(!(x1 == 0 && y1 == 0) &&
                           !(x + x1 < 0) && !(x + x1 >= grid_x) &&
                           !(y + y1 < 0) && !(y + y1 >= grid_y) ){
                            if(squares[x + x1][y + y1].number != -1){
                                squares[x + x1][y + y1].number += 1;
                            }
                        }
                    }
                }
            }
        }
    }
}

// recursive!
void reveal_all_neighbors(int x, int y){
    for(int x1= -1; x1<2; ++x1){
        for(int y1= -1; y1<2; ++y1){
            // don't step outside grid...
            if(!(x + x1 < 0) && !(x + x1 >= grid_x) &&
               !(y + y1 < 0) && !(y + y1 >= grid_y) ) {
                if(squares[x + x1][y + y1].number == 0 &&
                   squares[x + x1][y + y1].status != 1){
                    // recursion!
                    squares[x + x1][y + y1].status = 1;
                    if(squares[x + x1][y + y1].number == -1){
                        squares[x + x1][y + y1].number = -2;
                        game_over();
                    }
                    reveal_all_neighbors(x + x1, y + y1);
                }
                squares[x + x1][y + y1].status = 1;
                if(squares[x + x1][y + y1].number == -1){
                    squares[x + x1][y + y1].number = -2;
                    game_over();
                }
            }
        }
    }
}

void reveal_square(int x, int y){
    squares[x][y].status = 1;

    // if bomb = lose, huehuehue
    if(squares[x][y].number == -1){
        squares[x][y].number = -2; // triggered bomb!
        game_over();
    }

    // if blank, reveal all neighbors
    if(squares[x][y].number == 0){
        reveal_all_neighbors(x, y);
    }
}

void mousePressed(){
    int m_x = mouseX;
    int m_y = mouseY;

    if(game_state == 0 && mouseButton == RIGHT){
        for(int y=0; y<grid_y; ++y){
            for(int x=0; x<grid_x; ++x){
                Square s = squares[x][y];
                boolean mouse_on_square = mouseX >= s.draw_loc.x &&
                    mouseX < s.draw_loc.x + square_size &&
                    mouseY >= s.draw_loc.y &&
                    mouseY < s.draw_loc.y + square_size;

                if(mouse_on_square){
                    squares[x][y].status = 1;
                    reveal_all_neighbors(x, y);
                }
            }
        }
    }

    if(game_state == 1 && mouseButton == LEFT){
        if(abs(bx - mouseX) < bw/2 &&
           abs(by - mouseY) < bh/2) {
            initialize();
        }
    }
}

void game_over(){
    for(int y=0; y<grid_y; ++y){
        for(int x=0; x<grid_x; ++x){
            if(squares[x][y].number == -1){
                squares[x][y].status = 1;
	    }
	}
    }
    game_state = 1;
}
