double ticks_per_second;
double per_click;
double buffer;

long current_amount;

void setup(){
    size(800, 600);
    
    // initialzing values
    buffer = 0;
    current_amount = 0;
    ticks_per_second = 0;
    per_click = 1;
    fc_list = new ArrayList<FancyClick>();

    thread("ticker_update");
}

void draw(){
    background(0);
    fill(255);

    // draw fps counter
    textAlign(LEFT, TOP);
    textSize(20);
    text("FPS: " + frameRate, 0,0);
    
    // draw current_amount
    textAlign(CENTER, CENTER);
    textSize(100);
    text("" + current_amount, width/2, height/2);
    textSize(30);
    text("( " + String.format("%.1f", ticks_per_second) + " )", width/2, (height/2) + 75);

    // draw & update fancy click
    update_fc_list();
    draw_fc_list();
}

void mousePressed(){
    if (mouseButton == RIGHT){
	ticks_per_second += 0.1;
    }
    else {
	current_amount += per_click;
	add_fc_list(per_click);
    }
}

void ticker_update(){
    while(true){
	float time_per_frame = 1/frameRate;
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
	alpha = 100;
    }
}

ArrayList<FancyClick> fc_list;

void draw_fc_list(){
    textAlign(CENTER, CENTER);
    textSize(20);
    for (FancyClick fc : fc_list){
	fill(255,255,255, fc.alpha);
	text("+" + fc.val, fc.loc.x, fc.loc.y);
    }
}

void update_fc_list(){
    for (int i = 0; i < fc_list.size(); ++i) {
	FancyClick fc = fc_list.get(i);
	fc.alpha -= 255*(1/frameRate)/5;
	if (fc.alpha <= 0) {
	    fc_list.remove(i);
	}
    }
}

void add_fc_list(double val){
    FancyClick fc = new FancyClick(val, mouseX, mouseY);
    fc_list.add(fc);
}