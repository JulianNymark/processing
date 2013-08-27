// squaretris constants!!!

// atomic constants (less important & mainly visual)
final int SCREEN_W = 800;
final int SCREEN_H = 600;
final int SPACING = 50;

// atomic constants (important & affect gameplay)
final int GRID_W = 10;
final int GRID_H = 22; // only displaying 20!

// compound constants (magic)
final int GRID_SIZE = (SCREEN_H - SPACING*2)/GRID_H;
final float P1_PANEL_X = (2*SPACING) + GRID_SIZE*GRID_W;
final float P1_PANEL_Y = SCREEN_H*((float) 2/3);

// colors
color CYAN = color(200,255,255);
color YELLOW = color(255,255,200);
color PURPLE = color(235,200,255);
color GREEN = color(215,255,200);
color RED = color(255,200,200);
color BLUE = color(200,200,255);
color ORANGE = color(255,210,150);

// pieces
final char[] possible_pieces = {'o','i','s','z','l','j','t'};
