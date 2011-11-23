static class GravityCalc {
  /*just returns force acting on either one of the masses given
    the force direction is just reversed for the other mass*/
  static PVector gravForce (Mass m1, Mass m2) {
    PVector force = new PVector((m1.location.x - m2.location.x), (m1.location.y - m2.location.y));
    float forceChange = Settings.GravitationalConstant*((m1.mass*m2.mass)/sq(m1.location.dist(m2.location)));
    force.mult(forceChange);
    return force;
  }
}
