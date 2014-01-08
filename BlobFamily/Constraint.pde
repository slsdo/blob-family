
class Constraint
{
  VerletParticle neighbor;
  int type;
  
  // For semi-rigid constraint
  float min;
  float max;
  float mid; // Midpoint between self and neighbor
  float force;
  
  Constraint() {}
  
  void initSemiRigid(VerletParticle pt, float cmin, float cmax, float cmid, float cforce) {
    neighbor = pt;
    type = 2;
    min = cmin;
    max = cmax;
    mid = cmid;
    force = cforce;
  }
  
  PVector accumulateForce(VerletParticle p) {
    PVector force = new PVector();
    switch(type) {
      case RIGID: {
        //force = accumulateRigid(self); TO-DO
        break;
      }
      case SEMI_RIGID: {
        force = accumulateSemiRigid(p);
        break;
      }
      default: {
        force.set(0.0, 0.0);
      }      
    }
    return force;    
  }
  
  PVector accumulateSemiRigid(VerletParticle p) {
    // Vector from neighbor to self
    PVector it2me = PVector.sub(p.pos, neighbor.pos);
    // If points are the same
    if (dist2(p.pos, neighbor.pos) < 0.000001) it2me.set(0.0, 0.0, 0.0);
    // Vector from neighbor to midpoint
    it2me.normalize();
    PVector midpt = PVector.add(neighbor.pos, PVector.mult(it2me, mid));
    // Vector from self to midpoint
    PVector me2mid = PVector.sub(midpt, p.pos);
    
    me2mid.mult(force); // Apply spring force
    return me2mid;
  }
}
