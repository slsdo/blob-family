
class Particle
{
  PVector pos0; // Previous position
  PVector pos; // Current position
  PVector force;
  float mass; // Size of particle
  float rad; // Radius
  ArrayList<Constraint> links; // Constraint between particles
  boolean drag; // Mouse drag

  Particle(float m, float r) {
    pos0 = new PVector(0, 0, 0);
    pos = new PVector(0, 0, 0);
    force = new PVector(0, 0, 0);
    mass = m;
    rad = r;
    links = new ArrayList<Constraint>();
    drag = false;
  }

  // Set particle position
  void setPos(float x, float y) {
    pos0.set(x, y);
    pos.set(x, y);
  }
  
  // Gather forces acting on the particle
  void accumulateForces() {
    force.set(0, 0, 0); // Reset force

    // Apply gravity if enabled
    if (enable_gravity) force.add(PVector.mult(gravity, mass));

    // Keyboard input
    if (keys[0]) force.add(new PVector(0, -60.0, 0)); // Up
    if (keys[1]) force.add(new PVector(-100.0, 0, 0)); // Left
    if (keys[2]) force.add(new PVector(0, 60.0, 0)); // Down
    if (keys[3]) force.add(new PVector(60.0, 0, 0)); // Right

    // Gather forces from all connected constraints
    int lsize = links.size();
    for (int i = 0; i < lsize; i++) {
      Constraint c = links.get(i);
      force.add(c.getForce(this));
    }
    
    force.limit(f_max); // Limit force in case of emergency

    // Dragged around by mouse
    if (drag) {
      PVector m = new PVector(mouseX, mouseY);
      force.add(PVector.mult(PVector.sub(m, pos), 500));
      //pos.set(m);
    }

    if (DEBUG) {
      // Project force
      stroke(0, 204, 0);
      line(pos.x, pos.y, pos.x + force.x*0.1, pos.y + force.y*0.1);
    }
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
  void addLink(Constraint c) {
    links.add(c);
  }
}

