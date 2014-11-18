
class Constraint
{
  Particle p1; // Connected particle 1
  Particle p2; // Connected particle 2
  int type; // Type of constraint
  
  // For semi-rigid constraint
  float min; // Compressed length
  float max; // Stretched length
  float mid; // Relaxed length
  float kspring; // Spring elasticity
  
  color d_color; // Debug constraint color
  PVector d_pt; // Debug constraint point
  
  Constraint() {}

  void initRigid(Particle particle1, Particle particle2, float len) {
    p1 = particle1;
    p2 = particle2;
    type = 1;
    min = len;
    mid = len;
    max = len;
    kspring = 1.0;
    d_color = color(0, 0, 0);
    d_pt = new PVector(0, 0, 0);
  }

  void initSemiRigid(Particle particle1, Particle particle2, float mn, float md, float mx, float ks) {
    p1 = particle1;
    p2 = particle2;
    type = 2;
    min = mn;
    mid = md;
    max = mx;
    kspring = ks;
    d_color = color(0, 0, 0);
    d_pt = new PVector(0, 0, 0);
  }

  PVector getForce(Particle p) {
    PVector forcetotal = new PVector();
    switch(type) {
      case RIGID: { forcetotal = getRigidForce(p); break; }
      case SEMI_RIGID: { forcetotal = getSemiRigidForce(p); break; }
      default: { forcetotal.set(0, 0, 0); }      
    }
    return forcetotal;    
  }
  
  void satisfyConstraint() {
    switch(type) {
      case RIGID: { satisfyRigid(); break; }
      case SEMI_RIGID: { satisfySemiRigid(); break; }
      default: { break; }      
    }
  }

  PVector getRigidForce(Particle p) {
     // Rigid constraint exerts no force
    return new PVector(0, 0, 0);
  }
  
  PVector getSemiRigidForce(Particle p) {
    // Determine current particle
    Particle neighbor;
    if (p == p1) neighbor = p2;
    else neighbor = p1;
    // Obeys Hook's law: f = k * (x - x0)
    // Vector from neighbor to self
    PVector it2me = PVector.sub(p.pos, neighbor.pos);
    // Vector from neighbor to rest position
    it2me.normalize();
    PVector it2mid = PVector.add(neighbor.pos, PVector.mult(it2me, mid));
    // Vector from current postition to rest position
    PVector me2mid = PVector.sub(it2mid, p.pos);
    // Apply spring force
    me2mid.mult(kspring);
    return me2mid;
  }
  
  void satisfyRigid() {
    // Vector from neighbor to self
    PVector it2me = PVector.sub(p1.pos, p2.pos);
    // Length of spring
    float dist = it2me.mag();
    // Constraint to rigid length
    if (dist != mid) {
      it2me.normalize();
      float diff = dist - mid;
      // Apply constraint
      p1.pos.set(PVector.sub(p1.pos, PVector.div(PVector.mult(it2me, diff), 2.0)));
      p2.pos.set(PVector.add(p2.pos, PVector.div(PVector.mult(it2me, diff), 2.0)));
    }
    // Debug color and point
    if (DEBUG) {
      d_color = color(255, 0, 255);
      d_pt.set(PVector.div(PVector.add(p1.pos, p2.pos), 2.0));
    }
  }
  
  void satisfySemiRigid() {
    // Vector from neighbor to self
    PVector it2me = PVector.sub(p1.pos, p2.pos);
    // Length of spring
    float dist = it2me.mag();
    // Calculate constraint debug color
    if (DEBUG) {
      float delta = dist - mid;
      float r = (delta < 0) ? map(delta, mid, (min - mid), 0, 255) : 0; // Less than rest length is red
      float b = (delta > 0) ? map(delta, mid, (max - mid), 0, 255) : 0; // More than rest length is blue
      d_color = color(r, 0, b);
    }
    // Constraint to min/max
    if (dist < min || dist > max) {
      if (dist < min) dist = min;
      if (dist > max) dist = max;
      // Scale to length
      it2me.normalize();
      it2me = PVector.mult(it2me, dist);
      // Find midpoint
      PVector midpt = PVector.div(PVector.add(p1.pos, p2.pos), 2.0);
      // Apply constraint
      p1.pos.set(PVector.add(midpt, PVector.div(it2me, 2.0)));
      p2.pos.set(PVector.sub(midpt, PVector.div(it2me, 2.0)));
    }
    // Debug point
    if (DEBUG) d_pt.set(PVector.div(PVector.add(p1.pos, p2.pos), 2.0));
  }
}
