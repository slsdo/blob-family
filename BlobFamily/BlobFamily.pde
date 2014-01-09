/*
 Blob Family - v0.0.1 - 2014/01/05
 */

float STEP_SIZE = 0.0016666;
final int RIGID = 1; // Rigid constraint
final int SEMI_RIGID = 2; // Semi-Rigid constraint
int PT_COLLISION = 3; // World-Point collision
int LN_COLLISION = 4; // World-Line collision
boolean GRAVITY = true; // Toggle gravity

PVector gravity = new PVector(0, 9.8, 0);
ParticleSystem v;

void setup()
{
  size(800, 500);
  background(255, 255, 255);
  v = createVerletBlob(10, width/2, height/2, 100, 180, 220, 10);
}

void draw()
{
  background(255, 255, 255);
  v.update();
  v.render();
}

ParticleSystem createVerletBlob(int segments, float x, float y, float min, float mid, float max, float force)
{
  float angle_step = 2.0 * PI / float(segments);
  float seg_length = 2.0 * mid * sin(angle_step/2.0);
  ParticleSystem verlet = new ParticleSystem(segments + 1, STEP_SIZE);
  
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
    pa[i].addSemiRigidConstraints(pa[next], seg_length*0.9, seg_length, seg_length*1.1, force);
    pa[i].addSemiRigidConstraints(center, min, mid, max, force);
  }
  
  return verlet;
}

PVector vmin(PVector v1, PVector v2) { return new PVector(min(v1.x, v2.x), min(v1.y, v2.y), min(v1.z, v2.z)); }
PVector vmax(PVector v1, PVector v2) { return new PVector(max(v1.x, v2.x), max(v1.y, v2.y), max(v1.z, v2.z)); }
float dist2(PVector v1, PVector v2) { return ((v1.x - v2.x)*(v1.x - v2.x) + (v1.y - v2.y)*(v1.y - v2.y) + (v1.z - v2.z)*(v1.z - v2.z)); }
