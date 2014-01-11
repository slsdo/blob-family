/*
 Blob Family - v0.0.5 - 2014/01/10
 */

final int RIGID = 1; // Rigid constraint
final int SEMI_RIGID = 2; // Semi-Rigid constraint

float t_size = 0.03; // Time step
float f_friction = 1.0; // Friction force
float p_mass = 1.0; // Particle mass
float j_force = -50000.0; // Jump force
int relax_iter = 1; // Relaxation iteration
int jump = 0; // Keep track of jump state
boolean DEBUG = false;
boolean STRUCT = true;
boolean enable_gravity = false; // Toggle gravity
boolean[] keys = new boolean[4]; // Check key press
boolean d_lock1 = false; // DEBUG: lock first particle
PVector gravity = new PVector(0.0, 80.0); // Gravity vector
Level lv;
ArrayList blobs;

void setup()
{
  size(800, 600);
  background(255, 255, 255);
  
  lv = new Level();
  lv.initWallSimple();

  blobs = new ArrayList();
}

void draw()
{
  background(255, 255, 255);
  lv.render();
  
  int m = blobs.size();
  for (int i = 0; i < m; i++) {
    ParticleSystem b = (ParticleSystem) blobs.get(i);
    b.update();
    b.render();
  }
  
  // Display framerate
  if (DEBUG) {
    fill(0, 102, 153);
    text(frameRate, 10, 25);
    fill(0, 0, 0);
  }
}

// Simple spherical blob with a center particle and a circle of particles around it
void addVerletBlob(int segments, float x, float y, float min, float mid, float max, float kspring)
{
  float angle_step = 2.0 * PI / float(segments);
  float seg_length = 2.0 * mid * sin(angle_step/2.0);
  ParticleSystem verlet = new ParticleSystem(t_size);
  
  // Center particle
  Particle center = verlet.addParticle(p_mass, x, y);
  center.mass = segments;
  
  Particle[] pa = new Particle[segments];
  // Create surrounding particles
  for (int i = 0; i < segments; i++) {
    float angle = i * angle_step;
    float bx = x + mid * cos(angle);
    float by = y + mid * sin(angle);
    pa[i] = verlet.addParticle(p_mass, bx, by);
  }
  
  // Create constraints for surrounding particles
  for (int i = 0; i < segments; i++) {
    int next = (i + 1) % segments;
    // To next point
    addSemiRigidConstraint(pa[i], pa[next], seg_length*0.9, seg_length, seg_length*1.1, kspring);
    // To center point
    addSemiRigidConstraint(pa[i], center, min, mid, max, kspring);
  }
  
  blobs.add(verlet);
}

// Same as simple blob with extra braces on every other point
void addBracedBlob(int segments, float x, float y, float min, float mid, float max, float kspring)
{
  float angle_step = 2.0 * PI / float(segments);
  float seg_length = 2.0 * mid * sin(angle_step/2.0);
  float seg_length2 = 2.0 * mid * sin(angle_step*2.0/2.0);
  float seg_length3 = 2.0 * mid * sin(angle_step*3.0/2.0);
  ParticleSystem braced = new ParticleSystem(t_size);
  
  // Center particle
  Particle center = braced.addParticle(p_mass, x, y);
  center.mass = segments;
  
  Particle[] pa = new Particle[segments];
  // Create surrounding particles
  for (int i = 0; i < segments; i++) {
    float angle = i * angle_step;
    float bx = x + mid * cos(angle);
    float by = y + mid * sin(angle);
    pa[i] = braced.addParticle(p_mass, bx, by);
  }
  
  // Create constraints for surrounding particles
  for (int i = 0; i < segments; i++) {
    int next = (i + 1) % segments;
    int next2 = (i + 3) % segments;
    // To next point
    addSemiRigidConstraint(pa[i], pa[next], seg_length*0.1, seg_length, seg_length*2.1, kspring);
    // To next next point
    addSemiRigidConstraint(pa[i], pa[next2], seg_length*0.1, seg_length3, seg_length3*2.1, kspring);
    // To center point
    addSemiRigidConstraint(pa[i], center, min, mid, max, kspring);
  }
  
  blobs.add(braced);
}

// A blob with thick structural skin
void addSkinnedBlob(int segments, float x, float y, float inner, float outer, float outer_spring, float inner_spring)
{
  float angle_step = 2.0 * PI / float(segments);
  float outer_length = 2.0 * outer * sin(angle_step/2.0);
  float inner_length = 2.0 * inner * sin(angle_step/2.0);
  float ring_gap = outer - inner;
  ParticleSystem skinned = new ParticleSystem(t_size);
  
  // Center particle
  Particle center = skinned.addParticle(p_mass, x, y);

  Particle[] pa = new Particle[segments*2];
  // Create outer circle particles
  for (int i = 0; i < segments; i++) {
    float angle = i * angle_step;
    float bx = x + inner * cos(angle);
    float by = y + inner * sin(angle);
    float cx = x + outer * cos(angle);
    float cy = y + outer * sin(angle);
    // i*2 is outer
    pa[i*2] = skinned.addParticle(p_mass, cx, cy);
     // i*2+1 is inner
    pa[i*2 + 1] = skinned.addParticle(p_mass, bx, by);
  }
  
  // Create constraints for surrounding particles
  for (int i = 0; i < segments; i++) {
    int next = (i + 1) % segments;
    // Outer ring
    addSemiRigidConstraint(pa[i*2], pa[next*2], outer_length*0.9, outer_length, outer_length*1.1, outer_spring);
    // Inner ring
    addSemiRigidConstraint(pa[i*2 + 1], pa[next*2 + 1], inner_length*0.9, inner_length, inner_length*1.1, outer_spring);
    // Join rings with structural springs
    addSemiRigidConstraint(pa[i*2], pa[i*2 + 1], ring_gap*0.9, ring_gap, ring_gap*1.1, outer_spring);
    // Cross brace
    addSemiRigidConstraint(pa[i*2], pa[next*2 + 1], ring_gap*0.9, ring_gap, ring_gap*1.1, outer_spring);
    // Inner ring to center point, with mid point of the spring to be greater than radius for internal pressure
    addSemiRigidConstraint(pa[i*2 + 1], center, inner*0.2, inner*1.5, inner*2.1, inner_spring);
  }
  
  blobs.add(skinned);
}

void addTest2P()
{
  ParticleSystem test = new ParticleSystem(t_size);
  
  Particle t1 = test.addParticle(100, 200, 300);
  Particle t2 = test.addParticle(100, 400, 300);
  
  // Create constraints for surrounding particles
  addSemiRigidConstraint(t1, t2, 100, 150, 200, 10);
  
  blobs.add(test);
}

void addTest3P()
{
  ParticleSystem test = new ParticleSystem(t_size);
  
  Particle t1 = test.addParticle(20, 300, 300);
  Particle t2 = test.addParticle(20, 340, 300);
  Particle t3 = test.addParticle(20, 320, 330);
  
  // Create constraints for surrounding particles
  addSemiRigidConstraint(t1, t2, 40, 80, 100, 10);
  addSemiRigidConstraint(t1, t3, 40, 80, 100, 10);
  addSemiRigidConstraint(t3, t2, 40, 80, 100, 10);
  
  blobs.add(test);
}

void addSemiRigidConstraint(Particle p1, Particle p2, float min, float mid, float max, float force)
{
  p1.addSemiRigid(p2, min, mid, max, force);
  p2.addSemiRigid(p1, min, mid, max, force);
}

// Some math functions
PVector vmin(PVector v1, PVector v2) { return new PVector(min(v1.x, v2.x), min(v1.y, v2.y), min(v1.z, v2.z)); }
PVector vmax(PVector v1, PVector v2) { return new PVector(max(v1.x, v2.x), max(v1.y, v2.y), max(v1.z, v2.z)); }
float dist2(PVector v1, PVector v2) { return ((v1.x - v2.x)*(v1.x - v2.x) + (v1.y - v2.y)*(v1.y - v2.y) + (v1.z - v2.z)*(v1.z - v2.z)); }

