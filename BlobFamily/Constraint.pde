
class Constraint
{
  Particle neighbor;
  int type;
  
  // For semi-rigid constraint
  float min; // Compressed length
  float max; // Stretched length
  float mid; // Relaxed length
  float kspring; // Spring elasticity
  
  Constraint() {}
  
  void initSemiRigid(Particle p, float mn, float mx, float m, float ks) {
    neighbor = p;
    type = 2;
    min = mn;
    max = mx;
    mid = m;
    kspring = ks;
  }

  PVector accumulateForce(Particle p) {
    PVector force = new PVector();
    switch(type) {
      case RIGID: { break; }
      case SEMI_RIGID: { force = accumulateSemiRigid(p); break; }
      default: { force.set(0.0, 0.0); }      
    }
    return force;    
  }
  
  void satisfyConstraints(Particle p) {
    switch(type) {
      case RIGID: { break; }
      case SEMI_RIGID: { satisfySemiRigid(p); break; }
      default: { break; }      
    }
  }
  
  PVector accumulateSemiRigid(Particle p) {
    // Obeys Hook's law: f = k * (x - x0)
    // Vector from neighbor to self
    PVector it2me = PVector.sub(p.pos, neighbor.pos);
    if (it2me.mag() > 0) {
      // If points are the same
      //if (it2me.mag() < 0.000001) it2me.set(1.0, 0.0);
      // Vector from neighbor to rest position
      it2me.normalize();
      PVector midpt = PVector.add(neighbor.pos, PVector.mult(it2me, mid));
      // Vector from current postition to rest position
      PVector me2mid = PVector.sub(midpt, p.pos);

      me2mid.mult(kspring); // Apply spring force
      return me2mid;
    }
    return new PVector(0, 0);
  }
  
  void satisfySemiRigid(Particle p) {
    // Vector from neighbor to self
    PVector it2me = PVector.sub(p.pos, neighbor.pos); 
    if (it2me.mag() > 0) {
      // Find midpoint
      PVector midpt = PVector.div(PVector.add(p.pos, neighbor.pos), 2.0);
      // If points are the same
      //if (it2me.mag() == 0.0) it2me.set(1.0, 0.0);
      // Length of spring
      float radius = it2me.mag();
      // Constraint to min/max
      if (radius < min) radius = min;
      if (radius > max) radius = max;
      // Scale to length
      it2me.normalize();
      it2me = PVector.mult(it2me, radius);
      // Apply constraint
      p.pos.set(PVector.add(midpt, PVector.div(it2me, 2.0)));
      neighbor.pos.set(PVector.sub(midpt, PVector.div(it2me, 2.0)));
    }
  }
}
