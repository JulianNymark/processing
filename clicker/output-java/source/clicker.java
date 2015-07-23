import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class clicker extends PApplet {

double ticks_per_second;
double per_click;
double buffer;

float dt;

long current_amount;

public void setup(){
    size(800, 600);
    
    // initialzing values
    buffer = 0;
    current_amount = 0;
    ticks_per_second = 0;
    per_click = 1;
    fc_list = new ArrayList<FancyClick>();

    thread("ticker_update");

    dt = 0;
}

public void draw(){
    dt = 1/frameRate;
    background(0);
    
    fill(255);
    
    // draw current_amount
    textAlign(CENTER, CENTER);
    textSize(100);
    text("" + current_amount, width/2, height/2);
    textSize(30);
    text("( " + String.format("%.1f", ticks_per_second) + " )", width/2, (height/2) + 75);

    // draw fps counter
    textAlign(LEFT, TOP);
    textSize(20);
    text("FPS: " + String.format("%2d", PApplet.parseInt(frameRate)), 0,0);

    // draw & update fancy click
    update_fc_list();
    draw_fc_list();

    //debug fancy list length
    println("fancy_click (size): ", fc_list.size());
}

public void mousePressed(){
    if (mouseButton == RIGHT){
	ticks_per_second += 0.1f;
    }
    else {
	current_amount += per_click;
	add_fc_list(per_click);
    }
}

public void ticker_update(){
    while(true){
	float time_per_frame = dt;
	double tick_per_frame = time_per_frame * ticks_per_second;
	buffer += tick_per_frame;
	if (buffer >= 1) {
	    current_amount += (long) Math.floor(buffer);
	    buffer -= Math.floor(buffer);
	}
	
	// sleep until rougly next frame
	try{
	    Thread.sleep((long) (time_per_frame*1000));
	}
	catch(Exception e){
	    System.out.println(e.toString());
	}
    }
}

class FancyClick{
    PVector loc;
    double val;
    int alpha;
    
    FancyClick(double v, int x, int y){
	loc = new PVector(x + (randomGaussian()*10), 
			  y + (randomGaussian()*10));
	val = v;
	alpha = 255;
    }
}

ArrayList<FancyClick> fc_list;

public void draw_fc_list(){
    textAlign(CENTER, CENTER);
    textSize(20);
    for (FancyClick fc : fc_list){
	fill(255,255,255, fc.alpha);
	text("+" + fc.val, fc.loc.x, fc.loc.y);
    }
}

public void update_fc_list(){
    for (int i = 0; i < fc_list.size(); ++i) {
	FancyClick fc = fc_list.get(i);
	fc.alpha -= 255*(dt)/2;
	if (fc.alpha <= 0) {
	    fc_list.remove(i);
	}
    }
}

public void add_fc_list(double val){
    FancyClick fc = new FancyClick(val, mouseX, mouseY);
    fc_list.add(fc);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "clicker" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
