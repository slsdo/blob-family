/*
 Blob Family - v0.0.5 - 2014/01/10
 */

final int RIGID = 1; // Rigid constraint
final int SEMI_RIGID = 2; // Semi-Rigid constraint

float step_size = 0.05;
float friction = 1.0; // Friction force
int relax_iter = 1; // Relaxation iteration
int jump = 0; // Keep track of jump state
boolean enable_gravity = true; // Toggle gravity
boolean DEBUG = true;
boolean[] keys = new boolean[4]; // Check key press
PVector gravity = new PVector(0.0, 80.0); // Gravity vector
Level lv;
ArrayList blobs;

void setup()
{
  size(800, 500);
  background(255, 255, 255);
  
  lv = new Level();
  lv.initWallSimple();

  blobs = new ArrayList();
}

void draw()
{
  background(255, 255, 255);
  lv.render();
  
  int blobnum = blobs.size();
  for (int i = 0; i < blobnum; i++) {
    ParticleSystem b = (ParticleSystem) blobs.get(i);
      b.update();
      b.render();
  }
  
  if (DEBUG) {
    fill(0, 102, 153);
    text(frameRate, 10, 25);
    fill(0, 0, 0);
  }
}

void addVerletBlob(int segments, float x, float y, float min, float mid, float max, float kspring)
{
  float angle_step = 2.0 * PI / float(segments);
  float seg_length = 2.0 * mid * sin(angle_step/2.0);
  ParticleSystem verlet = new ParticleSystem(segments + 1, 5, step_size);
  
  // Center particle
  verlet.blob[0].setPos(x, y);
  //verlet.blob[0].mass = segments;
  
  Particle center = verlet.blob[0];
  Particle[] pa = new Particle[segments];
  // Create surrounding particles
  for (int i = 0; i < segments; i++) {
    float angle = i * angle_step;
    float bx = x + mid * cos(angle);
    float by = y + mid * sin(angle);
    pa[i] = verlet.blob[i + 1];
    pa[i].setPos(bx, by);
  }
  
  // Create constraints for surrounding particles
  for (int i = 0; i < segments; i++) {
    int next = (i + 1) % segments;
    pa[i].addSemiRigidConstraints(pa[next], seg_length*0.9, seg_length, seg_length*1.1, kspring);
    pa[next].addSemiRigidConstraints(pa[i], seg_length*0.9, seg_length, seg_length*1.1, kspring);
    pa[i].addSemiRigidConstraints(center, min, mid, max, kspring);
    center.addSemiRigidConstraints(pa[i], min, mid, max, kspring);
  }
  
  blobs.add(verlet);
}

void addTest2P()
{
  ParticleSystem test = new ParticleSystem(2, 20, step_size);
  
  test.blob[0].setPos(300, 300);
  test.blob[1].setPos(310, 300);
  
  // Create constraints for surrounding particles
  test.blob[0].addSemiRigidConstraints(test.blob[1], 40, 80, 100, 10);
  test.blob[1].addSemiRigidConstraints(test.blob[0], 40, 80, 100, 10);
  
  blobs.add(test);
}

// Some math functions
PVector vmin(PVector v1, PVector v2) { return new PVector(min(v1.x, v2.x), min(v1.y, v2.y), min(v1.z, v2.z)); }
PVector vmax(PVector v1, PVector v2) { return new PVector(max(v1.x, v2.x), max(v1.y, v2.y), max(v1.z, v2.z)); }
float dist2(PVector v1, PVector v2) { return ((v1.x - v2.x)*(v1.x - v2.x) + (v1.y - v2.y)*(v1.y - v2.y) + (v1.z - v2.z)*(v1.z - v2.z)); }

