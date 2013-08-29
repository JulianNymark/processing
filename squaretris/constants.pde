// squaretris constants!!!

// atomic constants (less important & mainly visual)
final int SCREEN_W = 800;
final int SCREEN_H = 600;
final int SPACING = 50;

// atomic constants (important & affect gameplay)
final int GRID_W = 10; // game grid block count (width)
final int GRID_H = 22; // game grid block count (height) top 2 rows not drawn!

// for some reason, enums don't work in processing? D:
final int STATE_MAIN_MENU = 0;
final int STATE_GAME = 1;
final int STATE_GAME_OVER = 2;

// compound constants (magic)
final int GRID_SIZE = (SCREEN_H - SPACING*2)/GRID_H;
final float P1_PANEL_X = (2*SPACING) + GRID_SIZE*GRID_W;
final float P1_PANEL_Y = SCREEN_H*((float) 2/3);
final float P1_NEXT_PANEL_X = P1_PANEL_X;
final float P1_NEXT_PANEL_Y = SCREEN_H*((float) 1/3);

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
