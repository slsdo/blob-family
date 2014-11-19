/*
 Blob Family - v0.9.0 - 2014/11/19
 */

final int RIGID = 1; // Rigid constraint
final int SEMI_RIGID = 2; // Semi-Rigid constraint

float t_size = 0.03; // Time step
float f_friction = 0.5; // Friction force
float f_max = 5000.0; // Max force
int relax_iter = 4; // Relaxation iteration
int ground_h = 100; // Height of ground
int[] metabox; // Metaball bounding box
int screen_size;
int metaball_band = 400;
int metaball_size = 300;
boolean DEBUG = false;
boolean show_struct = true;
boolean enable_metaball = true;
boolean enable_gravity = true; // Toggle gravity
boolean[] keys = new boolean[4]; // Check key press
boolean d_lock1 = false; // DEBUG: lock first particle
PVector gravity = new PVector(0, 80.0, 0); // Gravity vector
ArrayList<ParticleSystem> blobs;
Ground ground;

void setup()
{
  size(800, 600);
  background(255, 255, 255);
  screen_size = width*height;
  metabox = new int[screen_size];

  ground = new Ground();
  ground.init();

  blobs = new ArrayList<ParticleSystem>();
  
}

void draw()
{
  background(255, 255, 255);
  ground.render();
  
  // Reset metaball bounding box
  for (int i = 0; i < screen_size; i++) {
    metabox[i] = 0;
  }
  
  int bsize = blobs.size();
  for (int i = 0; i < bsize; i++) {
    ParticleSystem b = blobs.get(i);
    b.update();
    b.render();
  }
  if (enable_metaball) metaBall(); // Add metaball
  
  // Display framerate
  if (DEBUG) {
    fill(0, 102, 153);
    text(frameRate, 10, 25);
    fill(0, 0, 0);
  }
}

// Some math functions
PVector vmin(PVector v1, PVector v2) { return new PVector(min(v1.x, v2.x), min(v1.y, v2.y), min(v1.z, v2.z)); }
PVector vmax(PVector v1, PVector v2) { return new PVector(max(v1.x, v2.x), max(v1.y, v2.y), max(v1.z, v2.z)); }
float dist2(PVector v1, PVector v2) { return ((v1.x - v2.x)*(v1.x - v2.x) + (v1.y - v2.y)*(v1.y - v2.y) + (v1.z - v2.z)*(v1.z - v2.z)); }

