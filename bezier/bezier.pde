ArrayList <PVector> points;

// run once!
void setup(){
    size(800, 600);
    
    points = new ArrayList<PVector>();
}

// draw = loop's inf.
void draw(){
    background(0);
    draw_points();
    draw_bezier();
}

void mouseClicked(){
    points.add(new PVector(mouseX, mouseY));
}

void draw_points(){
    // draw points
    for (PVector v : points){
	ellipse(v.x, v.y, 10, 10);
    }
}

void draw_bezier(){
    // sampling scalar (100 points along the bezier curve)
    stroke(255);
    for(float i=0; i<1; i += 0.01){
	line_vector(bez_calc(i), bez_calc(i+0.01));
    }
}

PVector bez_calc(float s){
    if(points.isEmpty()){
	return null;
    }
    
    ArrayList <ArrayList <PVector>> temp_list = 
	new ArrayList <ArrayList <PVector>>();

    // if empty, create first list from points
    if (temp_list.isEmpty()){
	ArrayList <PVector> al = new ArrayList<PVector>(points);
	temp_list.add(al); // add first list
    }
    
    // having added the first, we now add the rest
    // per element in points, create new lists (one element smaller per list)
    for(int i1=0; i1<points.size() -1; ++i1){
	ArrayList <PVector> al_prev = temp_list.get(i1);
	ArrayList <PVector> al = new ArrayList<PVector>();
	
	for(int i2=0; i2<al_prev.size()-1; ++i2){
	    PVector pv = al_prev.get(i2+1).get();
	    pv.sub(al_prev.get(i2));
	    pv.mult(s);
	    pv.add(al_prev.get(i2));
	    al.add(pv);
	}
	temp_list.add(al);
    }
    // return last list's first (and only) PVector
    ArrayList <PVector> get_last = temp_list.get(temp_list.size() - 1);
    PVector return_me = get_last.get(0);
    return return_me;
}

void line_vector(PVector one, PVector two){
    if (one != null && two != null){
	line(one.x, one.y, two.x, two.y);
    }
}
