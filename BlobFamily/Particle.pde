
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

  // Add semi-rigid constraint
  void addLink(Constraint c) {
    links.add(c);
  }
  
  // Gather forces acting on the particle
  void accumulateForces(PVector target) {
    force.set(0, 0, 0); // Reset force

    // Apply gravity if enabled
    if (enable_gravity) force.add(PVector.mult(gravity, mass));

    // Keyboard input
    if (keys[0]) force.add(new PVector(0, f_jump, 0)); // Up
    if (keys[1]) force.add(new PVector(-100.0, 0, 0)); // Left
    if (keys[2]) force.add(new PVector(0, 60.0, 0)); // Down
    if (keys[3]) force.add(new PVector(60.0, 0, 0)); // Right
    
    // Move randomly
    if (enable_ai) {
      PVector dir = updateMovement(target.x, target.y);
      force.add(dir);
      
      // Jump randomly
      if (rand_jump) {
        force.add(new PVector(0, f_jump, 0)); // If jumping
      }
    }
    
    // Blob moves towards the mouse
    if (follow_m) {
      PVector dir = updateMovement(mouseX, mouseY);
      force.add(dir);
      
      if (DEBUG) {
        stroke(255, 0, 255, 50);
        line(pos.x, pos.y, mouseX, mouseY);
      }
    }

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

  // Returns a movement vector based on input current and new position
  PVector updateMovement(float x1, float y1)
  {
    // Obtain x and y component of new direction
    float dx = abs(x1 - pos.x) > 100 ? (x1 - pos.x)*0.1 : (x1 - pos.x); // If x is too large, limit it
    float dy = (y1 - pos.y) > 0 ? (y1 - pos.y) : 0; // If y is negative, set it to 0
    return new PVector(dx, dy, 0);
  }
  
  // Simple world collision detection 
  void detectCollision()
  {
    if (checkCollision(pos)) {
      PVector normal = getNormal();    
      PVector movement = PVector.sub(pos, pos0);
      float perp = movement.dot(normal);    
      PVector parallel = PVector.sub(movement, PVector.mult(normal, perp));
      
      if (!checkCollision(PVector.add(pos0, parallel))) {
        pos = PVector.add(pos0, PVector.mult(parallel, f_friction));
      }
      else {
        // If all else fails, just move to collision point
        if (normal.x < 0.0) pos.x = mass*0.5;
        else if (normal.x > 0.0) pos.x = width - mass*0.5;
        if (normal.y < 0.0) pos.y = mass*0.5;
        else if (normal.y > 0.0) pos.y = height - ground_h - mass*0.5;
      }
    }
  }
  
  // Check if a collision has occured
  boolean checkCollision(PVector col)
  {
    // Check x/y component of particle coordinate
    if (col.x < mass*0.5 || col.x > width - mass*0.5 ||
        col.y < mass*0.5 || col.y > height - ground_h  - mass*0.5) return true;
    return false;  
  }
  
  // Obtain normal of current movement direction
  PVector getNormal()
  {
    PVector normal = new PVector(0.0, 0.0, 0.0);
    // Obtain x component of current movement
    if (pos.x < mass) { normal.x = -1.0; f_jump = -60; }
    else if (pos.x > width - mass) { normal.x = 1.0; f_jump = -60; }
    // Check y component of current movement, only when on the ground can jump force be large
    if (pos.y < mass) { normal.y = -1.0; f_jump = 0; }
    else if (pos.y > height - ground_h  - mass) { normal.y = 1.0; f_jump = -200; }
    return normal;  
  }

}

