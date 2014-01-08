/*
 Blob Family - v0.0.1 - 2014/01/05
 */

float STEP_SIZE = 0.0016666;
final int RIGID = 1; // Rigid constraint
final int SEMI_RIGID = 2; // Semi-Rigid constraint
int PT_COLLISION = 3; // World-Point collision
int LN_COLLISION = 4; // World-Line collision
boolean GRAVITY = true; // Toggle gravity

PVector gravity = new PVector(0, 0.98, 0);

void setup()
{
  size(800, 500);
  background(255, 255, 255);
}

void draw()
{
  background(255, 255, 255);
  render();
}

VerletSystem createVerletBlob(int segments, float x, float y, float min, float mid, float max, float force)
{
  float angle_step = 2.0 * PI / float(segments);
  float seg_length = 2.0 * mid * sin(angle_step/2.0);
  VerletSystem v = new VerletSystem(segments, STEP_SIZE);
  
  v.blob[0].pos.set(x, y);
  v.blob[0].mass = segments;
  
  for (int i = 1; i < segments; i++) {
    float angle = i * angle_step;
    float bx = x + mid * cos(angle);
    float by = y + mid * sin(angle);
    v.blob[i].pos.set(bx, by);
  }
  
  for (int i = 0; i < segments; i++) {
    int next = (i + 1) % segments;
  }
  
  return v;
}

void render()
{
  for (int i = 0; i < 5; i++) {
    //ellipse(verlet.blob[i].pos.x, verlet.blob[i].pos.y, verlet.blob[i].mass*10, verlet.blob[i].mass*10);
  }  
}

class VerletSystem
{
  VerletParticle[] blob; // Array of VerletParticle
  float timestep; // Time step
  int num;
  
  // Initialize system of particles
  VerletSystem(int n, float t) {
    blob = new VerletParticle[n];
    // Initialize array
    for (int i = 0; i < n; i++) {
      blob[i] = new VerletParticle();
    }
    timestep = t;
    num = n;
  }
  
  // TODO move acc/int/const to system level, iterate through each separately
  // Step through time iteration
  void update() {
    accumulate(); // Force Accumulator
    integrate(); // Verlet Integration
    //constraints(); // Satisfy Constraints
  }
  
  void accumulate() {
    for (int i = 0; i < num; i++) {
      // Apply gravity if enabled
      if (GRAVITY) blob[i].force.add(PVector.mult(new PVector(0.0, 9.8), blob[i].mass));
      
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
      // posT = pos1
      PVector temp = new PVector();
      temp = blob[i].pos.get();
      // pos1 += (pos1 - pos0) + force/mass*t*t
      blob[i].pos = PVector.add(blob[i].pos, PVector.add(PVector.sub(blob[i].pos, blob[i].pos0), PVector.mult(PVector.div(blob[i].force, blob[i].mass), (timestep*timestep))));
      // pos0 = posT
      blob[i].pos0 = temp.get();
    }
  }

}

class VerletParticle
{
  PVector pos0; // Previous position
  PVector pos; // Current position
  PVector force;
  float mass;
  ArrayList constraints; // Links to other particles
  ArrayList collisions; // Collision constraints 
  
  VerletParticle() {
    //pos0 = new PVector(0.5*width, 0.5*height);
    pos0 = new PVector();
    pos = new PVector(0.0, 0.0);
    pos0 = pos.get();
    force = new PVector(0.0, 0.0);
    mass = 1.0;
    constraints = new ArrayList();
  }
  
  void addSemiRigidConstraints(VerletParticle pt, float min, float max, float mid, float force) {
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

PVector vmin(PVector v1, PVector v2) { return new PVector(min(v1.x, v2.x), min(v1.y, v2.y), min(v1.z, v2.z)); }
PVector vmax(PVector v1, PVector v2) { return new PVector(max(v1.x, v2.x), max(v1.y, v2.y), max(v1.z, v2.z)); }
float dist2(PVector v1, PVector v2) { return ((v1.x - v2.x)*(v1.x - v2.x) + (v1.y - v2.y)*(v1.y - v2.y) + (v1.z - v2.z)*(v1.z - v2.z)); }
