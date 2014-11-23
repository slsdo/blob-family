
class ParticleSystem
{
  ArrayList<Particle> particles; // Particles
  ArrayList<Constraint> constraints; // Constraint between particles
  float totalmass; // Total mass
  float timestep; // Time step
  float size; // Blob size
  PVector target; // Random target to wander towards
  float f_jump; // Jumping force
  boolean rand_jump; // Random jump flag
  int mb_size; // Metaball size
  int mb_thresh; // Metaball threshold

  // Initialize system of particles
  ParticleSystem(float t, int mbs, int mbt) {
    particles = new ArrayList<Particle>();
    constraints = new ArrayList<Constraint>();
    totalmass = 0;
    timestep = t;
    size = 1;
    target = new PVector(random(width), random(height - ground_h), 0);
    f_jump = -60.0;
    rand_jump = false;
    mb_size = mbs;
    mb_thresh = mbt;
  }

  // Add particle to the blob
  Particle addParticle(float x, float y, float m, float r) {
    Particle p = new Particle(m, r);
    p.setPos(x, y); // Set particle position
    particles.add(p);
    totalmass += m; // Accumulate blob mass
    return p;
  }

  // Create rigid constraint between two particles
  void addConstraint(Particle p1, Particle p2, float len) {
    Constraint c = new Constraint();
    c.initRigid(p1, p2, len);
    constraints.add(c);
    
    // Store constraints acting on the particle
    p1.addLink(c);
    p2.addLink(c);
  }

  // Create semi-rigid constraint between two particles
  void addConstraint(Particle p1, Particle p2, float min, float mid, float max, float force) {
    Constraint c = new Constraint();
    c.initSemiRigid(p1, p2, min, mid, max, force);
    constraints.add(c);
    
    // Store constraints acting on the particle
    p1.addLink(c);
    p2.addLink(c);
  }
  
  void setSize(float s) {
    size = s;
  }

  // Step through time iteration
  void update() {
    updateJsZ(); // PVector.set() fix for JS mode
    updateForce(); // Force Accumulator
    updateVerlet(); // Verlet Integration
    updateCollision(); // Collision Detection
    updateConstraint(); // Satisfy Constraints
  }

  // In JS mode PVector.set() sets z to NaN if it's 0, this fixes it   
  void updateJsZ() {
    int psize = particles.size(); // Cache arraylist size
    for (int i = 0; i < psize; i++) {
      Particle p = particles.get(i);
      p.pos.z = 0;
    }
  }

  void updateForce() {
    PVector movement = new PVector(0, 0, 0);
    // Move randomly
    if (enable_ai) target = updateTarget();
    
    if (DEBUG && enable_ai) {
      stroke(255, 0, 0);
      fill(255, 0, 0);
      ellipse(target.x, target.y, 10, 10);
    }
    
    int psize = particles.size(); // Cache arraylist size
    for (int i = 0; i < psize; i++) {
      Particle p = particles.get(i);      
      p.accumulateForces(this);
    }
  }

  // Returns a new random wandering direction
  PVector updateTarget()
  {
    PVector vel = new PVector(random(-10, 10), random(-2, 2), 0); // Random velocity vector
    PVector steer = PVector.add(target, vel); // Determine new movement
  
    // If out-of-bound
    if (steer.x < 0) steer.x += width;
    else if (steer.x > width) steer.x -= width;
    if (steer.y < 0) steer.y += height - ground_h;
    else if (steer.y > height - ground_h) steer.y -= height - ground_h;
    
    return steer;
  }

  void updateVerlet() {
    int psize = particles.size(); // Cache arraylist size
    for (int i = 0; i < psize; i++) {
      Particle p = particles.get(i);
      p.integrateVerlet(timestep);
    }
  }

  void updateConstraint() {
    int csize = constraints.size(); // Cache arraylist size
    // Relaxation loop to avoid collapse of the spring mass structure
    for (int iter = 0; iter < relax_iter; iter++) {
      // Iterate through all connected constraints
      for (int i = 0; i < csize; i++) {
        Constraint c = constraints.get(i);
        c.satisfyConstraint();
      }
    }
    
    // lock particle 0
    if (DEBUG && d_lock1) {
      Particle p1 = particles.get(0);
      p1.pos.set(p1.pos0.x, p1.pos0.y);
    }
  }

  void updateCollision() { 
    f_jump = -60.0; // Update jump force
       
    int n = particles.size(); // Cache arraylist size
    for (int i = 0; i < n; i++) {
      Particle p = particles.get(i);
      // Project points outside of obstacle during border collision
      detectCollision(p);
    }
    
    // Jump randomly
    if (enable_ai) {
      rand_jump = false;
      if (int(random(100)) < 1) {
        rand_jump = true;
        f_jump = -800;
      }
    }
  }
  
  // Simple world collision detection 
  void detectCollision(Particle p)
  {
    float half_mass = p.mass*0.5;
    
    if (checkCollision(p.pos, half_mass)) {
      PVector normal = getNormal(p.pos, half_mass);    
      PVector movement = PVector.sub(p.pos, p.pos0);
      float perp = movement.dot(normal);    
      PVector parallel = PVector.sub(movement, PVector.mult(normal, perp));
      
      if (!checkCollision(PVector.add(p.pos0, parallel), half_mass)) {
        p.pos = PVector.add(p.pos0, PVector.mult(parallel, f_friction));
      }
      else {
        // If all else fails, just move to collision point
        if (normal.x < 0.0) p.pos.x = half_mass;
        else if (normal.x > 0.0) p.pos.x = width - half_mass;
        if (normal.y < 0.0) p.pos.y = half_mass;
        else if (normal.y > 0.0) p.pos.y = height - ground_h - half_mass;
      }
    }
  }
  
  // Check if a collision has occured
  boolean checkCollision(PVector pos, float half_mass)
  {
    // Check x/y component of particle coordinate
    if (pos.x < half_mass || pos.x > width - half_mass ||
        pos.y < half_mass || pos.y > height - ground_h  - half_mass) return true;
    return false;  
  }
  
  // Obtain normal of current movement direction
  PVector getNormal(PVector pos, float half_mass)
  {
    PVector normal = new PVector(0.0, 0.0, 0.0);
    // Obtain x component of current movement
    if (pos.x < half_mass) { normal.x = -1.0; f_jump = -60; }
    else if (pos.x > width - half_mass) { normal.x = 1.0; f_jump = -60; }
    // Check y component of current movement, only when on the ground can jump force be large
    if (pos.y < half_mass) { normal.y = -1.0; f_jump = 0; }
    else if (pos.y > height - ground_h  - half_mass) { normal.y = 1.0; f_jump = -500; }
    return normal;  
  }

  void render() {
    int psize = particles.size();
    // Render particles
    for (int i = 0; i < psize; i++) {
      Particle p = particles.get(i);
      
      // Find local box for rendering metaball
      if (enable_metaball) {
        for (int x = floor(p.pos.x - size); x < ceil(p.pos.x + size); x++) {
          for (int y = floor(p.pos.y - size); y < ceil(p.pos.y + size); y++) {
            int index = x + y*width;
            
            if (index >= 0 && index < screen_size) {
              metabox[index] = 1; 
            }
          }
        }
      
        if (DEBUG) {
          noFill();
          stroke(#cccccc);
          rect(p.pos.x - size*0.5, p.pos.y - size*0.5, size, size);
        }
      }
      
      if (DEBUG && enable_ai) {
        stroke(255, 0, 255, 50);
        line(p.pos.x, p.pos.y, target.x, target.y);
      }
      
      // Mouse drag force
      if (p.drag) {
        PVector m = new PVector(mouseX, mouseY);
        stroke(255, 0, 0);
        line(p.pos.x, p.pos.y, m.x, m.y);
      }
      else stroke(0, 102, 153);  
      // Particle
      noFill();
      strokeWeight(2);
      ellipse(p.pos.x, p.pos.y, p.mass*5, p.mass*5);
      strokeWeight(1);
    }
    
    int csize = constraints.size();
    // Render constraints
    for (int i = 0; i < csize; i++) {
      // Iterate through all connected constraints
      stroke(0, 0, 0);
      Constraint c = constraints.get(i);
      // Constraint pressure
      if (DEBUG) {
        PVector normal = new PVector(c.p1.pos.y - c.p2.pos.y, c.p2.pos.x - c.p1.pos.x);
        normal.mult(0.1);
        stroke(c.d_color);
        line(c.d_pt.x + normal.x, c.d_pt.y + normal.y, c.d_pt.x + -1*normal.x, c.d_pt.y + -1*normal.y);
      }
      // Constraint between particles
      stroke(#666666);
      line(c.p1.pos.x, c.p1.pos.y, c.p2.pos.x, c.p2.pos.y);
    }
  }
}

