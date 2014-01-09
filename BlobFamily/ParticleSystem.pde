
class ParticleSystem
{
  Particle[] blob; // Array of VerletParticle
  float timestep; // Time step
  int num;
  
  // Initialize system of particles
  ParticleSystem(int n, float t) {
    blob = new Particle[n];
    // Initialize array
    for (int i = 0; i < n; i++) {
      blob[i] = new Particle();
    }
    timestep = t;
    num = n;
  }
  
  // Step through time iteration
  void update() {
    accumulate(); // Force Accumulator
    integrate(); // Verlet Integration
    constraints(); // Satisfy Constraints
  }

  void accumulate() {
    for (int i = 0; i < num; i++) {
      // Apply gravity if enabled
      if (GRAVITY) blob[i].force.add(PVector.mult(new PVector(0.0, 100.0), blob[i].mass));
      
      if (keys[0]) { // Up
        blob[i].force.add(new PVector(0.0, -60.0));
      }
      if (keys[1]) { // Left
        blob[i].force.add(new PVector(-60.0, 0.0));
      }
      if (keys[2]) { // Down
        blob[i].force.add(new PVector(0.0, 200.0));
      }
      if (keys[3]) { // Right
        blob[i].force.add(new PVector(60.0, 0.0));
      }
      
      // Iterate through all connected constraints
      int segments = blob[i].constraints.size();
      for (int j = 0; j < segments; j++) {
        Constraint c = (Constraint) blob[i].constraints.get(j);
        blob[i].force.add(c.accumulateForce(blob[i]));
      }
    }
  }

  void integrate() {
    for (int i = 0; i < num; i++) {
      blob[i].integrateVerlet(timestep);
    }
  }

  void constraints() {
    for (int i = 0; i < num; i++) {
      // Iterate through all connected constraints
      int segments = blob[i].constraints.size();
      for (int j = 0; j < segments; j++) {
        Constraint c = (Constraint) blob[i].constraints.get(j);
        c.satisfyConstraints(blob[i]);
      }
    }
  }

  void render() {
    for (int i = 0; i < num; i++) {
      stroke(0, 0, 0);
      ellipse(blob[i].pos.x, blob[i].pos.y, blob[i].mass*10, blob[i].mass*10);
      // Iterate through all connected constraints
      int segments = blob[i].constraints.size();
      for (int j = 0; j < segments; j++) {
        Constraint c = (Constraint) blob[i].constraints.get(j);
        line(blob[i].pos.x, blob[i].pos.y, c.neighbor.pos.x, c.neighbor.pos.y);
      }
    }
  }
}

class Particle
{
  PVector pos0; // Previous position
  PVector pos; // Current position
  PVector force;
  float mass;
  ArrayList constraints; // Links to other particles
  
  Particle() {
    pos0 = new PVector(0.0, 0.0);
    pos = new PVector(0.0, 0.0);
    force = new PVector(0.0, 0.0);
    mass = 1.0;
    constraints = new ArrayList();
  }
  
  // Set position
  void setPos(float x, float y) {
    pos0.set(x, y);
    pos.set(x, y);
  }
  
  // Verlet integration
  void integrateVerlet(float t) {
    // posT = pos1
    PVector temp = new PVector();
    temp = pos.get();
    // pos1 += (pos1 - pos0) + force/mass*t*t
    pos = PVector.add(pos, PVector.add(PVector.sub(pos, pos0), PVector.mult(PVector.div(force, mass), (t*t))));
    // pos0 = posT
    pos0 = temp.get();
  }
  
  void addSemiRigidConstraints(Particle pt, float min, float max, float mid, float force) {
    Constraint c = new Constraint();
    c.initSemiRigid(pt, min, max, mid, force);
    constraints.add(c);  
  }

  /*
  void constraints() {    
    // Project points outside of obstacle during border collision
    //pos = vmin(vmax(pos, new PVector(0.0, 0.0, 0.0)), new PVector(float(width), float(height), 0.0));
  }
  */
}

