/*
 Blob Family - v0.0.1 - 2014/01/05
 */

VerletSystem vs;
int VERLET_PARTICLE_NUM = 10;

void setup()
{
  size(800, 500);
  background(255, 255, 255);
  vs = new VerletSystem();
}

void draw()
{
  background(255, 255, 255);
  for (int i = 0; i < VERLET_PARTICLE_NUM; i++) {
    vs.vps[i].integrate(0.2);
  }
  render();
}

void render()
{
  for (int i = 0; i < VERLET_PARTICLE_NUM; i++) {
    ellipse(vs.vps[i].pos1.x, vs.vps[i].pos1.y, 8, 8);
  }  
}

class VerletSystem
{
  VerletParticle[] vps; // Array of VerletParticle
  
  VerletSystem() {
    vps = new VerletParticle[VERLET_PARTICLE_NUM];
    // Initialize array
    for (int i = 0; i < VERLET_PARTICLE_NUM; i++) {
      vps[i] = new VerletParticle();
    }
  }
}

class VerletParticle
{
  PVector pos0; // Previous position
  PVector pos1; // Current position
  PVector force;
  float mass;
  
  VerletParticle() {
    //pos0 = new PVector(0.5*width, 0.5*height);
    pos0 = new PVector();
    pos1 = new PVector(random(width), random(height));
    pos0 = pos1.get();
    force = new PVector(0, 0);
    mass = 1.0;
  }
  
  // Verlet Integration
  void integrate(float t) {
    // posT = pos1
    PVector temp = new PVector();
    temp = pos1.get();
    // pos1 += (pos1 - pos0) + force/mass*t*t
    pos1 = PVector.add(pos1, PVector.add(PVector.sub(pos1, pos0), PVector.mult(PVector.div(force, mass), (t*t))));
    // pos0 = posT
    pos0 = temp.get();
  }
}
