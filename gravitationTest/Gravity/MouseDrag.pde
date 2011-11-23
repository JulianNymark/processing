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

  void update() {
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

