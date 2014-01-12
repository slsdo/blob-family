
class Constraint
{
  Particle neighbor; // Connected particle
  int type; // Type of constraint
  
  // For semi-rigid constraint
  float min; // Compressed length
  float max; // Stretched length
  float mid; // Relaxed length
  float kspring; // Spring elasticity
  color d_color; // Debug constraint color
  PVector d_pt; // Debug constraint point
  
  Constraint() {}
  
  void initSemiRigid(Particle p, float mn, float md, float mx, float ks) {
    neighbor = p;
    type = 2;
    min = mn;
    mid = md;
    max = mx;
    kspring = ks;
    d_color = color(0, 0, 0);
    d_pt = new PVector(0.0, 0.0);
  }

  PVector accumulateForce(Particle p) {
    PVector forcetotal = new PVector();
    switch(type) {
      case SEMI_RIGID: { forcetotal = accumulateSemiRigid(p); break; }
      default: { forcetotal.set(0.0, 0.0); }      
    }
    return forcetotal;    
  }
  
  void satisfyConstraints(Particle p) {
    switch(type) {
      case SEMI_RIGID: { satisfySemiRigid(p); break; }
      default: { break; }      
    }
  }
  
  PVector accumulateSemiRigid(Particle p) {
    // Obeys Hook's law: f = k * (x - x0)
    // Vector from neighbor to self
    PVector it2me = PVector.sub(p.pos, neighbor.pos);
    // Vector from neighbor to rest position
    it2me.normalize();
    PVector midpt = PVector.add(neighbor.pos, PVector.mult(it2me, mid));
    // Vector from current postition to rest position
    PVector me2mid = PVector.sub(midpt, p.pos);
    // Apply spring force
    me2mid.mult(kspring);
    return me2mid;
  }
  
  void satisfySemiRigid(Particle p) {
    // Vector from neighbor to self
    PVector it2me = PVector.sub(p.pos, neighbor.pos);
    // Length of spring
    float radius = it2me.mag();
    // Calculate constraint debug color
    if (DEBUG) {
      float delta = radius - mid;
      float r = (delta < 0) ? map(delta, mid, (min - mid), 0, 255) : 0; // Less than rest length is red
      float b = (delta > 0) ? map(delta, mid, (max - mid), 0, 255) : 0; // More than rest length is blue
      d_color = color(r, 0, b);
    }
    // Constraint to min/max
    if (radius < min || radius > max) {
      if (radius < min) radius = min;
      if (radius > max) radius = max;
      // Scale to length
      it2me.normalize();
      it2me = PVector.mult(it2me, radius);
      // Find midpoint
      PVector midpt = PVector.div(PVector.add(p.pos, neighbor.pos), 2.0);
      // Apply constraint
      p.pos.set(PVector.add(midpt, PVector.div(it2me, 2.0)));
      neighbor.pos.set(PVector.sub(midpt, PVector.div(it2me, 2.0)));
    }
    // Debug point
    if (DEBUG) d_pt.set(p.pos);
  }
}
