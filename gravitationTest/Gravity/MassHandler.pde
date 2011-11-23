class MassHandler {
  Settings s = new Settings();
  
  ArrayList<Mass> masses = new ArrayList<Mass>();
  
  MassHandler(Settings s) {
    this.s = s;
  }
  
  void addMass(Mass m) {
    masses.add(m);
  }

  void update() {
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

