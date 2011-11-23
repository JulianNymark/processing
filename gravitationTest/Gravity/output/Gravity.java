import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class Gravity extends PApplet {

Settings s = new Settings();
MassHandler mh = new MassHandler(s);
MouseDrag md = new MouseDrag(mh);

public void setup() {
  size(1280, 800);
  frameRate(60);
  //see Settings for the actual settings
}

public void draw() {
    //background(105);
  md.update();
  mh.update();
}

static class CollisionCalc {
  public static PVector collision(){
    PVector c = new PVector(0,0);
    return c;
    //Needs work! :D
  }
}
static class GravityCalc {
  /*just returns force acting on either one of the masses given
    the force direction is just reversed for the other mass*/
  public static PVector gravForce (Mass m1, Mass m2) {
    PVector force = new PVector((m1.location.x - m2.location.x), (m1.location.y - m2.location.y));
    float forceChange = Settings.GravitationalConstant*((m1.mass*m2.mass)/sq(m1.location.dist(m2.location)));
    force.mult(forceChange);
    return force;
  }
}
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
  
  public void update(PVector force) {
    velocity.add(force);
    location.add(velocity);
  }
  
  public void render(){
    ellipseMode(CENTER);
    fill(255);
    ellipse(location.x, location.y,r,r);
  }
}

class MassHandler {
  Settings s = new Settings();
  
  ArrayList<Mass> masses = new ArrayList<Mass>();
  
  MassHandler(Settings s) {
    this.s = s;
  }
  
  public void addMass(Mass m) {
    masses.add(m);
  }

  public void update() {
    if (!s.gravity){
      s.GravitationalConstant = 0;
    }
    //update vectors
    for (int x=0; x<masses.size(); ++x) {
      //when only 1 mass
      if(masses.size() == 1){
        Mass m1 = masses.get(x);
        PVector noForce = new PVector(0,0);
        m1.update(noForce);
      }
      //for more than 1
      for (int y=x+1; y<masses.size(); ++y) {
        Mass m1 = masses.get(x);
        Mass m2 = masses.get(y);
        PVector f = GravityCalc.gravForce(m1, m2);
        m2.update(f);
        f.mult(-1); //equal and OPPOSITE  
        m1.update(f);
      }
    }
    //render the masses
    for (int x = 0; x < masses.size(); ++x) {
      Mass m = masses.get(x);
      m.render();
    }
  }
}

/**
 MouseDrag is the method of creating / launching masses
 - clicking M1 results in a mass created
 - dragging will draw a line that gives the velocity of the mass
 */

class MouseDrag {
  MassHandler mh;
  boolean pressed;
  int x, y;

  MouseDrag (MassHandler mh) {
    this.mh = mh;
  }

  public void update() {
    if (mousePressed && (!pressed)) {
      pressed = true;
      x = mouseX;
      y = mouseY;
    }
    if (pressed && !(mousePressed)) {
      pressed = false;
      //launch mass here!
      PVector massLoc = new PVector(x, y);
      PVector massVel = new PVector((x - mouseX), (y - mouseY));
      massVel.div(20);
      Mass m = new Mass((int)random(100, 1000), massLoc, massVel);
      mh.addMass(m);
    }

    if (pressed) {
      strokeWeight(5);
      line(x, y, mouseX, mouseY);
    }
  }
}

static class Settings {
  /*collisions not made yet!*/
  static boolean collisions = true;
  /*Gravity = false will atm force grav constant = 0
  yes, it still does all the calculations (lazy ftw) */
  static boolean gravity = true; 
  static float GravitationalConstant = 0.000001f;
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#DFDFDF", "Gravity" });
  }
}
