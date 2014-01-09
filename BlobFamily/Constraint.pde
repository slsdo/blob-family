
class Constraint
{
  Particle neighbor;
  int type;
  
  // For semi-rigid constraint
  float min; // Compressed length
  float max; // Stretched length
  float mid; // Relaxed length
  float force;
  
  Constraint() {}
  
  void initSemiRigid(Particle pt, float mn, float mx, float m, float cforce) {
    neighbor = pt;
    type = 2;
    min = mn;
    max = mx;
    mid = m;
    force = cforce;
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
    // Vector from neighbor to self
    PVector it2me = PVector.sub(p.pos, neighbor.pos);
    // If points are the same
    if (it2me.mag() < EPSILON) it2me.set(0.0, 0.0, 0.0);
    // Force vector from neighbor
    it2me.normalize();
    PVector midpt = PVector.add(neighbor.pos, PVector.mult(it2me, mid));
    // Force vector towards rest length
    PVector me2mid = PVector.sub(midpt, p.pos);
    
    me2mid.mult(force); // Apply spring force
    return me2mid;
  }
  
  void satisfySemiRigid(Particle p) {
    // Vector from neighbor to self
    PVector it2me = PVector.sub(p.pos, neighbor.pos);
    // Find midpoint
    PVector midpt = PVector.mult(PVector.add(p.pos, neighbor.pos), 0.5);
    // If points are the same
    if (it2me.mag() == 0.0) it2me.set(1.0, 0.0, 0.0);
    // Radius of particle
    float radius = it2me.mag();
    // Constraint to min/max
    if (radius < min) radius = min;
    if (radius > max) radius = max;
    // Scale to required radius
    it2me.normalize();
    it2me = PVector.mult(it2me, radius);
    
    // Apply constraint
    p.pos.set(PVector.add(midpt, PVector.mult(it2me, 0.5)));
    neighbor.pos.set(PVector.sub(midpt, PVector.mult(it2me, 0.5)));
    
    p.pos = vmin(vmax(p.pos, new PVector(0.0, 0.0, 0.0)), new PVector(float(width), float(height), 0.0));
  }
}
