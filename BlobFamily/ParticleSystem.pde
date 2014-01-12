
class ParticleSystem
{
  ArrayList blob; // Particles
  float totalmass; // Total mass
  float timestep; // Time step

  // Initialize system of particles
  ParticleSystem(float t) {
    blob = new ArrayList();
    totalmass = 0.0;
    timestep = t;
  }

  // Add particle to the blob
  Particle addParticle(float m, float x, float y) {
    Particle p = new Particle(m);
    p.setPos(x, y); // Set particle position
    blob.add(p);
    totalmass += m; // Accumulate blob mass
    return p;
  }

  // Step through time iteration
  void update() {
    int n = blob.size(); // Cache arraylist size
    accumulate(n); // Force Accumulator
    integrate(n); // Verlet Integration
    constraints(n); // Satisfy Constraints
    collision(n); // Collision Detection
  }

  void accumulate(int n) {
    for (int i = 0; i < n; i++) {
      Particle p = (Particle) blob.get(i);

      p.force.set(0.0, 0.0); // Reset force

      // Apply gravity if enabled
      if (enable_gravity) p.force.add(PVector.mult(gravity, p.mass));

      // Keyboard input
      if (jump == 1) { p.force.add(new PVector(0.0, j_force*p.mass)); jump = -1; } // Jump
      if (keys[0]) p.force.add(new PVector(0.0, -60.0)); // Up
      if (keys[1]) p.force.add(new PVector(-60.0, 0.0)); // Left
      if (keys[2]) p.force.add(new PVector(0.0, 60.0)); // Down
      if (keys[3]) p.force.add(new PVector(60.0, 0.0)); // Right

      // Gather forces from all connected constraints
      int segments = p.constraints.size();
      for (int j = 0; j < segments; j++) {
        Constraint c = (Constraint) p.constraints.get(j);
        p.force.add(c.accumulateForce(p));
      }

      if (DEBUG) {
        // Project force
        stroke(0, 204, 0);
        line(p.pos.x, p.pos.y, p.pos.x + p.force.x*0.1, p.pos.y + p.force.y*0.1);
      }
    }
  }

  void integrate(int n) {
    for (int i = 0; i < n; i++) {
      Particle p = (Particle) blob.get(i);
      p.integrateVerlet(timestep);

      // Dragged around by mouse
      if (p.drag) {
        PVector m = new PVector(mouseX, mouseY);
        p.pos.set(m);
      }
    }
  }

  void constraints(int n) {
    // Relaxation loop
    for (int iter = 0; iter < relax_iter; iter++) {
      for (int i = 0; i < n; i++) {
        Particle p = (Particle) blob.get(i);
        // Iterate through all connected constraints
        int segments = p.constraints.size();
        for (int j = 0; j < segments; j++) {
          Constraint c = (Constraint) p.constraints.get(j);
          c.satisfyConstraints(p);
        }
      }
    }
    
    // lock particle 0
    if (DEBUG && d_lock1) { Particle p = (Particle) blob.get(0); p.pos.set(p.pos0.x, p.pos0.y); }
  }

  void collision(int n) {
    for (int i = 0; i < n; i++) {
      Particle p = (Particle) blob.get(i);
      // Project points outside of obstacle during border collision
      worldBoundCollision(p);
    }
  }

  void render() {
    int n = blob.size();
    for (int i = 0; i < n; i++) {
      Particle p = (Particle) blob.get(i);
      
      if (DEBUG || STRUCT) {
        // Mouse drag force
        if (p.drag) {
          PVector m = new PVector(mouseX, mouseY);
          stroke(204, 0, 0);
          line(p.pos.x, p.pos.y, m.x, m.y);
        }
        else stroke(0, 102, 153);        
        // Particle
        noFill();
        ellipse(p.pos.x, p.pos.y, p.mass, p.mass);
        
        // Iterate through all connected constraints
        stroke(0, 0, 0);
        int segments = p.constraints.size();
        for (int j = 0; j < segments; j++) {
          Constraint c = (Constraint) p.constraints.get(j);
          // Constraint pressure
          if (DEBUG) {
            PVector normal = new PVector(-(c.neighbor.pos.y - p.pos.y), (c.neighbor.pos.x - p.pos.x));
            normal.mult(0.1);
            stroke(c.d_color);
            line(c.d_pt.x + normal.x, c.d_pt.y + normal.y, c.d_pt.x + -1*normal.x, c.d_pt.y + -1*normal.y);
          }
          // Constraint between particles
          stroke(#666666);
          line(p.pos.x, p.pos.y, c.neighbor.pos.x, c.neighbor.pos.y);
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
  ArrayList constraints; // Constraint between particles
  boolean drag; // Mouse drag

  Particle(float m) {
    pos0 = new PVector(0.0, 0.0);
    pos = new PVector(0.0, 0.0);
    force = new PVector(0.0, 0.0);
    mass = m;
    constraints = new ArrayList();
    drag = false;
  }

  // Set particle position
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

  // Add semi-rigid constraint
  void addSemiRigid(Particle p, float min, float mid, float max, float force) {
    Constraint c = new Constraint();
    c.initSemiRigid(p, min, mid, max, force);
    constraints.add(c);
  }
}

