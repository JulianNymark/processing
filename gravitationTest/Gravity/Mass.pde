class Mass {
  int mass;
  int r;
  PVector location;
  PVector velocity;
  
  Mass(int m, PVector l, PVector v){
    mass = m;
    r = m/10;
    location = l.get();
    velocity = v.get();
  }
  
  void update(PVector force) {
    velocity.add(force);
    location.add(velocity);
  }
  
  void render(){
    ellipseMode(CENTER);
    fill(255);
    ellipse(location.x, location.y,r,r);
  }
}

