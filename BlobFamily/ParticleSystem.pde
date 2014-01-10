
class ParticleSystem
{
  Particle[] blob; // Array of VerletParticle
  float mass; // Total mass
  float timestep; // Time step
  
  // Initialize system of particles
  ParticleSystem(int n, float m, float t) {
    blob = new Particle[n];
    mass = 0.0;
    // Initialize array
    for (int i = 0; i < n; i++) {
      blob[i] = new Particle(m);
      mass += m;
    }
    timestep = t;
  }
  
  // Step through time iteration
  void update() {
    accumulate(); // Force Accumulator
    integrate(); // Verlet Integration
    constraints(); // Satisfy Constraints
    collision(); // Collision Detection
  }

  void accumulate() {
    for (int i = 0; i < blob.length; i++) {
      blob[i].force.set(0.0, 0.0);
      
      // Apply gravity if enabled
      if (enable_gravity) blob[i].force.add(PVector.mult(gravity, blob[i].mass));

      if (keys[0]) { blob[i].force.add(new PVector(0.0, -60.0)); } // Up
      if (keys[1]) { blob[i].force.add(new PVector(-60.0, 0.0)); } // Left
      if (keys[2]) { blob[i].force.add(new PVector(0.0, 60.0)); } // Down
      if (keys[3]) { blob[i].force.add(new PVector(60.0, 0.0)); } // Right
      if (jump == 1) { blob[i].force.add(new PVector(0.0, -50000.0*blob[i].mass)); jump = -1; } // Jump

      // Iterate through all connected constraints
      int segments = blob[i].constraints.size();
      for (int j = 0; j < segments; j++) {
        Constraint c = (Constraint) blob[i].constraints.get(j);
        blob[i].force.add(c.accumulateForce(blob[i]));
      }
    }
  }

  void integrate() {
    for (int i = 0; i < blob.length; i++) {
      blob[i].integrateVerlet(timestep);
      
      // Dragged around
      if (blob[i].drag) {
        PVector m = new PVector(mouseX, mouseY);
        blob[i].pos.set(m);
      }
    }
  }

  void constraints() {
    for (int n = 0; n < relax_iter; n++) {
      for (int i = 0; i < blob.length; i++) {
        // Iterate through all connected constraints
        int segments = blob[i].constraints.size();
        for (int j = 0; j < segments; j++) {
          Constraint c = (Constraint) blob[i].constraints.get(j);
          c.satisfyConstraints(blob[i]);
        }
      }
    }
    
    //blob[0].pos.set(blob[0].pos0.x, blob[0].pos0.y); // lock particle 0
    //blob[1].pos.set(blob[1].pos.x, blob[1].pos0.y); // lock particle 1
  }
  
  void collision() {
    for (int i = 0; i < blob.length; i++) {
      // Project points outside of obstacle during border collision
      worldBoundCollision(blob[i]);
    }
  }

  void render() {
    for (int i = 0; i < blob.length; i++) {
      if (DEBUG) {
        if (blob[i].drag) {
          PVector m = new PVector(mouseX, mouseY);
          stroke(204, 0, 0);
          // Mouse drag
          line(blob[i].pos.x, blob[i].pos.y, m.x, m.y);
        }
        else stroke(0, 102, 153);
        noFill();
        // Particle
        ellipse(blob[i].pos.x, blob[i].pos.y, blob[i].mass, blob[i].mass);
        // Iterate through all connected constraints
        stroke(0, 0, 0);
        int segments = blob[i].constraints.size();
        for (int j = 0; j < segments; j++) {
          Constraint c = (Constraint) blob[i].constraints.get(j);
          // Constraint between particles 
          line(blob[i].pos.x, blob[i].pos.y, c.neighbor.pos.x, c.neighbor.pos.y);
        }
      }
    }
  }
}

class Particle
{
  PVector pos0; // Previous position
  PVector pos; // Current position
  PVector force;
  float mass; // Size of particle
  ArrayList constraints; // Links to other particles
  boolean drag;
  
  Particle(float m) {
    pos0 = new PVector(0.0, 0.0);
    pos = new PVector(0.0, 0.0);
    force = new PVector(0.0, 0.0);
    mass = m;
    constraints = new ArrayList();
    drag = false;
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
}

